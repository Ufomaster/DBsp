SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   03.12.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   07.04.2015$*/
/*$Version:    1.00$   $Description: Перемещение участников $*/
CREATE PROCEDURE [QualityControl].[sp_ActTemplates_MoveTmpFields]
    @ID Int,
    @Direction Int
AS
BEGIN   
    DECLARE @Order int, @ParentID int
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        SELECT @ParentID = ParentID FROM #ActTemplatesFieldsPositions WHERE ID = @ID
            
        IF @Direction = 1 /* VK_UP*/
        BEGIN
            SELECT @Order = SortOrder
            FROM #ActTemplatesFieldsPositions
            WHERE ID = @ID AND ParentID = @ParentID
            
            /*выберем предидущий порядок*/
            SELECT TOP 1 @Order = SortOrder
            FROM #ActTemplatesFieldsPositions
            WHERE SortOrder < @Order AND ParentID = @ParentID
            ORDER BY SortOrder DESC

            /*сдвинем предыдущую запись вниз, если есть что сдвигать*/
            IF @Order IS NOT NULL
                UPDATE #ActTemplatesFieldsPositions
                SET SortOrder = SortOrder + 1
                WHERE SortOrder = @Order AND ParentID = @ParentID
            ELSE
                SET @Order = 1
           /*наконец проставим себе индекс если возможно*/
           UPDATE #ActTemplatesFieldsPositions
           SET SortOrder = @Order
           WHERE ID = @ID
        END
        ELSE

        IF @Direction = 2 /* VK_DOWN*/
        BEGIN
            SELECT @Order = SortOrder
            FROM #ActTemplatesFieldsPositions
            WHERE ID = @ID AND ParentID = @ParentID
            /*выберем следующий порядок*/
            SELECT TOP 1 @Order = SortOrder
            FROM #ActTemplatesFieldsPositions
            WHERE SortOrder > @Order AND ParentID = @ParentID
            ORDER BY SortOrder
            /*сдвинем след. запись вверх, если есть что сдвигать*/
            IF @Order IS NOT NULL
                UPDATE #ActTemplatesFieldsPositions
                SET SortOrder = SortOrder - 1
                WHERE SortOrder = @Order AND ParentID = @ParentID
            ELSE
                SET @Order = (SELECT MAX(SortOrder + 1) FROM #ActTemplatesFieldsPositions WHERE ParentID = @ParentID)
           /*наконец проставим себе индекс если возможно*/
           IF @Order IS NULL
               SET @Order = 1
           UPDATE #ActTemplatesFieldsPositions
           SET SortOrder = @Order
           WHERE ID = @ID
        END
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO