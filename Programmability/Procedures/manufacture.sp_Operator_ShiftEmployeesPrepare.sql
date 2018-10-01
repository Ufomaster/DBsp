SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   04.08.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   04.08.2014$*/
/*$Version:    1.00$   $Decription: Запоминаем список все емплоев из бригады залогиненного пользака$*/
create PROCEDURE [manufacture].[sp_Operator_ShiftEmployeesPrepare]
    @EmployeeID int
AS
BEGIN
    INSERT INTO #LoggedInUsers(ID, EmployeeID, EmployeeName, Status, DateIn, DateOut)
    SELECT u.ID, e.ID AS EmployeeID, e.FullName, 0, NULL, NULL
    FROM shifts.EmployeeGroupsDetails a
    INNER JOIN shifts.EmployeeGroups b ON a.EmployeeGroupID = b.ID
    INNER JOIN vw_Employees e ON e.ID = a.EmployeeID AND e.ID <> @EmployeeID
    INNER JOIN vw_Users u ON e.ID = u.EmployeeID
    WHERE a.EmployeeGroupID = (SELECT TOP 1 a.EmployeeGroupID FROM shifts.EmployeeGroupsDetails a WHERE a.EmployeeID = @EmployeeID) 
        AND u.IsBlocked = 0
END
GO