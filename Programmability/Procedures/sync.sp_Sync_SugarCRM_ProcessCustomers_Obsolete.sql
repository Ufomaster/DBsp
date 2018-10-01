SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   12.03.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   17.04.2013$*/
/*$Version:    1.00$   $Decription: синхронизация CRM вставка апдейт делит контрагнетов $*/
CREATE PROCEDURE [sync].[sp_Sync_SugarCRM_ProcessCustomers_Obsolete]
    @ID nvarchar(36), 
    @OperationType nvarchar(50), 
    @PrimaryEntityCodeCRM nvarchar(36),
    @CustomerID int = NULL
AS
BEGIN
    EXECUTE AS USER = 'SpeklerUser'
    SET NOCOUNT ON
    DECLARE @cust TABLE(ID int)
    
    IF @OperationType = 'insert'
    BEGIN
        INSERT INTO Customers(CodeCRM, ShortName, [Name], TaxCode, EDRPOU, CreateDate, Phone, Fax, Website, CreatedByCode, CreatedBy, Deleted, [SyncCRM])
        OUTPUT INSERTED.ID INTO @cust
        SELECT @PrimaryEntityCodeCRM, cc.ShortName, cc.[Name], cc.TIN, cc.EDRPOU, GetDate(), cc.Phone, cc.Fax, cc.Website, cc.CreatedByCode, cc.CreatedBy, 0, 1
        FROM Sync.CRMCustomers cc
        WHERE cc.CodeCRM = @PrimaryEntityCodeCRM AND cc.CRMTransactionID = @ID
    END
    ELSE
    IF @OperationType = 'update'
    BEGIN
        UPDATE a
        SET
           a.CodeCRM = @PrimaryEntityCodeCRM,
           a.ShortName = cc.ShortName,
           a.[Name] = cc.[Name],
           a.TaxCode = cc.TIN,
           a.EDRPOU = cc.EDRPOU,
           a.Phone = cc.Phone,
           a.Fax = cc.Fax,
           a.Website = cc.Website,
           a.CreatedByCode = cc.CreatedByCode,
           a.CreatedBy = cc.CreatedBy,
           a.Deleted = 0,
           a.SyncCRM = 1
        FROM Customers a
        INNER JOIN Sync.CRMCustomers cc ON cc.CodeCRM = @PrimaryEntityCodeCRM AND cc.CRMTransactionID = @ID
        WHERE a.ID = @CustomerID
        
        INSERT INTO @cust(ID)
        SELECT @CustomerID
    END
    ELSE
    IF @OperationType = 'delete'
    BEGIN
        IF EXISTS(SELECT TOP 1 * FROM dbo.Agreements agr WHERE agr.CustomerID = @CustomerID)
           OR
           EXISTS(SELECT TOP 1 * FROM dbo.CustomerAddress ca WHERE ca.CustomerID = @CustomerID)
           OR
           EXISTS(SELECT TOP 1 * FROM dbo.CustomerContacts cuc WHERE cuc.CustomerID = @CustomerID)
           OR
           EXISTS(SELECT TOP 1 * FROM ProductionOrders po WHERE po.CustomerID = @CustomerID OR po.SpeklCustomerID = @CustomerID)
        BEGIN
            UPDATE a
            SET
               a.Deleted = 1,
               a.SyncCRM = 1
            FROM Customers a
            WHERE a.ID = @CustomerID
        END
        ELSE
        BEGIN
            DELETE FROM Customers
            WHERE ID = @CustomerID
        END

        INSERT INTO @cust(ID)
        SELECT @CustomerID
    END

    SELECT ID FROM @cust
    REVERT;
END
GO