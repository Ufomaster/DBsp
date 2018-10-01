SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   12.03.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   14.03.2013$*/
/*$Version:    1.00$   $Decription: синхронизация CRM вставка апдейт делит CustomerTypes $*/
CREATE PROCEDURE [sync].[sp_Sync_SugarCRM_ProcessTypes_Obsolete]
    @ID nvarchar(36), 
    @PrimaryEntityCodeCRM nvarchar(36),
    @CustomerID int = NULL
AS
BEGIN
    EXECUTE AS USER = 'SpeklerUser'
    SET NOCOUNT ON
    IF EXISTS(SELECT ct.ID FROM sync.CRMCustomerTypes ct
              WHERE ct.CRMTransactionID = @ID AND ct.CustomerCodeCRM = @PrimaryEntityCodeCRM
              AND ct.[Type] = 'Клиент')
        UPDATE c SET c.isClient = 1 FROM Customers c WHERE ID = @CustomerID
    ELSE
        UPDATE c SET c.isClient = 0 FROM Customers c WHERE ID = @CustomerID
                    
                    
    IF EXISTS(SELECT ct.ID FROM sync.CRMCustomerTypes ct
              WHERE ct.CRMTransactionID = @ID AND ct.CustomerCodeCRM = @PrimaryEntityCodeCRM
              AND ct.[Type] = 'Поставщик')
        UPDATE c SET c.isSupplier = 1 FROM Customers c WHERE ID = @CustomerID
    ELSE
        UPDATE c SET c.isSupplier = 0 FROM Customers c WHERE ID = @CustomerID
    REVERT;
END
GO