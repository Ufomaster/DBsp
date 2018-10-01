SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   25.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   25.11.2013$*/
/*$Version:    1.00$   $Description: Подготовка редактирования подписантов протокола$*/
create PROCEDURE [QualityControl].[sp_ProtocolsDetails_PrepareEmployeeTmp]
    @ID Int
AS
BEGIN    
    INSERT INTO #ProtocolsSigners(_ID, EmployeeID, EmailOnly, SignDate)
    SELECT
        ID, EmployeeID, EmailOnly, SignDate
    FROM [QualityControl].ProtocolsSigners d
    WHERE d.ProtocolID = @ID
    ORDER BY d.ID
END
GO