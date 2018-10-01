SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   22.01.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   27.12.2016$*/
/*$Version:    1.00$   $Decription: Удаление смены.$*/
CREATE PROCEDURE [shifts].[sp_Shifts_Delete]
    @ID int
AS
BEGIN
    SET NOCOUNT ON;
    --нельзя удалять: проверим работал ли кто-то, в случае с незакрытой сменой
    IF EXISTS(SELECT TOP 1 ID FROM [shifts].[EmployeeGroupsFact] s WHERE ShiftID = @ID AND ISNULL(s.IsDeleted, 0) = 0)
    BEGIN     
        RAISERROR('Удаление смены запрещено. В смене уже проводилась работа.', 16, 1)
        RETURN
    END
    ELSE
    IF EXISTS(SELECT TOP 1 ID FROM manufacture.ProductionTasks pt WHERE pt.ShiftID = @ID)
    BEGIN     
        RAISERROR('Удаление смены запрещено. В смене уже проводилась работа со сменными заданяими.', 16, 1)
        RETURN
    END
    
    DECLARE @Err Int;
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        DELETE d
        FROM shifts.EmployeeGroupsPlanDetais d
        INNER JOIN shifts.EmployeeGroupsPlan p ON p.ID = d.EmployeeGroupID
        WHERE p.ShiftID = @ID

        DELETE p FROM shifts.EmployeeGroupsPlan p
        WHERE p.ShiftID = @ID    

        UPDATE a
        SET a.IsDeleted = 1
        FROM shifts.EmployeeGroupsFact a
        WHERE a.ShiftID = @ID

        UPDATE b
        SET b.IsDeleted = 1
        FROM shifts.EmployeeGroupsFactDetais b
        INNER JOIN shifts.EmployeeGroupsFact c ON c.ID = b.EmployeeGroupsFactID 
        WHERE c.ShiftID = @ID

        UPDATE s
        SET s.IsDeleted = 1
        FROM shifts.Shifts s
        WHERE s.ID = @ID

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err;
    END CATCH
END
GO