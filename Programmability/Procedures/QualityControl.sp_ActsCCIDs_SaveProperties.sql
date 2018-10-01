SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   19.05.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   19.05.2015$*/
/*$Version:    1.00$   $Description: Сохранение свойств из временной таблицы$*/
create PROCEDURE [QualityControl].[sp_ActsCCIDs_SaveProperties]
    @ID Int
AS
BEGIN
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*удалим удалённые*/
        DELETE d
        FROM QualityControl.ActsCCIDs d
        LEFT JOIN #ActsCCIDs t ON d.ID = t._ID
        WHERE t.ID IS NULL AND d.ActsID = @ID

        /*изменим изменённые*/
        UPDATE td
        SET td.CCID = t.CCID,
            td.[Batch] = t.[Batch],
            td.Box = t.Box,
            td.[Description] = t.[Description]
        FROM QualityControl.ActsCCIDs td
        INNER JOIN #ActsCCIDs t ON t._ID = td.ID
        WHERE td.ActsID = @ID

        /*Добавим добавленные*/
        INSERT INTO QualityControl.ActsCCIDs(CCID, [Batch], Box, [Description], ActsID)
        SELECT t.CCID, t.[Batch], t.Box, t.[Description], @ID
        FROM #ActsCCIDs t
        LEFT JOIN QualityControl.ActsCCIDs td ON td.ID = t._ID AND td.ActsID = @ID
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