SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   03.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   07.04.2015$*/
/*$Version:    1.00$   $Description: Сохранение свойств типа протокола из временной таблицы$*/
CREATE PROCEDURE [QualityControl].[sp_ActTemplates_SaveEmployees]
    @ActTemplatesID Int
AS
BEGIN
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        /*удалим удалённые поля*/
        DELETE td
        FROM QualityControl.ActTemplatesFieldsPositions td
        LEFT JOIN #ActTemplatesFieldsPositions t ON td.ID = t._ID
        WHERE t.ID IS NULL AND td.ActTemplatesSignersID IN (SELECT s.ID FROM QualityControl.ActTemplatesSigners s WHERE s.ActTemplatesID = @ActTemplatesID)
        
        /*удалим удалённые Участники*/
        DELETE tb
        FROM QualityControl.ActTemplatesSigners tb
        LEFT JOIN #ActTemplatesSigners t ON tb.ID = t._ID
        WHERE t.ID IS NULL AND tb.ActTemplatesID = @ActTemplatesID
        
        DECLARE @T table(realID int, tempID int, isNew bit)
        DECLARE @ID int
        DECLARE Cur CURSOR FOR SELECT t.ID
                               FROM #ActTemplatesSigners t
                               LEFT JOIN QualityControl.ActTemplatesSigners tb ON tb.ID = t._ID
                                   AND tb.ActTemplatesID = @ActTemplatesID
                               WHERE tb.ID IS NULL
        OPEN Cur
        FETCH NEXT FROM Cur INTO @ID
        WHILE @@FETCH_STATUS = 0 
        BEGIN
            /*Добавим добавленные участники*/
            INSERT INTO QualityControl.ActTemplatesSigners(ID, ActTemplatesID,
                DepartmentPositionID, SortOrder, ParagraphCaption)
            OUTPUT INSERTED.ID, @ID, 1 INTO @T
            SELECT 
                (SELECT ISNULL(MAX(ID), 0) + 1 FROM QualityControl.ActTemplatesSigners),
                @ActTemplatesID, t.DepartmentPositionID, t.SortOrder, t.ParagraphCaption
            FROM #ActTemplatesSigners t
            WHERE t.ID = @ID
            
            FETCH NEXT FROM Cur INTO @ID
        END
        CLOSE Cur
        DEALLOCATE Cur

        INSERT INTO @T(realID, tempID, isNew)
        SELECT t._ID, t.ID, 0
        FROM #ActTemplatesSigners t
        WHERE t._ID IS NOT NULL /*old only*/
        /*восстановим ActTemplatesSignersID с темповых на реальные айдишки*/
        UPDATE a 
        SET a.ParentID = t.realID
        FROM #ActTemplatesFieldsPositions a
        INNER JOIN @T t ON t.tempID = a.ParentID
        
        /*изменим изменённые Участники*/
        UPDATE tb
        SET tb.DepartmentPositionID = t.DepartmentPositionID,
            tb.ParagraphCaption = t.ParagraphCaption,
            tb.SortOrder = t.SortOrder
        FROM QualityControl.ActTemplatesSigners tb
        INNER JOIN #ActTemplatesSigners t ON t._ID = tb.ID
        WHERE tb.ActTemplatesID = @ActTemplatesID

        /*изменим изменённые Поля, переместим из темповых BlockID в реальные*/
        UPDATE td
        SET td.ActTemplatesSignersID = t.ParentID,
            td.SortOrder = t.SortOrder,
            td.ActFieldsID = t.ActFieldsID
        FROM QualityControl.ActTemplatesFieldsPositions td
        INNER JOIN #ActTemplatesFieldsPositions t ON t._ID = td.ID

        /*Добавим добавленные поля*/
        INSERT INTO QualityControl.ActTemplatesFieldsPositions(ActTemplatesSignersID, ActFieldsID, SortOrder)
        SELECT t.ParentID, t.ActFieldsID, t.SortOrder
        FROM #ActTemplatesFieldsPositions t
        LEFT JOIN QualityControl.ActTemplatesFieldsPositions td ON td.ID = t._ID 
                  AND td.ActTemplatesSignersID IN (SELECT s.ID FROM QualityControl.ActTemplatesSigners s WHERE s.ActTemplatesID = @ActTemplatesID)
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