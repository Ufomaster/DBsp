SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   08.06.2015$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   30.12.2016$*/
/*$Version:    1.00$   $Decription: Создание бригады. Автоматическое$*/
CREATE PROCEDURE [shifts].[sp_EmployeeGroupsFact_InsertFromTemplate]
    @ShiftID int,
    @EmployeeGroupsID int
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Err Int;
    DECLARE @T table(ID int, WorkPlaceID int)
    DECLARE @ID int, @StartDate datetime, @EndDate datetime
    SET XACT_ABORT ON
    
    IF EXISTS(SELECT * FROM shifts.Shifts s WHERE s.FactEndDate IS NOT NULL AND s.ID = @ShiftID)
    BEGIN
        RAISERROR ('Рабочая смена остановлена. Изменение состава смены запрещено', 16, 1)
        RETURN
    END
    
    BEGIN TRAN
    BEGIN TRY
        /*все удалили*/
/*        DELETE 
        FROM shifts.EmployeeGroupsFact
        WHERE ShiftID = @ShiftID*/
        --оставляем все что было, и для темплейта игнорируем те рм что уже есть
        
        SELECT @StartDate = ISNULL(s.FactStartDate, s.PlanStartDate), @EndDate = s.PlanEndDate
        FROM shifts.Shifts s 
        WHERE s.ID = @ShiftID
        
        SELECT WorkPlaceID
        INTO #WP
        FROM shifts.EmployeeGroupsFact 
        WHERE ShiftID = @ShiftID AND ISNULL(IsDeleted, 0) = 0
        GROUP BY WorkPlaceID

        INSERT INTO shifts.EmployeeGroupsFact(StartDate, EndDate, IP, WorkPlaceID, ShiftID, AutoCreate)
        OUTPUT INSERTED.ID, INSERTED.WorkPlaceID INTO @T
        SELECT @StartDate, @EndDate, ss.IP, d.WorkPlaceID, @ShiftID, 0
        FROM shifts.EmployeeGroupsDetails d
        INNER JOIN manufacture.StorageStructure ss ON ss.ID = d.WorkPlaceID
        WHERE d.EmployeeGroupID = @EmployeeGroupsID AND NOT (d.WorkPlaceID IN (SELECT WorkPlaceID FROM #WP))
        GROUP BY ss.IP, d.WorkPlaceID

        INSERT INTO shifts.EmployeeGroupsFactDetais(EmployeeGroupsFactID, EmployeeID)        
        SELECT e.ID, d.EmployeeID
        FROM shifts.EmployeeGroupsFact e
        INNER JOIN shifts.EmployeeGroupsDetails d ON d.EmployeeGroupID = @EmployeeGroupsID AND d.WorkPlaceID = e.WorkPlaceID 
           AND NOT (d.WorkPlaceID IN (SELECT WorkPlaceID FROM #WP))
        WHERE e.ShiftID = @ShiftID 

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err;
    END CATCH
END
GO