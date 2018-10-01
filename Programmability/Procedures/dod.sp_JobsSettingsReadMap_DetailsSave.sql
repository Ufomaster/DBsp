SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   07.09.2018$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   07.09.2018$*/
/*$Version:    1.00$   $Description: Сохранение свойств из временной таблицы$*/
create PROCEDURE [dod].[sp_JobsSettingsReadMap_DetailsSave]
    @ID Int
AS
BEGIN
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*удалим удалённые*/
        DELETE d
        FROM dod.JobsSettingsReadMap d
        LEFT JOIN #JobsSettingsReadMap t ON d.ID = t._ID
        WHERE t.ID IS NULL AND d.JobsSettingsID = @ID

        /*изменим изменённые*/
        UPDATE td
        SET td.Sector = t.Sector, 
            td.B0 = t.B0, 
            td.B1 = t.B1, 
            td.B2 = t.B2, 
            td.B3 = t.B3, 
            td.B4 = t.B4, 
            td.B5 = t.B5, 
            td.B6 = t.B6, 
            td.B7 = t.B7, 
            td.B8 = t.B8, 
            td.B9 = t.B9, 
            td.B10 = t.B10, 
            td.B11 = t.B11, 
            td.B12 = t.B12, 
            td.B13 = t.B13, 
            td.B14 = t.B14, 
            td.B15 = t.B15
        FROM dod.JobsSettingsReadMap td
        INNER JOIN #JobsSettingsReadMap t ON t._ID = td.ID
        WHERE td.JobsSettingsID = @ID

        /*Добавим добавленные*/
        INSERT INTO dod.JobsSettingsReadMap(Sector, B0, B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, B11, B12, B13, B14, B15, JobsSettingsID)
        SELECT t.Sector, t.B0, t.B1, t.B2, t.B3, t.B4, t.B5, t.B6, t.B7, t.B8, t.B9, t.B10, t.B11, t.B12, t.B13, t.B14, t.B15, @ID
        FROM #JobsSettingsReadMap t
        LEFT JOIN dod.JobsSettingsReadMap td ON td.ID = t._ID AND td.JobsSettingsID = @ID
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