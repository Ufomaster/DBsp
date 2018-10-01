SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   18.04.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   26.10.2017$*/
/*$Version:    1.00$   $Description: Добавление истории для этапа$*/
CREATE PROCEDURE [manufacture].[sp_JobStagesHistory_Insert]
    @EmployeeID Int,
    @JobStageID Int,
    @OperationType TinyInt    /*0-insert, 1-update, 2-delete*/
AS
BEGIN
	SET NOCOUNT ON
    
    INSERT INTO manufacture.JobStagesHistory([Name], isActive, ModemID, JobID, OperatorsCount, OutputTmcID, 
                                      OutputNameFromCheckID, isDeleted, JobStageID, ModifyEmployeeID, ModifyDate, 
                                      OperationType, MinQuantity, TekOp, Kind, TechnologicalOperationID) 
    SELECT [Name], isActive, ModemID, JobID, OperatorsCount, OutputTmcID, OutputNameFromCheckID, isDeleted, ID,
           @EmployeeID, Getdate(), @OperationType, MinQuantity, TekOp, Kind, TechnologicalOperationID
    FROM manufacture.JobStages
    WHERE ID = @JobStageID        

    SELECT 1 AS ID
END
GO