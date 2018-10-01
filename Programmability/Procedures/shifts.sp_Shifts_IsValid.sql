SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   02.05.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   03.09.2015$*/
/*$Version:    1.00$   $Decription: Смены. Проверка$*/
CREATE PROCEDURE [shifts].[sp_Shifts_IsValid]
    @ShiftID int,
    @SDate datetime, 
    @Edate datetime
AS
BEGIN   
    IF EXISTS(SELECT ID FROM shifts.Shifts a
              WHERE @SDate < a.PlanEndDate AND @EDate > a.PlanStartDate AND ISNULL(a.IsDeleted, 0) = 0
                  AND a.ID <> @ShiftID 
                  AND a.ShiftTypeID =(SELECT TOP 1 ShiftTypeID FROM shifts.Shifts
                                      WHERE ID = @ShiftID))
        SELECT 1
    ELSE
        SELECT 0
END
GO