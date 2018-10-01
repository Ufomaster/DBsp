SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   08.06.2015$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   30.12.2015$*/
/*$Version:    1.00$   $Decription: Удаление EmployeeID*/
CREATE PROCEDURE [shifts].[sp_EmployeeGroupsFact_Delete]
    @EmployeeID int,
    @ShiftID int,
    @WorkPlaceID int
AS
BEGIN
    DECLARE @Err Int;
    SET NOCOUNT ON;
    SET XACT_ABORT ON
    
    IF EXISTS(SELECT ID FROM shifts.Shifts WHERE FactEndDate IS NOT NULL AND ID = @ShiftID)
    BEGIN
        RAISERROR ('Рабочая смена остановлена. Изменение состава смены запрещено', 16, 1)
        RETURN
    END
    
    BEGIN TRAN
    BEGIN TRY
        /*удаляем емплоии*/
        UPDATE d
        SET d.IsDeleted = 1
        FROM shifts.EmployeeGroupsFactDetais d
        INNER JOIN shifts.EmployeeGroupsFact g ON g.ID = d.EmployeeGroupsFactID AND g.ShiftID = @ShiftID AND g.WorkPlaceID = @WorkPlaceID AND g.AutoCreate = 0
        WHERE d.EmployeeID = @EmployeeID
            
        /*если больше никто не сидит в этой группе, удаляем её*/
        IF NOT EXISTS(SELECT d.ID
                      FROM shifts.EmployeeGroupsFactDetais d
                      INNER JOIN shifts.EmployeeGroupsFact g ON g.ID = d.EmployeeGroupsFactID 
                      WHERE g.ShiftID = @ShiftID AND g.WorkPlaceID = @WorkPlaceID AND ISNULL(d.IsDeleted, 0) = 0)
            UPDATE a
            SET a.IsDeleted = 1 
            FROM shifts.EmployeeGroupsFact a
            WHERE a.ShiftID = @ShiftID AND a.WorkPlaceID = @WorkPlaceID AND a.AutoCreate = 0

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err;
    END CATCH
END
GO