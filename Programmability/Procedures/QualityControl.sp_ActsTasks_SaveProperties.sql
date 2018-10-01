SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   06.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   06.04.2015$*/
/*$Version:    1.00$   $Description: Сохранение свойств из временной таблицы$*/
create PROCEDURE [QualityControl].[sp_ActsTasks_SaveProperties]
    @ID Int
AS
BEGIN
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*удалим удалённые*/
        DELETE d
        FROM QualityControl.ActsTasks d
        LEFT JOIN #ActsTasks t ON d.ID = t._ID
        WHERE t.ID IS NULL AND d.ActID = @ID

        /*изменим изменённые*/
        UPDATE td
        SET td.[Name] = t.[Name],
            td.AssignedToEmployeeID = t.AssignedToEmployeeID,
            td.ControlEmployeeID = t.ControlEmployeeID,
            td.Status = t.Status,
            td.CreateDate = t.CreateDate,
            td.Comment = t.Comment,
            td.TasksID = t.TasksID,
            td.BeginFromDate = t.BeginFromDate
        FROM QualityControl.ActsTasks td
        INNER JOIN #ActsTasks t ON t._ID = td.ID
        WHERE td.ActID = @ID

        /*Добавим добавленные*/
        INSERT INTO QualityControl.ActsTasks([Name], AssignedToEmployeeID, ControlEmployeeID,[Status],CreateDate, 
            Comment, TasksID, ActID, BeginFromDate)
        SELECT d.[Name], d.AssignedToEmployeeID, d.ControlEmployeeID, d.[Status], d.CreateDate, 
            d.Comment, d.TasksID, @ID, d.BeginFromDate
        FROM #ActsTasks d
        LEFT JOIN QualityControl.ActsTasks td ON td.ID = d._ID AND td.ActID = @ID
        WHERE td.ID IS NULL
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO