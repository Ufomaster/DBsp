SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   06.07.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   06.07.2015$*/
/*$Version:    1.00$   $Description: Сохранение свойств из временной таблицыZL$*/
create PROCEDURE [QualityControl].[sp_ActsZLs_SaveProperties]
    @ID Int
AS
BEGIN
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*удалим удалённые*/
        DELETE d
        FROM QualityControl.ActsZL d
        LEFT JOIN #ActsZL t ON d.ID = t._ID
        WHERE t.ID IS NULL AND d.ActsID = @ID

        /*Добавим добавленные*/
        INSERT INTO QualityControl.ActsZL(PCCID, ActsID)
        SELECT t.PCCID, @ID
        FROM #ActsZL t
        LEFT JOIN QualityControl.ActsZL td ON td.ID = t._ID AND td.ActsID = @ID
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