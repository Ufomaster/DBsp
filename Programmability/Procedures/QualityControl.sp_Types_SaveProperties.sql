SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   06.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   12.08.2015$*/
/*$Version:    1.00$   $Description: Сохранение свойств типа протокола из временной таблицы$*/
CREATE PROCEDURE [QualityControl].[sp_Types_SaveProperties]
    @TypeID Int
AS
BEGIN
    DECLARE @Err Int

    SET NOCOUNT ON;
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        
        /*удалим удалённые Поля*/
        DELETE td
        FROM QualityControl.TypesDetails td
        LEFT JOIN #TypesDetails t ON td.ID = t._ID
        WHERE t.ID IS NULL AND td.TypesID = @TypeID
        
        /*удалим удалённые Блоки*/
        DELETE tb
        FROM QualityControl.TypesBlocks tb
        LEFT JOIN #TypesDetailsBlocks t ON tb.ID = t._ID
        WHERE t.ID IS NULL AND tb.TypesID = @TypeID
        
        UPDATE a 
        SET a.SortOrder = so.SortOrder
        FROM #TypesDetailsBlocks a
        INNER JOIN(SELECT ID, ROW_NUMBER() OVER (ORDER BY SortOrder) AS SortORder FROM #TypesDetailsBlocks) so ON so.ID = a.ID
                
        DECLARE @T table(realID int, tempID int, isNew bit)
        DECLARE @ID int
        DECLARE Cur CURSOR LOCAL FOR SELECT t.ID
                                 FROM #TypesDetailsBlocks t
                                 LEFT JOIN QualityControl.TypesBlocks tb ON tb.ID = t._ID AND tb.TypesID = @TypeID
                                 WHERE tb.ID IS NULL
        OPEN Cur
        FETCH NEXT FROM Cur INTO @ID
        WHILE @@FETCH_STATUS = 0 
        BEGIN
            --Добавим добавленные Блоки
            INSERT INTO QualityControl.TypesBlocks(ID, [Name], VisibleCaption, TreeValues, TypesID, SortOrder, 
                FontBold, FontUnderline, AuthorEditable, SpecialistEditable, SchemaValues, TmcValues, 
                DetailsValues, NormEditable, TmcValuesTest)
            OUTPUT INSERTED.ID, @ID, 1 INTO @T
            SELECT 
                (SELECT ISNULL(MAX(ID), 0) + 1 FROM QualityControl.TypesBlocks),
                t.[Name], t.VisibleCaption, t.TreeValues, @TypeID, t.SortOrder, 
                t.FontBold, t.FontUnderline, t.AuthorEditable, t.SpecialistEditable, t.SchemaValues, t.TmcValues, 
                t.DetailsValues, t.NormEditable, t.TmcValuesTest
            FROM #TypesDetailsBlocks t
            WHERE t.ID = @ID
            
            FETCH NEXT FROM Cur INTO @ID
        END
        CLOSE Cur
        DEALLOCATE Cur

        INSERT INTO @T(realID, tempID, isNew)
        SELECT t._ID, t.ID, 0
        FROM #TypesDetailsBlocks t
        WHERE t._ID IS NOT NULL --old only
        --восстановим BlockID с темповых на реальные айдишки
        UPDATE a 
        SET a.BlockID = t.realID
        FROM #TypesDetails a
        INNER JOIN @T t ON t.tempID = a.BlockID
        
        --изменим изменённые Блоки
        UPDATE tb
        SET tb.[Name] = t.Name,
            tb.VisibleCaption = t.VisibleCaption,
            tb.TreeValues = t.TreeValues,
            tb.SortOrder = t.SortOrder,
            tb.FontBold = t.FontBold,
            tb.FontUnderline = t.FontUnderline,
            tb.AuthorEditable = t.AuthorEditable,
            tb.SpecialistEditable = t.SpecialistEditable,
            tb.SchemaValues = t.SchemaValues,
            tb.TmcValues = t.TmcValues,
            tb.DetailsValues = t.DetailsValues,
            tb.NormEditable = t.NormEditable,
            tb.TmcValuesTest = t.TmcValuesTest
        FROM QualityControl.TypesBlocks tb
        INNER JOIN #TypesDetailsBlocks t ON t._ID = tb.ID
        WHERE tb.TypesID = @TypeID

        --изменим изменённые Поля, переместим из темповых BlockID в реальные
        UPDATE td
        SET td.BlockID = t.BlockID,
            td.[Caption] = t.[Caption], 
            td.EndDate = t.EndDate,
            td.ResultKind = t.ResultKind,
            td.PCCColumnID = t.PCCColumnID,
            td.SortOrder = t.SortOrder,
            td.StartDate = t.StartDate,
            td.ValueToCheck = t.ValueToCheck,
            td.ImportanceID = t.ImportanceID
        FROM QualityControl.TypesDetails td
        INNER JOIN #TypesDetails t ON t._ID = td.ID
        WHERE td.TypesID = @TypeID

        --Добавим добавленные поля
        INSERT INTO QualityControl.TypesDetails(BlockID, [Caption], EndDate, ResultKind, PCCColumnID, SortOrder, StartDate, ValueToCheck, TypesID, ImportanceID)
        SELECT t.BlockID, t.[Caption], t.EndDate, t.ResultKind, t.PCCColumnID, t.SortOrder, t.StartDate, t.ValueToCheck, @TypeID, t.ImportanceID
        FROM #TypesDetails t
        LEFT JOIN QualityControl.TypesDetails td ON td.ID = t._ID AND td.TypesID = @TypeID
        WHERE td.ID IS NULL        
        --поидее, работа с темповой таблице не будет приводить к проблемам с сортордером.НО если что - этот скрипт все поправит
/*        UPDATE a 
        SET a.SortOrder = so.SortOrder
        FROM QualityControl.TypesBlocks a
        INNER JOIN (SELECT ROW_NUMBER() OVER (ORDER BY SortOrder) AS SortOrder, ID 
                    FROM QualityControl.TypesBlocks 
                    WHERE TypesID = @TypeID) so ON so.ID = a.ID
        WHERE a.TypesID = @TypeID*/

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO