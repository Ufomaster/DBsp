SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   19.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   30.03.2015$*/
/*$Version:    1.00$   $Description: Сохранение свойств протокола из временной таблицы$*/
CREATE PROCEDURE [QualityControl].[sp_ProtocolsDetails_SaveProperties]
    @ID Int
AS
BEGIN
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*удалим удалённые*/
        DELETE d
        FROM QualityControl.ProtocolsDetails d
        LEFT JOIN #ProtocolsDetails t ON d.ID = t._ID
        WHERE t.ID IS NULL AND d.ProtocolID = @ID

        /*изменим изменённые*/
        UPDATE td
        SET td.[Caption] = t.Caption,
            td.Checked = t.Checked,
            td.FactValue = t.FactValue,
            td.ValueToCheck = t.ValueToCheck,
            td.ModifyDate = t.ModifyDate,
            td.ResultKind = t.ResultKind,
            td.SortOrder = t.SortOrder,
            td.BlockID = t.BlockID,
            td.DetailBlockID = t.DetailBlockID,
            td.ImportanceID = t.ImportanceID
        FROM QualityControl.ProtocolsDetails td
        INNER JOIN #ProtocolsDetails t ON t._ID = td.ID
        WHERE td.ProtocolID = @ID

        /*Добавим добавленные*/
        INSERT INTO QualityControl.ProtocolsDetails([Caption], Checked, FactValue, ModifyDate, ResultKind, 
            SortOrder, ValueToCheck, ProtocolID, BlockID, DetailBlockID, ImportanceID)
        SELECT t.[Caption], t.Checked, t.FactValue, t.ModifyDate, t.ResultKind, t.SortOrder, t.ValueToCheck, @ID, t.BlockID, t.DetailBlockID, ISNULL(t.ImportanceID, 1)
        FROM #ProtocolsDetails t
        LEFT JOIN QualityControl.ProtocolsDetails td ON td.ID = t._ID AND td.ProtocolID = @ID
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