SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   01.04.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   13.03.2017$*/
/*$Version:    1.00$   $Decription: Создание бригады. Автоматическое$*/
CREATE PROCEDURE [shifts].[sp_EmployeeGroupsFact_Insert]
    @ArrayOfEmployeeID varchar(8000), 
    @OldEmployeeGroupFactID int,
    @IP varchar(50),
    @WorkPlaceID int,
    @ShiftID int,
    @JobStageID int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Err Int, @ID int, @ManualID int
    DECLARE @T table(ID int)
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        IF @OldEmployeeGroupFactID = -1 --попытка поиска ИД по старой незакрытой сессии (только для случаев когда меняется набор работников).
            SELECT @OldEmployeeGroupFactID = egf.ID
            FROM shifts.EmployeeGroupsFact egf
            WHERE egf.ShiftID = @ShiftID AND egf.WorkPlaceID = @WorkPlaceID AND egf.StartDate IS NOT NULL AND
                  egf.EndDate IS NULL AND egf.JobStageID = @JobStageID

        EXEC shifts.sp_EmployeeGroupsFact_Close @OldEmployeeGroupFactID;

        INSERT INTO shifts.EmployeeGroupsFact(StartDate, IP, WorkPlaceID, ShiftID, AutoCreate, JobStageID)
        OUTPUT INSERTED.ID INTO @T
        SELECT GetDate(), @IP, @WorkPlaceID, @ShiftID, 1, @JobStageID

        SELECT @ID = ID FROM @T

        INSERT INTO shifts.EmployeeGroupsFactDetais(EmployeeGroupsFactID, EmployeeID)        
        SELECT @ID, ID FROM dbo.fn_StringToITable(@ArrayOfEmployeeID)

        -- если ЕГФ с емплоии уже есть по условию Автокриейт = 0 и РМ = @РМ то ничего, иначе создаем с план датами на смене
        DECLARE @EID int
        DECLARE Cur CURSOR LOCAL FOR SELECT ID FROM dbo.fn_StringToITable(@ArrayOfEmployeeID)
        OPEN Cur
        FETCH NEXT FROM Cur INTO @EID
        WHILE @@FETCH_STATUS = 0
        BEGIN 
            IF NOT EXISTS(SELECT sd.ID FROM shifts.EmployeeGroupsFactDetais sd
                          INNER JOIN shifts.EmployeeGroupsFact egf ON egf.ID = sd.EmployeeGroupsFactID AND ISNULL(egf.AutoCreate, 0) = 0 
                            AND egf.ShiftID = @ShiftID AND egf.WorkPlaceID = @WorkPlaceID
                          WHERE sd.EmployeeID = @EID
                          )
            BEGIN
                INSERT INTO shifts.EmployeeGroupsFact(StartDate, EndDate, IP, WorkPlaceID, ShiftID, AutoCreate, JobStageID)
                OUTPUT INSERTED.ID INTO @T
                SELECT s.PlanStartDate, s.PlanEndDate, @IP, @WorkPlaceID, @ShiftID, 0, @JobStageID
                FROM shifts.Shifts s
                WHERE ID = @ShiftID

                SELECT @ManualID = ID FROM @T --другая переменная чтобы на интерфейс вернулось то что нужно

                INSERT INTO shifts.EmployeeGroupsFactDetais(EmployeeGroupsFactID, EmployeeID)        
                SELECT @ManualID, @EID
            END         
            FETCH NEXT FROM Cur INTO @EID
        END
        CLOSE Cur
        DEALLOCATE Cur
        
        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err;
    END CATCH

    SELECT @ID AS EmployeeGroupsFactID
END
GO