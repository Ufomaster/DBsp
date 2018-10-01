SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    	$Create date:   27.02.2014$*/
/*$Modify:     Yuriy Oleynik$        $Modify date:   10.04.2017$*/
/*$Version:    1.00$   $Description: Удаление этапа*/
CREATE PROCEDURE [manufacture].[sp_JobStages_Delete]
    @ID Int, /*праймари кей записи JobStageChecks  */
    @EmployeeID int,
    @HardDelete bit = 0
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int, @JobStageID Int
        
    SET XACT_ABORT ON
    IF @HardDelete = 0 AND EXISTS(SELECT * 
                                  FROM manufacture.JobStageChecks jsc 
                                  WHERE jsc.JobStageID = @ID AND ISNULL(jsc.isDeleted,0) = 0)
        RAISERROR ('Удаление этапов с проверками запрещено', 16, 1)
	ELSE 
    BEGIN       
        BEGIN TRAN
        BEGIN TRY       
            UPDATE manufacture.JobStages
            SET isDeleted = 1
            WHERE ID = @ID
            
            EXEC [manufacture].[sp_JobStagesHistory_Insert] @EmployeeID, @ID, 2            
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