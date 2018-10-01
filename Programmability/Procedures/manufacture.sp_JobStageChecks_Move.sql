SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   14.02.2014$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   18.04.2014$*/
/*$Version:    1.00$   $Description: Перемещение порядка проверок$*/
create PROCEDURE [manufacture].[sp_JobStageChecks_Move]
    @ID Int,
    @Direction Int,
    @EmployeeID int
AS
BEGIN
	SET NOCOUNT ON
    
    DECLARE @Order tinyint
           , @JobStageID int
           , @OutID int
           
    IF @Direction = 1 /* VK_UP*/
	BEGIN
        SELECT @Order = SortOrder, @JobStageID = JobStageID
        FROM manufacture.JobStageChecks
        WHERE ID = @ID
        /*выберем следующий по списку*/                        
        SELECT TOP 1 @Order = SortOrder, @OutID = ID
        FROM manufacture.JobStageChecks
        WHERE JobStageID = @JobStageID AND SortOrder < @Order AND isDeleted <> 1
        ORDER BY SortOrder DESC
        /*сдвинем предыдущую запись вниз, если есть что сдвигать*/
        IF @Order IS NOT NULL
        BEGIN
            UPDATE manufacture.JobStageChecks
            SET SortOrder = SortOrder + 1
            WHERE ID = @OutID --SortOrder = @Order AND JobStageID = @JobStageID AND isDeleted <> 1
            
       /*наконец проставим себе индекс если возможно*/            
            UPDATE manufacture.JobStageChecks
            SET SortOrder = @Order
            WHERE ID = @ID      
            
            EXEC [manufacture].[sp_JobStageChecksHistory_Insert] @EmployeeID, @OutID, 1            
            EXEC [manufacture].[sp_JobStageChecksHistory_Insert] @EmployeeID, @ID, 1                  
        END    
    END
    ELSE
    IF @Direction = 2 /* VK_DOWN*/
	BEGIN
        SELECT @Order = SortOrder, @JobStageID = JobStageID
        FROM manufacture.JobStageChecks
        WHERE ID = @ID
        /*выберем следующий по списку*/        
        SELECT TOP 1 @Order = SortOrder, @OutID = ID
        FROM manufacture.JobStageChecks
        WHERE JobStageID = @JobStageID AND SortOrder > @Order AND isDeleted <> 1
        ORDER BY SortOrder
        /*сдвинем предыдущую запись вниз, если есть что сдвигать*/
        IF @Order IS NOT NULL
    	BEGIN
            UPDATE manufacture.JobStageChecks
            SET SortOrder = SortOrder - 1
            WHERE ID = @OutID-- SortOrder = @Order AND JobStageID = @JobStageID AND isDeleted <> 1
            /*наконец проставим себе индекс если возможно*/
            UPDATE manufacture.JobStageChecks
            SET SortOrder = @Order
            WHERE ID = @ID                

            EXEC [manufacture].[sp_JobStageChecksHistory_Insert] @EmployeeID, @OutID, 1            
            EXEC [manufacture].[sp_JobStageChecksHistory_Insert] @EmployeeID, @ID, 1               
   		END

    END    
END
GO