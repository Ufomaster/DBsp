SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	$Create date:   18.02.2011$
--$Modify:     Zapadinskiy Anatoliy$	$Modify date:   26.12.2012$
--$Version:    2.00$   $Description: Добавление заявки в историю$
CREATE PROCEDURE [dbo].[sp_RequestsHistory_Insert]
    @EmployeeID Int,
    @RequestID Int,
    @OperationType Int    --0-insert, 1-update, 2-delete
AS
BEGIN
	SET NOCOUNT ON
    
    DECLARE @Time Int
    SET @Time = 0
        
    SELECT TOP 1 * 
    INTO #t 
    FROM RequestsHistory 
    WHERE RequestID = @RequestID 
    ORDER BY ModifyDate DESC
    
    IF @OperationType = 1
        IF EXISTS(
        SELECT * 
        FROM #t a
        INNER JOIN vw_Requests r ON r.ID = a.RequestID
        LEFT JOIN Equipment e ON e.ID = r.EquipmentID
        LEFT JOIN Tmc t ON t.ID = e.TmcID
        WHERE a.[Date] = r.[Date] AND 
              ISNULL(a.[Description], '') = ISNULL(r.[Description], '') AND 
              ISNULL(a.EmployeeName, '') = ISNULL(r.EmployeeFullName, '') AND 
              ISNULL(a.Solution, '') = ISNULL(r.Solution, '') AND 
              ISNULL(a.PlanDate, 0) = ISNULL(r.PlanDate, 0) AND 
              ISNULL(a.SolutionEmployeeName, '') = ISNULL(r.EmployeeSolFullName, '') AND 
              a.SeverityName = r.SeverityName AND 
              a.StatusName = r.StatusName AND 
              ISNULL(a.Equipment, '') = ISNULL(t.[Name] + '( инв.№ ' + e.InventoryNum + ')', '') AND 
              ISNULL(a.DepartmentName, '') = ISNULL(r.DepartmentName, '') AND 
              ISNULL(a.DesiredDate, 0) = ISNULL(r.DesiredDate, 0) AND 
              ISNULL(a.Accepted, '') = ISNULL(r.AcceptedName, '') AND 
              ISNULL(a.AcceptDate, 0) = ISNULL(r.AcceptDate, 0) AND 
              ISNULL(a.AcceptEmployeeName, '') = ISNULL(r.EmployeeAcceptFullName, '') AND               
              a.StatusID = r.[Status]
        )
        BEGIN
            SELECT 1 AS ID
            RETURN
        END        

    SELECT @Time = @Time + DATEDIFF(ss, s.StartDate, s.DateEnd)
    FROM Solutions s 
    WHERE s.RequestID = @RequestID  AND s.[Status] = 1
     
    INSERT INTO dbo.RequestsHistory(RequestID, [Date], [Description], EmployeeName,
        Solution, PlanDate, WorkTime, SolutionEmployeeName, SeverityName,
        StatusName, Equipment, DepartmentName, ModifyEmployeeID, OperationType, 
        DesiredDate, Accepted, AcceptDate, AcceptEmployeeName, StatusID) 
    SELECT
        r.ID,
        r.[Date],
        r.[Description],
        r.EmployeeFullName,
        r.Solution,
        r.PlanDate,
        @Time,
        r.EmployeeSolFullName,
        r.SeverityName,
        r.StatusName,
        t.[Name] + '( инв.№ ' + e.InventoryNum + ')',
        r.DepartmentName,
        @EmployeeID,
        @OperationType,
        r.DesiredDate,
        r.AcceptedName,
        r.AcceptDate,
        r.EmployeeAcceptFullName,
        r.[Status]
    FROM vw_Requests r
    LEFT JOIN Equipment e ON e.ID = r.EquipmentID
    LEFT JOIN Tmc t ON t.ID = e.TmcID
    WHERE r.ID = @RequestID

    DROP TABLE #t    
END
GO