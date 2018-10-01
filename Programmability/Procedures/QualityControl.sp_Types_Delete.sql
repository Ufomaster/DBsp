SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   12.03.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   12.03.2015$*/
/*$Version:    1.00$   $Description: удаление типов протоколов$*/
CREATE PROCEDURE [QualityControl].[sp_Types_Delete]
    @ID Int
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Order Int
    DECLARE @Err Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        SELECT
            @Order = t.SortOrder
        FROM QualityControl.Types t
        WHERE t.ID = @ID
        
        DELETE 
        FROM QualityControl.Types
        WHERE ID = @ID

        UPDATE QualityControl.Types
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