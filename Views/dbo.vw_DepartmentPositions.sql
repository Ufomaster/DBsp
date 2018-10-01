SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   17.02.2011$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   03.12.2013$*/
/*$Version:    1.00$   $Description: Вьюшка с данными департаментов и должностей по ним*/
CREATE VIEW [dbo].[vw_DepartmentPositions]
AS
    SELECT 
        dp.ID,
        dp.DepartmentID,
        dp.PositionID,
        p.[Name] AS PositionName,
        p.Code1C AS PositionCode1C,
        d.[Name] AS DepartmentName,
        d.Code1C AS DepartmentCode1C,
        d.[Name] + ' - ' + p.[Name] AS DepartmentPositionName,
        d.TechResponsible,
        d.MajorDepartmentID
    FROM dbo.DepartmentPositions dp
    INNER JOIN Positions p ON p.ID = dp.PositionID
    INNER JOIN Departments d ON d.ID = dp.DepartmentID
GO