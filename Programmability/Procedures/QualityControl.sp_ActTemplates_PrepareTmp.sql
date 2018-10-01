SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   03.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   07.04.2015$*/
/*$Version:    1.00$   $Description: Подготовка редактирования свойств шаблона акта$*/
CREATE PROCEDURE [QualityControl].[sp_ActTemplates_PrepareTmp]
    @ActTemplatesID smallInt
AS
BEGIN
    DECLARE @T table(realID int, tempID int)
    DECLARE @ID int
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        DECLARE Cur CURSOR FOR SELECT ID FROM QualityControl.ActTemplatesSigners a WHERE a.ActTemplatesID = @ActTemplatesID
        OPEN Cur
        FETCH NEXT FROM Cur INTO @ID
        WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT INTO #ActTemplatesSigners(_ID, DepartmentPositionID, SortOrder, ParagraphCaption)
            OUTPUT @ID, INSERTED.ID INTO @T    
            SELECT
                b.ID, b.DepartmentPositionID,  b.SortOrder, b.ParagraphCaption
            FROM QualityControl.ActTemplatesSigners b
            WHERE b.ID = @ID
                    
            INSERT INTO #ActTemplatesFieldsPositions(_ID, ActFieldsID, SortOrder, ParentID)
            SELECT
                d.ID, d.ActFieldsID, d.SortOrder, t.tempID
            FROM [QualityControl].ActTemplatesFieldsPositions d
            INNER JOIN @T t ON t.realID = d.ActTemplatesSignersID AND t.RealID = @ID
            WHERE d.ActTemplatesSignersID = @ID
        
            FETCH NEXT FROM Cur INTO @ID
        END
        CLOSE Cur
        DEALLOCATE Cur
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO