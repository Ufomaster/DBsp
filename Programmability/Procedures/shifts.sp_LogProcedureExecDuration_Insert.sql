SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   22.10.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   22.10.2015$*/
/*$Version:    1.00$   $Description: Логирование вызова процедуры. Вызывается в коде процедур$*/
create PROCEDURE [shifts].[sp_LogProcedureExecDuration_Insert]
    @ProcedureName varchar(255),
    @LOG_StartDate datetime
AS
BEGIN
    INSERT INTO shifts.LogProcedureExecDuration(Name, EmployeeID, Duration, SPID) 
    SELECT @ProcedureName, EmployeeID, DATEDIFF(ms, @LOG_StartDate, GetDate()), @@SPID 
    FROM #CurrentUser
END
GO