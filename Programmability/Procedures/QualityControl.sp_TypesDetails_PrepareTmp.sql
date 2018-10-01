SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   24.10.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   12.08.2015$*/
/*$Version:    1.00$   $Description: Подготовка редактирования свойств типа протокола$*/
CREATE PROCEDURE [QualityControl].[sp_TypesDetails_PrepareTmp]
    @TypeID Int
AS
BEGIN
    DECLARE @T table(realID int, tempID int)
    DECLARE @ID int
    DECLARE @Err Int                                
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        DECLARE Cur CURSOR LOCAL FOR SELECT ID FROM QualityControl.TypesBlocks WHERE TypesID = @TypeID
        OPEN Cur
        FETCH NEXT FROM Cur INTO @ID
        WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT INTO #TypesDetailsBlocks(_ID, [Name], [Expanded], VisibleCaption, TreeValues, SortOrder, 
                FontBold, FontUnderline, AuthorEditable, SpecialistEditable, SchemaValues, TmcValues, 
                DetailsValues, NormEditable, TmcValuesTest)
            OUTPUT @ID, INSERTED.ID INTO @T    
            SELECT
                b.ID, b.[Name], 1, b.VisibleCaption, b.TreeValues, b.SortOrder,  
                b.FontBold, b.FontUnderline, b.AuthorEditable, b.SpecialistEditable, b.SchemaValues, b.TmcValues,
                b.DetailsValues, b.NormEditable, b.TmcValuesTest
            FROM QualityControl.TypesBlocks b
            WHERE b.ID = @ID
                    
            FETCH NEXT FROM Cur INTO @ID
        END
        CLOSE Cur       
        DEALLOCATE Cur
            
        INSERT INTO #TypesDetails(_ID, [Caption], ValueToCheck, StartDate, EndDate, SortOrder, 
            ResultKind, PCCColumnID, BlockID, ImportanceID)
        SELECT
            d.ID, d.[Caption], d.ValueToCheck, d.StartDate, d.EndDate, d.SortOrder, 
            d.ResultKind, d.PCCColumnID, t.tempID, d.ImportanceID
        FROM [QualityControl].TypesDetails d
        INNER JOIN @T t ON t.realID = d.BlockID
        WHERE d.TypesID = @TypeID
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO