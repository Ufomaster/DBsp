SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    	$Create date:   27.02.2014$*/
/*$Modify:     Zapadinskiy Anatoliy$        $Modify date:   18.04.2014$*/
/*$Version:    1.00$   $Description: Удаление проверки$*/
create PROCEDURE [manufacture].[sp_JobStageChecks_Delete]
    @ID Int, /*праймари кей записи JobStageChecks  */
    @EmployeeID Int
AS
BEGIN
	SET NOCOUNT ON
    SET XACT_ABORT ON    
    DECLARE @Err Int
           , @JobStageID Int
           , @OrderID tinyint
           , @UpdateID int
    BEGIN TRAN
    BEGIN TRY  
        SELECT @JobStageID = jsc.JobStageID, @OrderID = jsc.SortOrder
        FROM manufacture.JobStageChecks jsc 
        WHERE jsc.ID = @ID
              
        UPDATE manufacture.JobStageChecks 
        SET isDeleted = 1
        WHERE ID = @ID

        UPDATE manufacture.JobStageChecks
        SET SortOrder = SortOrder - 1
        WHERE (JobStageID = @JobStageID) AND (SortOrder > @OrderID) 
               AND (isDeleted <> 1)
           
        -- Make history for all updated  
        DECLARE CRSI CURSOR STATIC LOCAL FOR
        SELECT ID
        FROM manufacture.JobStageChecks
        WHERE (JobStageID = @JobStageID) AND (SortOrder >= @OrderID) 
               AND (isDeleted <> 1)
         
        OPEN CRSI

        FETCH NEXT FROM CRSI INTO @UpdateID

        WHILE @@FETCH_STATUS=0
        BEGIN        
            EXEC [manufacture].[sp_JobStageChecksHistory_Insert] @EmployeeID, @UpdateID, 1
            FETCH NEXT FROM CRSI INTO @UpdateID        
        END                      
                  
        --Make history for deleted item     
        EXEC [manufacture].[sp_JobStageChecksHistory_Insert] @EmployeeID, @ID, 2
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO