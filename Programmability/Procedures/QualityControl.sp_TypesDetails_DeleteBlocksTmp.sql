SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   11.11.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   12.11.2013$*/
/*$Version:    1.00$   $Description: Удаление из темповой таблицы блока полей типа протокола$*/
create PROCEDURE [QualityControl].[sp_TypesDetails_DeleteBlocksTmp]
    @ID Int
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int, @Order Int
    IF EXISTS(SELECT * FROM #TypesDetails WHERE BlockID = @ID)
        RAISERROR ('Удаление невозможно, так как блок используется для группировки свойств', 16, 1)
    ELSE
    BEGIN
        SET XACT_ABORT ON
        BEGIN TRAN
        BEGIN TRY
            SELECT
                @Order = t.SortOrder
            FROM #TypesDetailsBlocks t
            WHERE t.ID = @ID
            
            DELETE
            FROM #TypesDetailsBlocks
            WHERE ID = @ID

            UPDATE #TypesDetailsBlocks
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
END
GO