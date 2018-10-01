SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   13.03.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   14.03.2013$*/
/*$Version:    1.00$   $Decription: синхронизация CRM вставка апдейт делит AddressTypes $*/
CREATE PROCEDURE [sync].[sp_Sync_SugarCRM_ProcessAddressTypes_Obsolete]
AS
BEGIN
    EXECUTE AS USER = 'SpeklerUser'
    SET NOCOUNT ON

    INSERT INTO dbo.CustomerAddressTypes([Name])
    SELECT a.[Type]
    FROM sync.CRMAddresses a
    LEFT JOIN dbo.CustomerAddressTypes cat ON cat.[Name] = a.[Type]
    WHERE cat.ID IS NULL
    GROUP BY a.[Type]
    REVERT;       
END
GO