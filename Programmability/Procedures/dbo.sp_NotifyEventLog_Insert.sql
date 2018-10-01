SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   03.02.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   03.02.2012$*/
/*$Version:    1.00$   $Decription: Логирование отсылки$*/
CREATE PROCEDURE [dbo].[sp_NotifyEventLog_Insert]
    @NotifyEventID Int, 
    @EmployeeID Int, 
    @TargetEmail Varchar(150),
    @Msg Varchar(8000)
AS
BEGIN
    INSERT INTO NotifyEventLog(NotifyEventID, EmployeeID, TargetEmail, Msg)
    SELECT @NotifyEventID, @EmployeeID, @TargetEmail, @Msg
    SELECT 1 AS Res
END
GO