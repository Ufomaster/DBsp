SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   23.05.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   23.05.2012$*/
/*$Version:    1.00$   $Decription: Готовим данные на изменение$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardProcessMap_EmployeesPrepare]
    @ProductionCardProcessMapID Int
AS
BEGIN
    INSERT INTO #ProcessEmployees(_ID, EmployeeID, FullName, DepartmentPositionID, UseAdaptingFiltering, DepartmentPositionName)
    SELECT
        m.ID,
        e.ID,
        e.FullName,
        m.DepartmentPositionID,
        m.UseAdaptingFiltering,
        dp.DepartmentPositionName AS DepartmentPositionName
    FROM dbo.ProductionCardProcessMapNEEmployees m
    LEFT JOIN vw_Employees e ON e.DepartmentPositionID = m.DepartmentPositionID
    INNER JOIN vw_DepartmentPositions dp ON dp.ID = m.DepartmentPositionID
    WHERE m.ProductionCardProcessMapID = @ProductionCardProcessMapID
END
GO