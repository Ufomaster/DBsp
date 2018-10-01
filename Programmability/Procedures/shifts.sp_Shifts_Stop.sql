SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   17.11.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   02.06.2017$*/
/*$Version:    1.00$   $Decription: Остановка смены$*/
CREATE PROCEDURE [shifts].[sp_Shifts_Stop]
    @ID int,
    @FactStartDate datetime = NULL,
    @FactEndDate datetime = NULL,
    @EmployeeID int
AS
BEGIN
	SET NOCOUNT ON;

    SET @FactEndDate = ISNULL(@FactEndDate, GetDate())

    UPDATE s SET s.FactEndDate = @FactEndDate
    FROM shifts.Shifts s
    WHERE ID = @ID

    EXEC shifts.sp_Shifts_AdjustEGFRanges @ID, @FactStartDate, @FactEndDate, @EmployeeID
END
GO