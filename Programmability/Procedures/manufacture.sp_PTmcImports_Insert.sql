SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   18.04.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   25.01.2018$*/
/*$Version:    1.00$   $Description: а$*/
CREATE PROCEDURE [manufacture].[sp_PTmcImports_Insert]
    @EmployeeID int,
    @JobStageID int
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int
    CREATE TABLE #t(ID Int)
	BEGIN TRAN
	BEGIN TRY    	
        INSERT INTO manufacture.PTmcOperations (ModifyDate, EmployeeID, ImportTemplateID, OperationTypeID, JobStageID)
        OUTPUT INSERTED.ID INTO #t
     	SELECT TOP 1 GETDATE(), @EmployeeID, it.ID, 1, @JobStageID
        FROM manufacture.PTmcImportTemplates it
        WHERE it.JobStageID = @JobStageID AND ISNULL(it.isDeleted, 0) = 0
        SELECT ID FROM #t        
		COMMIT TRAN        
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
		SELECT -1 AS ID
	END CATCH;
    DROP TABLE #t
END
GO