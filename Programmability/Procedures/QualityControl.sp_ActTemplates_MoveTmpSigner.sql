SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   03.12.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   19.12.2013$*/
/*$Version:    1.00$   $Description: Перемещение участников $*/
CREATE PROCEDURE [QualityControl].[sp_ActTemplates_MoveTmpSigner]
    @ID Int,
    @Direction Int
AS
BEGIN   
    DECLARE @Order int
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        IF @Direction = 1 /* VK_UP*/
        BEGIN
            SELECT @Order = SortOrder
            FROM #ActTemplatesSigners
            WHERE ID = @ID
            
            /*выберем предидущий порядок*/
            SELECT TOP 1 @Order = SortOrder
            FROM #ActTemplatesSigners
            WHERE SortOrder < @Order
            ORDER BY SortOrder DESC

            /*сдвинем предыдущую запись вниз, если есть что сдвигать*/
            IF @Order IS NOT NULL
                UPDATE #ActTemplatesSigners
                SET SortOrder = SortOrder + 1
                WHERE SortOrder = @Order
            ELSE
                SET @Order = 1
           /*наконец проставим себе индекс если возможно*/
           UPDATE #ActTemplatesSigners
           SET SortOrder = @Order
           WHERE ID = @ID
        END
        ELSE

        IF @Direction = 2 /* VK_DOWN*/
        BEGIN
            SELECT @Order = SortOrder
            FROM #ActTemplatesSigners
            WHERE ID = @ID
            /*выберем следующий порядок*/
            SELECT TOP 1 @Order = SortOrder
            FROM #ActTemplatesSigners
            WHERE SortOrder > @Order
            ORDER BY SortOrder
            /*сдвинем след. запись вверх, если есть что сдвигать*/
            IF @Order IS NOT NULL
                UPDATE #ActTemplatesSigners
                SET SortOrder = SortOrder - 1
                WHERE SortOrder = @Order
            ELSE
                SET @Order = (SELECT MAX(SortOrder + 1) FROM #ActTemplatesSigners)
           /*наконец проставим себе индекс если возможно*/
           IF @Order IS NULL
               SET @Order = 1
           UPDATE #ActTemplatesSigners
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