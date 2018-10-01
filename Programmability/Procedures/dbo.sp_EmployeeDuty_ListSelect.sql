SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   30.01.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   29.07.2013$*/
/*$Version:    1.00$   $Decription: $*/
CREATE PROCEDURE [dbo].[sp_EmployeeDuty_ListSelect]
AS
BEGIN
    SELECT e.ID, e.FullName, e.Cellular, a.[Date]
    FROM EmployeeDuty a 
    INNER JOIN vw_Employees e ON e.ID = a.EmployeeID AND e.IsDismissed = 0
    WHERE [Date] = dbo.fn_DateCropTime(GetDate())

    UNION ALL

    SELECT e.ID, e.FullName, e.Cellular, NULL
    FROM EmployeeDuty a 
    INNER JOIN vw_Employees e ON e.ID = a.EmployeeID AND e.IsDismissed = 0
    WHERE [Date] <> dbo.fn_DateCropTime(GetDate()) AND a.EmployeeID NOT IN (SELECT EmployeeID FROM EmployeeDuty WHERE [Date] = dbo.fn_DateCropTime(GetDate()))
    GROUP BY e.ID, e.FullName, e.Cellular
END
GO