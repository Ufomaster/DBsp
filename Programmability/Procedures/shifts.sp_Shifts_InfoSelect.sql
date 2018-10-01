SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   16.01.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   03.09.2014$*/
/*$Version:    1.00$   $Decription: Смены. Получние иформации по для пометки на Дате навигаторе. $*/
CREATE PROCEDURE [shifts].[sp_Shifts_InfoSelect]
    @TypesID int,
    @StartDate datetime,
    @EndDate datetime
AS
BEGIN
    SELECT
        ROW_NUMBER() OVER (ORDER BY dbo.fn_DateCropTime(s.PlanStartDate)) AS ID,
        dbo.fn_DateCropTime(s.PlanStartDate) AS EventDate
    FROM shifts.Shifts s
        INNER JOIN shifts.ShiftsTypes st ON st.ID = s.ShiftTypeID
    WHERE st.ManufactureStructureID = @TypesID AND s.PlanStartDate BETWEEN @StartDate AND @EndDate AND ISNULL(s.IsDeleted, 0) = 0
    GROUP BY dbo.fn_DateCropTime(s.PlanStartDate)
END
GO