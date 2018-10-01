SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   06.11.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   06.11.2013$*/
/*$Version:    1.00$   $Description: Удаление из темповой таблицы свойств типа протокола$*/
create PROCEDURE [QualityControl].[sp_TypesDetails_DeleteTmp]
    @ID Int
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int
                
    DECLARE @ParentID Int, @Order Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        SELECT
            @ParentID = t.BlockID,
            @Order = t.SortOrder
        FROM #TypesDetails t
        WHERE t.ID = @ID
        
        DELETE
        FROM #TypesDetails
        WHERE ID = @ID

        UPDATE #TypesDetails
        SET SortOrder = SortOrder - 1
        WHERE BlockID = @ParentID AND SortOrder > @Order
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO