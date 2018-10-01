SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   06.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   02.04.2015$*/
/*$Version:    1.00$   $Description: Сохранение свойств из временной таблицы$*/
CREATE PROCEDURE [QualityControl].[sp_ActsDetails_SaveProperties]
    @ID Int
AS
BEGIN
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*удалим удалённые*/
        DELETE d
        FROM QualityControl.ActsDetails d
        LEFT JOIN #ActsDetails t ON d.ID = t._ID
        WHERE t.ID IS NULL AND d.ActsID = @ID

        /*изменим изменённые*/
        UPDATE td
        SET td.EmployeeID = t.EmployeeID,
            td.ParagraphCaption = t.ParagraphCaption,
            td.SortOrder = t.SortOrder,
            td.XMLData = t.XMLData,
            td.SignDate = t.SignDate
        FROM QualityControl.ActsDetails td
        INNER JOIN #ActsDetails t ON t._ID = td.ID
        WHERE td.ActsID = @ID

        /*Добавим добавленные*/
        INSERT INTO QualityControl.ActsDetails(EmployeeID, ParagraphCaption, SortOrder, XMLData, ActsID, SignDate)
        SELECT t.EmployeeID, t.ParagraphCaption, t.SortOrder, t.XMLData, @ID, t.SignDate
        FROM #ActsDetails t
        LEFT JOIN QualityControl.ActsDetails td ON td.ID = t._ID AND td.ActsID = @ID
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