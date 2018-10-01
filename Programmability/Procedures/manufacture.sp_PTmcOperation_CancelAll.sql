SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   23.01.2015$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   04.02.2015$*/
/*$Version:    1.00$   $Description: Отмена всех операций импорта $*/
CREATE PROCEDURE [manufacture].[sp_PTmcOperation_CancelAll]
	@JobStageID int
AS    
BEGIN
	SET NOCOUNT ON
    
    DECLARE @OperationID int
    
    DECLARE CRSI CURSOR STATIC LOCAL FOR
    SELECT o.ID
        FROM manufacture.PTmcOperations o 
        WHERE o.JobStageID = @JobStageID
        	  AND IsNull(o.isCanceled,0) <> 1
    ORDER BY o.ID DESC
             
    OPEN CRSI        

    FETCH NEXT FROM CRSI INTO @OperationID

    WHILE (@@FETCH_STATUS = 0)
    BEGIN                           
    	EXEC manufacture.sp_PTmcOperation_CancelLast @JobStageID
    	
	    FETCH NEXT FROM CRSI INTO @OperationID
    END        
            
    CLOSE CRSI    
    DEALLOCATE CRSI           
END
GO