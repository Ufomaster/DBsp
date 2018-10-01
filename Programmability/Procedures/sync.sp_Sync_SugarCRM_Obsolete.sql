SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   05.03.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   22.01.2015$*/
/*$Version:    1.00$   $Decription: синхронизация CRM $*/
CREATE PROCEDURE [sync].[sp_Sync_SugarCRM_Obsolete]
AS
BEGIN
    EXECUTE AS USER = 'SpeklerUser'
    --RAISERROR('ошибка синронизации', 16, 1)
    SET NOCOUNT ON
    
    INSERT INTO sync.CRMCallLog(EntityTypeID) 
    SELECT 0

    DECLARE @Err Int    
    SET XACT_ABORT ON
    DECLARE @ID nvarchar(36), @OperationType nvarchar(50), @EntityType nvarchar(50), 
        @PrimaryEntityCodeCRM nvarchar(36), @SecondaryEntityCodeCRM nvarchar(36)

    DECLARE @ErrorMessage nvarchar(4000), @CustomerID int, @OldCustomerID int
    DECLARE @TaxCode varchar(32), @EDRPOU varchar(20), @Name varchar(128), @ShortName varchar(255), @OldTaxCode varchar(32), @OldEDRPOU varchar(20)

    DECLARE @cust TABLE(ID int)

    BEGIN TRAN
    BEGIN TRY
        EXEC Sync.sp_Sync_SugarCRM_ProcessAddressTypes

        DECLARE #Cur CURSOR FOR SELECT ID, OperationType, EntityType, PrimaryEntityCodeCRM, SecondaryEntityCodeCRM
                                FROM Sync.CRMTransactions
                                WHERE [Status] = 'new' AND EntityType = 'account'
                                ORDER BY SortOrder
        OPEN #Cur
        FETCH NEXT FROM #Cur INTO @ID, @OperationType,  @EntityType,  @PrimaryEntityCodeCRM, @SecondaryEntityCodeCRM 
        WHILE @@FETCH_STATUS = 0
        BEGIN
            /*Status = 'new' 'in process' 'error' 'processed'*/
--Start
            UPDATE Sync.CRMTransactions
            SET [Status] = 'in process', ModifyDate = GETDATE()
            WHERE ID = @ID
            /*OperationType = 'insert' 'update' 'delete' 'merge'*/
            --какой бы нибыл OperationType всегда ищем контрагента.
            --ищем по кодуСРМ, если не нашли, to по кодуЕГРОПУ, по ИНН
            --@EntityType не обрабатываем пока.
            
--синхронизация контрагента
            SET @CustomerID = NULL

            SELECT @TaxCode = TIN, @EDRPOU = EDRPOU, @Name = [Name], @ShortName = ShortName
            FROM Sync.CRMCustomers
            WHERE CodeCRM = @PrimaryEntityCodeCRM AND CRMTransactionID = @ID
            --ищем конрагента по коду СРМ
            SELECT @CustomerID = c.ID
            FROM Customers c
            WHERE c.CodeCRM = @PrimaryEntityCodeCRM
            IF @CustomerID IS NULL --если не нашли по коду СРМ, ищем по ЕДРПОУ
                SELECT @CustomerID = c.ID
                FROM Customers c
                WHERE c.EDRPOU = @EDRPOU AND ISNULL(c.EDRPOU, '') <> ''
            IF @CustomerID IS NULL --если не нашли по ЕДРПОУ, ишем по ИНН
                SELECT @CustomerID = c.ID
                FROM Customers c
                WHERE c.TaxCode = @TaxCode AND ISNULL(c.TaxCode, '') <> ''
            IF @CustomerID IS NULL --если по ИНН не нашли, ищем по Наименованию, но только среди не синхронизированных
                SELECT @CustomerID = c.ID
                FROM Customers c
                WHERE c.[Name] = @Name AND ISNULL(c.[Name], '') <> '' AND c.CodeCRM IS NULL
            IF @CustomerID IS NULL --если и по Наименованию не нашли, ищем по Наименованию Краткому, но только среди не синхронизированных
                SELECT @CustomerID = c.ID
                FROM Customers c
                WHERE c.ShortName = @ShortName AND ISNULL(c.ShortName, '') <> '' AND c.CodeCRM IS NULL
                

--OperationType = 'insert' OR 'update'
            IF @OperationType = 'insert' OR @OperationType = 'update'
            BEGIN
                --если не нашли контрагента - INSERT
                IF @CustomerID IS NULL
                    INSERT INTO @cust(ID)
                    EXEC Sync.sp_Sync_SugarCRM_ProcessCustomers @ID, 'insert', @PrimaryEntityCodeCRM, @CustomerID
                ELSE --если нашли - апдейтим
                BEGIN
                    INSERT INTO @cust(ID)
                    EXEC Sync.sp_Sync_SugarCRM_ProcessCustomers @ID, 'update', @PrimaryEntityCodeCRM, @CustomerID
                    --удаляем удаленные адреса и контакты
                    EXEC Sync.sp_Sync_SugarCRM_ProcessContacts @ID, @OperationType, @PrimaryEntityCodeCRM, @CustomerID, NULL
                    EXEC Sync.sp_Sync_SugarCRM_ProcessAddresses @ID, @OperationType, @PrimaryEntityCodeCRM, @CustomerID, NULL                    
                END
            END
            ELSE
