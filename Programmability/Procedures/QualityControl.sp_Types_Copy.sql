SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   21.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   30.03.2015$*/
/*$Version:    1.00$   $Description: копирование типов протоколов$*/
CREATE PROCEDURE [QualityControl].[sp_Types_Copy]
    @ID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @t TABLE(ID int)
    DECLARE @blockID int, @NewblockID int
    
    DECLARE @TypesID int
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        INSERT INTO QualityControl.Types(ID, Name, CreateDate, EndDate, SortOrder, 
            ImageIndex, isPCC, isMaterial, ResultCaption, ActTemplatesID, ActTestsEnabled, SourceType)
        OUTPUT INSERTED.ID INTO @t
        SELECT (SELECT ISNULL(MAX(ID), 0) + 1 FROM QualityControl.Types),
            Name + ' копия', GETDATE(), Null, 
            (SELECT ISNULL(MAX(SortOrder), 0) + 1 FROM QualityControl.Types), 
            ImageIndex, isPCC, isMaterial, ResultCaption, ActTemplatesID, ActTestsEnabled, SourceType
        FROM QualityControl.Types 
        WHERE ID = @ID
        
        SELECT @TypesID = ID FROM @t
        DELETE FROM @t
        
        DECLARE Cur CURSOR FOR SELECT ID FROM QualityControl.TypesBlocks WHERE TypesID = @ID
        OPEN Cur
        FETCH NEXT FROM Cur INTO @blockID
        WHILE @@FETCH_STATUS = 0 
        BEGIN    
            INSERT INTO QualityControl.TypesBlocks (ID, [Name],VisibleCaption, TypesID, 
            TreeValues, SortOrder, FontBold, FontUnderline, AuthorEditable, SpecialistEditable, 
            SchemaValues, TmcValues, DetailsValues, NormEditable,  TmcValuesTest)
            OUTPUT INSERTED.ID INTO @t
            SELECT 
                (SELECT ISNULL(MAX(ID), 0) + 1 FROM QualityControl.TypesBlocks),
                [Name],VisibleCaption, @TypesID, 
                TreeValues, SortOrder, FontBold, FontUnderline, AuthorEditable, SpecialistEditable, 
                SchemaValues, TmcValues, DetailsValues, NormEditable,  TmcValuesTest
            FROM QualityControl.TypesBlocks WHERE ID = @blockID
            
            SELECT @NewblockID = ID FROM @t
            DELETE FROM @t

            INSERT INTO QualityControl.TypesDetails (TypesID, [Caption], ValueToCheck, StartDate, EndDate, SortOrder, ResultKind, PCCColumnID, BlockID, ImportanceID)
            SELECT @TypesID, [Caption], ValueToCheck, StartDate, EndDate, SortOrder, ResultKind, PCCColumnID, @NewblockID, ImportanceID
            FROM QualityControl.TypesDetails a WHERE TypesID = @ID AND a.BlockID = @blockID 
        
            FETCH NEXT FROM Cur INTO @blockID
        END
        CLOSE Cur
        DEALLOCATE CUR
        
        INSERT INTO QualityControl.TypesSigners (TypesID, DepartmentPositionID, EmailOnly)
        SELECT @TypesID, DepartmentPositionID, EmailOnly
        FROM QualityControl.TypesSigners WHERE TypesID = @ID
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
    
    SELECT @TypesID    
END
GO