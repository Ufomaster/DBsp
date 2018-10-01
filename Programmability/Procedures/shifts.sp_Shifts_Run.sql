SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   10.04.2014$*/
/*$Modify:     Oleksiy Polyatykin$    $Modify date:   14.02.2018$*/
/*$Version:    1.00$   $Decription: Смены. Старт.$*/
CREATE PROCEDURE [shifts].[sp_Shifts_Run]
    @ID int,
    @EmployeeID int
AS
BEGIN
    DECLARE @PlanStartDate datetime, @FactStartDate datetime, @FactEndDate datetime
    SELECT @FactStartDate = GETDATE(), @FactEndDate = ISNULL(FactEndDate, PlanEndDate), @PlanStartDate = s.PlanStartDate
    FROM shifts.Shifts s
    WHERE s.ID = @ID
    
    IF (SELECT (DATEDIFF(hh,s.PlanStartDate, GETDATE())) FROM shifts.shifts s WHERE s.ID = @ID ) < -2 
        SET  @FactStartDate = @PlanStartDate
  
    UPDATE s
    SET s.FactStartDate = @FactStartDate
    FROM shifts.Shifts s
    WHERE s.ID = @ID

    EXEC shifts.sp_Shifts_AdjustEGFRanges @ID, @FactStartDate, @FactEndDate, @EmployeeID
END
GO