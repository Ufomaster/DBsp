SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   01.10.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   03.11.2014$*/
/*$Version:    1.00$   $Description: выборка ЗЛ$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardAdaptingEmployees_Select]
AS
BEGIN
    SELECT 
        E.*,
        dp.DepartmentPositionName,
        vwe.FullName
    FROM ProductionCardAdaptingEmployees AS E
    LEFT JOIN vw_Employees AS vwe ON vwe.DepartmentPositionID = e.DepartmentPositionID
    LEFT JOIN vw_DepartmentPositions dp ON dp.ID = e.DepartmentPositionID
END
GO