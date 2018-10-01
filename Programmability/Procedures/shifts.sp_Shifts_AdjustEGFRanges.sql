SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   10.03.2017$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   10.03.2017$*/
/*$Version:    1.00$   $Decription: фикс диапазонов таблицы EmployeeGroupsFact по факт датам стопа запуска смены$*/
create PROCEDURE [shifts].[sp_Shifts_AdjustEGFRanges]
    @ID int,
    @FactStartDate datetime = NULL,
    @FactEndDate datetime = NULL,
    @EmployeeID int
AS
BEGIN
	SET NOCOUNT ON;
    
    --1. если егф выходит и стартом и стопом за пределы даты останова - удаляем запись
    UPDATE ef
    SET ef.IsDeleted = 1
    FROM shifts.EmployeeGroupsFact ef
    WHERE ISNULL(ef.AutoCreate, 0) = 0 AND ef.ShiftID = @ID AND ISNULL(ef.IsDeleted, 0) = 0
       AND ef.EndDate > ISNULL(@FactEndDate, GetDate()) AND ef.StartDate >= ISNULL(@FactEndDate, GetDate())

    UPDATE d
    SET d.IsDeleted = 1
    FROM shifts.EmployeeGroupsFact ef
    INNER JOIN shifts.EmployeeGroupsFactDetais d ON d.EmployeeGroupsFactID = ef.ID
    WHERE ISNULL(ef.AutoCreate, 0) = 0 AND ef.ShiftID = @ID AND ISNULL(ef.IsDeleted, 0) = 0
       AND ef.EndDate > ISNULL(@FactEndDate, GetDate()) AND ef.StartDate >= ISNULL(@FactEndDate, GetDate())

    --2. апдейтнем дату енда у всех записей, которые выходят ендом за пределы смены.
    UPDATE ef
    SET ef.EndDate = ISNULL(@FactEndDate, GetDate())
    FROM shifts.EmployeeGroupsFact ef
    WHERE ISNULL(ef.AutoCreate, 0) = 0 AND ef.ShiftID = @ID AND ISNULL(ef.IsDeleted, 0) = 0
       AND ef.EndDate > ISNULL(@FactEndDate, GetDate())
       
    --3. Если егф выходит стартом и ендом до предела @FactStartDate - удаляем запись
    
    UPDATE ef
    SET ef.IsDeleted = 1
    FROM shifts.EmployeeGroupsFact ef
    WHERE ISNULL(ef.AutoCreate, 0) = 0 AND ef.ShiftID = @ID AND ISNULL(ef.IsDeleted, 0) = 0
       AND ef.StartDate < @FactStartDate AND ef.EndDate <= @FactStartDate

    UPDATE d
    SET d.IsDeleted = 1
    FROM shifts.EmployeeGroupsFact ef
    INNER JOIN shifts.EmployeeGroupsFactDetais d ON d.EmployeeGroupsFactID = ef.ID
    WHERE ISNULL(ef.AutoCreate, 0) = 0 AND ef.ShiftID = @ID AND ISNULL(ef.IsDeleted, 0) = 0
       AND ef.StartDate < @FactStartDate AND ef.EndDate <= @FactStartDate
       
    --4. апдейтнем дату старта у всех записей, которые выходят стартом до предела смены.
    UPDATE ef
    SET ef.StartDate = @FactStartDate
    FROM shifts.EmployeeGroupsFact ef
    WHERE ISNULL(ef.AutoCreate, 0) = 0 AND ef.ShiftID = @ID AND ISNULL(ef.IsDeleted, 0) = 0
       AND ef.StartDate <= @FactStartDate
END
GO