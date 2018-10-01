SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   13.05.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   13.05.2011$
--$Version:    1.00$   $Description: Удаление отчета
CREATE PROCEDURE [dbo].[sp_Reports_Delete]
    @ID Int,
    @OutID Bigint = NULL OUTPUT 
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON
    BEGIN TRY
    BEGIN TRAN
        DELETE FROM Reports WHERE ID = @ID
        SET @OutID = @ID          
        IF (@@TRANCOUNT > 0) COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF (@@TRANCOUNT > 0) ROLLBACK TRAN
        DECLARE @Err Int
        SELECT @Err = ERROR_NUMBER()
        EXEC sp_RaiseError @ID = @Err
        SET @OutID = -1
        RETURN -1
    END CATCH
END
GO