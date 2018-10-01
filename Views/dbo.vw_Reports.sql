SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   13.05.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   13.05.2011$
--$Version:    1.00$   $Description: $
CREATE VIEW [dbo].[vw_Reports] AS
    SELECT 
        r.ID, 
        r.ReportGroupID, 
        /*r.EmployeeID,*/ 
        r.[Name], 
        r.CreateDate, 
        r.ChangeDate,
        r.[Description], 
        r.VersionMajor, 
        r.VersionMinor, 
        r.Params, 
        r.Report,
        /*  e.FullName as Employee,*/
        CAST(r.VersionMajor AS Varchar) + '.' + CAST(r.VersionMinor AS Varchar) AS Version
    FROM Reports r
    /*LEFT JOIN Employees e ON r.EmployeeID  = e.ID*/
GO