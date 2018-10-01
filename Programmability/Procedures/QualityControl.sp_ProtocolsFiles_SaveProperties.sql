SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   12.12.2016$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   12.12.2016$*/
/*$Version:    1.00$   $Description: Сохранение свойств из временной таблицы$*/
create PROCEDURE [QualityControl].[sp_ProtocolsFiles_SaveProperties]
    @ID Int
AS
BEGIN
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*удалим удалённые*/
        DELETE d
        FROM QualityControl.ProtocolsFiles d
        LEFT JOIN #ProtocolsFiles t ON d.ID = t._ID
        WHERE t.ID IS NULL AND d.ProtocolID = @ID

        /*изменим изменённые*/
/*        UPDATE td
        SET td.CCID = t.CCID,
            td.[Batch] = t.[Batch],
            td.Box = t.Box,
            td.[Description] = t.[Description]
        FROM QualityControl.ActsFiles td
        INNER JOIN #ActsFiles t ON t._ID = td.ID
        WHERE td.ActsID = @ID*/

        /*Добавим добавленные*/
        INSERT INTO QualityControl.ProtocolsFiles(FileName, [FileData], FileDataThumb, ProtocolID)
        SELECT t.FileName, t.[FileData], t.FileDataThumb, @ID
        FROM #ProtocolsFiles t
        LEFT JOIN QualityControl.ProtocolsFiles td ON td.ID = t._ID AND td.ProtocolID = @ID
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