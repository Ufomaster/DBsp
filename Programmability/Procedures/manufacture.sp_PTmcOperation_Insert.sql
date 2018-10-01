SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   27.06.2014$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   27.06.2014$*/
/*$Version:    2.00$   $Description: Вставка в таблицу операций$*/
create PROCEDURE [manufacture].[sp_PTmcOperation_Insert]
  @EmployeeID int,
  @JobStageID int
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int    
    DECLARE @NewID Int
    
    CREATE TABLE #T(ID Int)        

	BEGIN TRAN
	BEGIN TRY  
    	
        INSERT INTO manufacture.PTmcOperations (ModifyDate, EmployeeID, OperationTypeID, JobStageID)
        OUTPUT INSERTED.ID INTO #T        
        Values (GetDate(), @EmployeeID, 1, @JobStageID)  
  
        SELECT @NewID = ID FROM #T
        
        DROP TABLE #T
        
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