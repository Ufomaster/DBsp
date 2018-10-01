SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   16.02.2011$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   08.07.2015$*/
/*$Version:    1.00$   $Description: Вьюшка с данными заявок$*/
CREATE VIEW [dbo].[vw_Requests]
AS
    SELECT 
        r.ID,
        r.[Date],
        r.[Description],
        LEFT(r.[Description], 40) AS [ShortDescription],
        r.EmployeeID,
        r.Solution,
        r.PlanDate,
        r.SolutionEmployeeID,
        r.Severity,
        r.[Status],
        r.EquipmentID,
        e.InventoryNum,
        t.[Name] AS EquipmentName,
        r.DepartmentID,
        d.[Name] AS DepartmentName,
        eCr.FullName AS EmployeeFullName,
        dpOwner.DepartmentName AS OwnerDepartmentName,
        dpOwner.DepartmentID AS OwnerDepartmentID,
        eSol.FullName AS EmployeeSolFullName,
        rs.[Name] AS StatusName,
        rsev.[Name] AS SeverityName,
        HasAttachment = (SELECT CASE COUNT(*) WHEN 0 THEN 0 ELSE 1 END  FROM dbo.RequestsAttachments WHERE RequestID = r.ID),
        HasComplains = (SELECT CASE COUNT(*) WHEN 0 THEN 0 ELSE 1 END  FROM dbo.RequestsComplains WHERE RequestID = r.ID),
        r.Deleted,
        r.DesiredDate,
        r.Accepted,
        r.AcceptDate,
        r.AcceptEmployeeID,
        ras.[Name] AS AcceptedName,
        eAcc.FullName AS EmployeeAcceptFullName,
        CASE WHEN worksStats.Cnt > 0 THEN 1 ELSE 0 END AS WorksON,
        r.WriteTime,
        DATEDIFF(hh, r.[Date], h.ModifyDate) AS [RequestTotalTime],
        h.ModifyDate AS [CloseDate],
        mc.[Name] AS MalfunctionCauseName,
        e.WorkTotalsPresent,
        r.WorkTotals,
        r.TargetID
    FROM dbo.Requests r    
    LEFT JOIN (SELECT 
                   MIN(h.ModifyDate) AS ModifyDate, 
                   h.RequestID
               FROM RequestsHistory h 
               WHERE h.StatusID = 4
               GROUP BY h.RequestID) h ON h.RequestID = r.ID
    LEFT JOIN dbo.vw_Employees eCr ON eCr.ID = r.EmployeeID
    LEFT JOIN dbo.vw_Employees eSol ON eSol.ID = r.SolutionEmployeeID
    LEFT JOIN dbo.vw_DepartmentPositions dpOwner ON dpOwner.ID = eCr.DepartmentPositionID
    LEFT JOIN dbo.RequestTarget d ON d.ID = r.TargetID
    LEFT JOIN dbo.vw_RequestStatuses rs ON rs.ID = r.[Status]
    LEFT JOIN dbo.vw_RequestSeverities rsev ON rsev.ID = r.Severity
    LEFT JOIN dbo.Equipment e ON e.ID = r.EquipmentID
    LEFT JOIN dbo.Tmc t ON t.ID = e.TmcID
    LEFT JOIN dbo.vw_RequestsAcceptStatuses ras ON ras.ID = r.Accepted
    LEFT JOIN dbo.vw_Employees eAcc ON eAcc.ID = r.AcceptEmployeeID
    LEFT JOIN MalfunctionCauses mc ON mc.ID = r.MalfunctionCauseID
    LEFT JOIN (SELECT COUNT(s.ID) AS Cnt, s.RequestID FROM Solutions s WHERE s.[Status] = 0 GROUP BY s.RequestID) worksStats ON worksStats.RequestID = r.ID
GO