--OperationType = 'delete'
            IF @OperationType = 'delete'
            BEGIN
                --если не нашли контрагента - ничего с ним не делаем
                --иначе пытаемся удалить, если что - помечаем удаленным
                IF @CustomerID IS NOT NULL
                BEGIN
                    EXEC Sync.sp_Sync_SugarCRM_ProcessAddresses @ID, 'delete', @PrimaryEntityCodeCRM, @CustomerID, NULL
                    EXEC Sync.sp_Sync_SugarCRM_ProcessContacts @ID, 'delete', @PrimaryEntityCodeCRM, @CustomerID, NULL

                    INSERT INTO @cust(ID)
                    EXEC Sync.sp_Sync_SugarCRM_ProcessCustomers @ID, 'delete', @PrimaryEntityCodeCRM, @CustomerID
                END
            END
            ELSE
--OperationType = 'merge'
            IF @OperationType = 'merge'
            BEGIN
                --если не нашли контрагента - INSERT
                IF @CustomerID IS NULL
                    INSERT INTO @cust(ID)
                    EXEC Sync.sp_Sync_SugarCRM_ProcessCustomers @ID, 'insert', @PrimaryEntityCodeCRM, @CustomerID
                ELSE
                BEGIN
                --обновить ссылки старого контрагента на новые.
                --ищем старого контрагента.
                    SET @OldCustomerID = NULL
                    SELECT @OldTaxCode = TIN, @OldEDRPOU = EDRPOU 
                    FROM Sync.CRMCustomers
                    WHERE CodeCRM = @SecondaryEntityCodeCRM AND CRMTransactionID = @ID
                    --ищем конtрагента по коду СРМ
                    SELECT @OldCustomerID = c.ID
                    FROM Customers c
                    WHERE c.CodeCRM = @SecondaryEntityCodeCRM
                    IF @OldCustomerID IS NULL --если не нашли по коду СРМ, ищем по ЕДРПОУ
                        SELECT @OldCustomerID = c.ID
                        FROM Customers c
                        WHERE c.EDRPOU = @OldEDRPOU AND c.EDRPOU <> ''
                    IF @OldCustomerID IS NULL --если не нашли по ЕДРПОУ, ишем по ИНН
                        SELECT @OldCustomerID = c.ID
                        FROM Customers c
                        WHERE c.TaxCode = @OldTaxCode AND c.TaxCode <> ''
                    -- собственно апдейт
                    IF @OldCustomerID IS NOT NULL
                    BEGIN
                        UPDATE po
                        SET po.CustomerID = @CustomerID
                        FROM ProductionOrders po 
                        WHERE po.CustomerID = @OldCustomerID
                        
                        UPDATE po
                        SET po.SpeklCustomerID = @CustomerID
                        FROM ProductionOrders po 
                        WHERE po.SpeklCustomerID = @OldCustomerID

                        --пытаемся удалить старого контрагента
                        INSERT INTO @cust(ID)
                        EXEC Sync.sp_Sync_SugarCRM_ProcessCustomers @ID, 'delete', @SecondaryEntityCodeCRM, @OldCustomerID
                    END
                    
                    INSERT INTO @cust(ID)
                    SELECT @CustomerID 
                END
            END

            --берем айди контрагента, которого обработали
            SELECT @CustomerID = ID FROM @cust
            --чистим таблицу
            DELETE FROM @cust
            
--типы контрагентов
            IF @OperationType = 'insert' OR @OperationType = 'update'
            BEGIN
                --delete or merge нас не интерисует                
                EXEC Sync.sp_Sync_SugarCRM_ProcessTypes @ID, @PrimaryEntityCodeCRM, @CustomerID
            END
--контакты (удаление в разделе манипуляций с контрагентами)
            IF @OperationType = 'insert' OR @OperationType = 'update'
            BEGIN  
                --добавим добавленные, изменим измененные
                EXEC Sync.sp_Sync_SugarCRM_ProcessContacts @ID, @OperationType, @PrimaryEntityCodeCRM, @CustomerID, @OldCustomerID   
            END
            ELSE
            IF @OperationType = 'merge'
            BEGIN
                EXEC Sync.sp_Sync_SugarCRM_ProcessContacts @ID, 'merge', @PrimaryEntityCodeCRM, @CustomerID, @OldCustomerID
            END

--синхронизация адресов
            IF @OperationType = 'insert' OR @OperationType = 'update'
            BEGIN
                --добавим добавленные, изменим измененные
                EXEC Sync.sp_Sync_SugarCRM_ProcessAddresses @ID, @OperationType, @PrimaryEntityCodeCRM, @CustomerID, @OldCustomerID 
            END
            ELSE
            IF @OperationType = 'merge'
            BEGIN
                EXEC Sync.sp_Sync_SugarCRM_ProcessAddresses @ID, 'merge', @PrimaryEntityCodeCRM, @CustomerID, @OldCustomerID
            END
--Finish
            UPDATE Customers
            SET Customers.[SyncCRM] = 1
            WHERE ID = @CustomerID

            UPDATE Sync.CRMTransactions
            SET [Status] = 'processed', ErrorMsg = NULL, ModifyDate = GETDATE()
            WHERE ID = @ID

            FETCH NEXT FROM #Cur INTO @ID, @OperationType,  @EntityType,  @PrimaryEntityCodeCRM, @SecondaryEntityCodeCRM 
        END
        COMMIT TRAN
        CLOSE #Cur
        DEALLOCATE #Cur
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        SELECT @ErrorMessage = CAST(ERROR_NUMBER() AS varchar(10)) + ': ' + 
            ERROR_MESSAGE() + ISNULL(' Procedure ' + ERROR_PROCEDURE() + ',', '') + ' Line ' + CAST(ERROR_LINE() AS varchar(10))
        UPDATE Sync.CRMTransactions
        SET [Status] = 'error', ErrorMsg = @ErrorMessage, ModifyDate = GETDATE()
        WHERE ID = @ID
        --ругаемся вызывающему
        EXEC sp_RaiseError @ID = @Err
    END CATCH
    REVERT;
END
GO