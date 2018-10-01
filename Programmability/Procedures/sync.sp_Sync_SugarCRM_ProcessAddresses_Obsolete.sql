SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   12.03.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   15.05.2013$*/
/*$Version:    1.00$   $Decription: синхронизация CRM вставка апдейт делит Addresses $*/
CREATE PROCEDURE [sync].[sp_Sync_SugarCRM_ProcessAddresses_Obsolete]
    @ID nvarchar(36), 
    @OperationType nvarchar(50),
    @PrimaryEntityCodeCRM nvarchar(36),
    @CustomerID int = NULL,
    @OldCustomerID int = NULL
AS
BEGIN
    EXECUTE AS USER = 'SpeklerUser'
    SET NOCOUNT ON    
    DECLARE @AddressID int
    IF @OperationType = 'insert' OR @OperationType = 'update'
    BEGIN
        --insert  
        INSERT INTO dbo.CustomerAddress(CustomerID, AddressTypeID, 
            [ZipCode], [Country], [Region], [City], [Address], [CodeCRM], 
            [Description], [CreateDate], [SyncCRM])
        SELECT @CustomerID, cat.ID,
            ca.ZipCode, ca.Country, ca.Region, ca.City, ca.[Address], ca.CodeCRM,
            ca.[Description], ca.CreateDate, 1
        FROM Sync.CRMAddresses ca
        LEFT JOIN dbo.CustomerAddress a ON a.CodeCRM = ca.CodeCRM AND a.CustomerID = @CustomerID
        LEFT JOIN dbo.CustomerAddressTypes cat ON cat.[Name] = ca.[Type]
        WHERE ca.CRMTransactionID = @ID AND ca.CustomerCodeCRM = @PrimaryEntityCodeCRM
           AND a.ID IS NULL

        --update
        UPDATE a
        SET a.AddressTypeID = cat.ID,
            a.[ZipCode] = ca.ZipCode,
            a.[Country] = ca.Country,
            a.[Region] = ca.Region,
            a.[City] = ca.City,
            a.[Address] = ca.[Address],
            a.[Description] = ca.[Description],
            a.[CreateDate] = ca.CreateDate,
            a.Deleted = 0,
            a.SyncCRM = 1
        FROM dbo.CustomerAddress a
        INNER JOIN Sync.CRMAddresses ca ON ca.CodeCRM = a.CodeCRM AND ca.CRMTransactionID = @ID AND ca.CustomerCodeCRM = @PrimaryEntityCodeCRM
        LEFT JOIN dbo.CustomerAddressTypes cat ON cat.[Name] = ca.[Type]
        WHERE a.CustomerID = @CustomerID
        
        --delete
        DECLARE #CurAddD CURSOR FOR SELECT ca.ID -- выбираем удаленные контакты у контрагента.
                                  FROM CustomerAddress ca
                                  LEFT JOIN sync.CRMAddresses crma ON crma.CustomerCodeCRM = @PrimaryEntityCodeCRM AND ca.CodeCRM = crma.CodeCRM
                                     AND crma.CRMTransactionID = @ID
                                  WHERE ca.CustomerID = @CustomerID AND crma.CodeCRM IS NULL AND ca.CodeCRM IS NOT NULL --ca.CodeCRM IS NOT NULL- удаляем только среди синхронизированных
        OPEN #CurAddD
        FETCH NEXT FROM #CurAddD INTO @AddressID
        WHILE @@FETCH_STATUS = 0
        BEGIN
             --пока нигде адреса не используются
        /*           IF EXISTS(SELECT TOP 1 * FROM dbo.ProductionOrders po WHERE po.CustomerContactID = @ContactID )
              OR
              EXISTS(SELECT TOP 1 * FROM dbo.ProductionOrders po WHERE po.SpeklContactID = @ContactID)
              OR
              EXISTS(SELECT TOP 1 * FROM dbo.CustomerAddress ca WHERE ca.ContactID = @ContactID)
              OR
              EXISTS(SELECT TOP 1 * FROM dbo.Agreements ag WHERE ag.ContactID = @ContactID)
           BEGIN
               UPDATE a
               SET
                   a.Deleted = 1,
                   a.SyncCRM = 1
               FROM CustomerContacts a
               WHERE a.ID = @ContactID
           END
           ELSE*/
               DELETE FROM CustomerAddress
               WHERE ID = @AddressID

           FETCH NEXT FROM #CurAddD INTO @AddressID
        END
        CLOSE #CurAddD
        DEALLOCATE #CurAddD
   END
   ELSE
   IF @OperationType = 'merge'
   BEGIN
       -- перемещаем все наши адреса удаляемого контрагента новому контрагенту
       UPDATE ca
       SET ca.CustomerID = @CustomerID, ca.SyncCRM = CASE WHEN ca.CodeCRM IS NULL THEN 0 ELSE 1 END
       FROM dbo.CustomerAddress ca
       WHERE ca.CustomerID = @OldCustomerID
   END
   ELSE
   IF @OperationType = 'delete'
   BEGIN
       DECLARE #CurAdd CURSOR FOR SELECT ID FROM CustomerAddress WHERE CustomerID = @CustomerID
       OPEN #CurAdd
       FETCH NEXT FROM #CurAdd INTO @AddressID
       WHILE @@FETCH_STATUS = 0
       BEGIN
             --пока нигде адреса не используются
/*           IF EXISTS(SELECT TOP 1 * FROM dbo.ProductionOrders po WHERE po.CustomerContactID = @ContactID )
              OR
              EXISTS(SELECT TOP 1 * FROM dbo.ProductionOrders po WHERE po.SpeklContactID = @ContactID)
              OR
              EXISTS(SELECT TOP 1 * FROM dbo.CustomerAddress ca WHERE ca.ContactID = @ContactID)
              OR
              EXISTS(SELECT TOP 1 * FROM dbo.Agreements ag WHERE ag.ContactID = @ContactID)
           BEGIN
               UPDATE a
               SET
                   a.Deleted = 1,
                   a.SyncCRM = 1
               FROM CustomerContacts a
               WHERE a.ID = @ContactID
           END
           ELSE*/
               DELETE FROM CustomerAddress
               WHERE ID = @AddressID

           FETCH NEXT FROM #CurAdd INTO @AddressID
       END
       CLOSE #CurAdd
       DEALLOCATE #CurAdd
   END   
   REVERT;
END
GO