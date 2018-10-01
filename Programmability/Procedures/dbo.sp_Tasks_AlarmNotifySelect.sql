SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleksii Poliatykin$	$Create date:   21.08.2017$
--$Modify:     Oleksii Poliatykin$	$Modify date:   02.02.2018$
--$Version:    1.00$   $Description: Список заявок для аларма
CREATE PROCEDURE [dbo].[sp_Tasks_AlarmNotifySelect]
@UserID int
AS
BEGIN
    DECLARE @EmployeeID int
    SET NOCOUNT ON    
    
    SELECT @EmployeeID = u.EmployeeID
    FROM Users u WITH (NOLOCK)
    WHERE u.ID = @UserID


    SELECT 
        t.Name as Title,
        a.Name as Description,
        s.Name as Info
    FROM Tasks a WITH (NOLOCK)
        LEFT JOIN vw_TasksStatuses s ON s.ID = a.[Status]
        LEFT JOIN vw_TasksTypes t ON t.ID = a.Type
    WHERE
           (a.[Status] = 0 AND a.EmployeeAuthorID = @EmployeeID) 
        OR (a.[Status] = 1 AND a.AssignedToEmployeeID = @EmployeeID) 
        OR (a.[Status] = 2 AND a.ControlEmployeeID = @EmployeeID) 
    ORDER BY a.CreateDate
END
GO