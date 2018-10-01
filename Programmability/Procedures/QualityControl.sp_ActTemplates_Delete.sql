SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   03.12.2013$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   03.12.2013$*/
/*$Version:    1.00$   $Description: Удаление шаблона акта$*/
CREATE PROCEDURE [QualityControl].[sp_ActTemplates_Delete]
    @ID Int
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int
                
    DECLARE @Order Int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY

        DELETE
        FROM [QualityControl].ActTemplatesSigners
        WHERE ActTemplatesID = @ID
            
        DELETE 
        FROM [QualityControl].ActTemplates 
        WHERE ID = @ID

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO