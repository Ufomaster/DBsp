SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    	$Create date:   27.02.2014$*/
/*$Modify:     Yuriy Oleynik$        $Modify date:   30.06.2015$*/
/*$Version:    1.00$   $Description: Удаление работы*/
CREATE PROCEDURE [manufacture].[sp_Jobs_Delete]
    @ID Int /*праймари кей записи Jobs  */
AS
BEGIN
	SET NOCOUNT ON
    SET XACT_ABORT ON
    DECLARE @Err Int
    
    IF EXISTS(SELECT * FROM manufacture.JobStages js WHERE js.JobID = @ID AND js.isDeleted = 0)
        RAISERROR ('Удаление работы с этапами запрещено', 16, 1)
    ELSE    
	BEGIN
        BEGIN TRAN
        BEGIN TRY                
            UPDATE manufacture.Jobs
            SET isDeleted = 1
            WHERE ID = @ID
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