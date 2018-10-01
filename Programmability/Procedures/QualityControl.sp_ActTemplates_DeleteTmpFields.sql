SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   03.12.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   03.12.2013$*/
/*$Version:    1.00$   $Description: Удаление из темповой таблицы $*/
create PROCEDURE [QualityControl].[sp_ActTemplates_DeleteTmpFields]
    @ID Int
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int
                
    DECLARE @Order Int, @ParentID int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        SELECT @ParentID = ParentID FROM #ActTemplatesFieldsPositions WHERE ID = @ID

        SELECT
            @Order = t.SortOrder
        FROM #ActTemplatesFieldsPositions t
        WHERE t.ID = @ID AND ParentID = @ParentID
        
        DELETE
        FROM #ActTemplatesFieldsPositions
        WHERE ID = @ID

        UPDATE #ActTemplatesFieldsPositions
        SET SortOrder = SortOrder - 1
        WHERE SortOrder > @Order AND ParentID = @ParentID
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO