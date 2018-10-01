SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   08.06.2015$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   26.05.2017$*/
/*$Version:    1.00$   $Decription: Добавление EmployeeID*/
CREATE PROCEDURE [shifts].[sp_EmployeeGroupsFact_InsertOne]
    @EmployeeID int,
    @ShiftID int,
    @WorkPlaceID int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Err Int, @StartDate datetime, @EndDate datetime
    DECLARE @T table(ID int)
    DECLARE @ID int    
    SET XACT_ABORT ON
    
    IF EXISTS(SELECT * FROM shifts.Shifts s WHERE s.FactEndDate IS NOT NULL AND s.ID = @ShiftID)
    BEGIN
        RAISERROR ('Рабочая смена остановлена. Изменение состава смены запрещено', 16, 1)
        RETURN
    END
    BEGIN TRAN
    BEGIN TRY
        /*надо проверить есть ли уже этот имплоии в смене на этом рабочем месте.*/
        /*если есть - не добавлять.*/
        /*Если нет - добавляем.*/
        IF NOT EXISTS(SELECT g.ID
                      FROM shifts.EmployeeGroupsFact g
                      INNER JOIN shifts.EmployeeGroupsFactDetais d ON d.EmployeeGroupsFactID = g.ID AND d.EmployeeID = @EmployeeID AND ISNULL(d.IsDeleted, 0) = 0
                      WHERE g.ShiftID = @ShiftID AND g.WorkPlaceID = @WorkPlaceID AND ISNULL(g.IsDeleted, 0) = 0 AND ISNULL(g.AutoCreate,0) = 0)
        BEGIN
            SELECT @StartDate = ISNULL(s.FactStartDate, s.PlanStartDate), @EndDate = s.PlanEndDate 
            FROM shifts.Shifts s 
            WHERE s.ID = @ShiftID
            
            INSERT INTO shifts.EmployeeGroupsFact(StartDate, EndDate, IP, WorkPlaceID, ShiftID, AutoCreate)
            OUTPUT INSERTED.ID INTO @T
            SELECT @StartDate, @EndDate, ss.IP, @WorkPlaceID, @ShiftID, 0
            FROM manufacture.StorageStructure ss
            WHERE ss.ID = @WorkPlaceID

            INSERT INTO shifts.EmployeeGroupsFactDetais(EmployeeGroupsFactID, EmployeeID)        
            SELECT e.ID, @EmployeeID
            FROM @T e
        END
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err;
    END CATCH
END
GO