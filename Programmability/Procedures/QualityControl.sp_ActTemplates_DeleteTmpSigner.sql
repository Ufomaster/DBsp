SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   03.12.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   03.12.2013$*/
/*$Version:    1.00$   $Description: Удаление из темповой таблицы $*/
create PROCEDURE [QualityControl].[sp_ActTemplates_DeleteTmpSigner]
    @ID Int
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int
                
    DECLARE @Order Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        SELECT
            @Order = t.SortOrder
        FROM #ActTemplatesSigners t
        WHERE t.ID = @ID
            
        DELETE 
        FROM #ActTemplatesFieldsPositions 
        WHERE ParentID = @ID
            
        DELETE
        FROM #ActTemplatesSigners
        WHERE ID = @ID

        UPDATE #ActTemplatesSigners
        SET SortOrder = SortOrder - 1
        WHERE SortOrder > @Order
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO