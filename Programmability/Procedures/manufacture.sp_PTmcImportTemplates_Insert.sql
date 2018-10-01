SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create PROCEDURE [manufacture].[sp_PTmcImportTemplates_Insert]
  @EmployeeID int,
  @JobStageID int
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int    
    DECLARE @NewID Int
    
    CREATE TABLE #t(ID Int)        

	BEGIN TRAN
	BEGIN TRY  
        INSERT INTO manufacture.PTmcImportTemplates (ModifyDate, EmployeeID, JobStageID)
        OUTPUT INSERTED.ID INTO #t        
        Values (GetDate(), @EmployeeID, @JobStageID)  
  
        SELECT @NewID = ID FROM #t
        
        DROP TABLE #t
        
		COMMIT TRAN        
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
		SET @NewID = -1;
	END CATCH;

    SELECT @NewID AS ID    
END
GO