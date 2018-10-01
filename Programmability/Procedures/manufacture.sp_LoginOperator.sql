SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   10.02.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   10.02.2014$*/
/*$Version:    1.00$   $Decription: $*/
create PROCEDURE [manufacture].[sp_LoginOperator]
    @LoginEmployeeID Int, /*оператор которого выбрали на форме логина*/
    @SelectedEmployeeID Int /* оператор на иконку которого кликнули при логине*/
AS
BEGIN
/*   переделать на проверку Существоватья записи, Если не существует Емплоии - то Инсерт,
   если существует то апдейт. и
  ВНИМАНИЕ
   ФОРМА логина должна вернуть залогиненого пользака.
   Если выбранный пользак - отличается от залогиненого, и залогиненого небыло изначально в наборе,
   то запись о нем нужно удалить - считаем это замещением одного на другого.*/

    IF NOT EXISTS(SELECT EmployeeID FROM #LoggedInUsers WHERE EmployeeID = @LoginEmployeeID)
    BEGIN
        INSERT INTO #LoggedInUsers(ID, EmployeeID, EmployeeName, Status, DateIn, DateOut)
        SELECT u.ID, u.EmployeeID, e.FullName, 1, GETDATE(), NULL
        FROM vw_Users u
        INNER JOIN vw_Employees e ON e.ID = u.EmployeeID
        WHERE u.IsBlocked = 0 AND u.EmployeeID = @LoginEmployeeID
        
        DELETE FROM #LoggedInUsers WHERE EmployeeID = @SelectedEmployeeID            
    END
    ELSE /* существует*/
        UPDATE #LoggedInUsers
        SET [Status] = 1, DateIn = GetDate()
        WHERE EmployeeID = @LoginEmployeeID
END
GO