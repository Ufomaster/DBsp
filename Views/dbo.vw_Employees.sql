SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$			$Create date:   16.02.2011$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   09.03.2017$*/
/*$Version:    1.00$   $Description: Вьюшка с данными пользователя*/
CREATE VIEW [dbo].[vw_Employees]
AS
    SELECT 
        e.ID,
        e.FullName,
        e.EMail,
        e.Comments,
        e.DepartmentPositionID,
        e.IsDismissed,
        e.Cellular,
        e.Code1C,
        e.ContractType,
        e.UserCode1C AS TabNumber,
        e.INN as INN,
        d.[Name] AS DepartmentName,
        p.[Name] AS PositionName,
        d.ID AS DepartmentID,
        d.[Name] + ' - ' + p.[Name] AS DepartmentPositionName,
        CASE WHEN e.Code1C IS NULL THEN 0 ELSE 1 END AS [Sync1c]
    FROM dbo.Employees e
    LEFT JOIN DepartmentPositions dp ON dp.ID = e.DepartmentPositionID
    LEFT JOIN Positions p ON p.ID = dp.PositionID
    LEFT JOIN Departments d ON d.ID = dp.DepartmentID
GO