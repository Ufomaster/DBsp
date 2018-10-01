SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   02.04.2015$*/
/*$Modify:     Oleksii Poliatykin$    $Modify date:   04.08.2017$*/
/*$Version:    1.00$   $Description: Сохранение свойств из временной таблицы$*/
CREATE PROCEDURE [QualityControl].[sp_ActsReasons_SaveProperties]
    @ID Int
AS
BEGIN
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*удалим удалённые*/
        DELETE d
        FROM QualityControl.ActsReasons d
        LEFT JOIN #ActsReasons t ON d.ID = t._ID
        WHERE t.ID IS NULL AND d.ActID = @ID

        /*изменим изменённые*/
        UPDATE td
        SET td.FaultsReasonsClassID = t.FaultsReasonsClassID,
            td.[Name] = t.[Name]
        FROM QualityControl.ActsReasons td
        INNER JOIN #ActsReasons t ON t._ID = td.ID
        WHERE td.ActID = @ID

        /*Добавим добавленные*/
        INSERT INTO QualityControl.ActsReasons(FaultsReasonsClassID, Name, ActID)
        SELECT t.FaultsReasonsClassID, t.Name, @ID
        FROM #ActsReasons t
        LEFT JOIN QualityControl.ActsReasons td ON td.ID = t._ID AND td.ActID = @ID
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