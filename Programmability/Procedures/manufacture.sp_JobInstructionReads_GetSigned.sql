SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   16.09.2015$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   21.09.2015$*/
/*$Version:    1.00$   $Description: $*/
CREATE PROCEDURE [manufacture].[sp_JobInstructionReads_GetSigned]
    @JobStageID Int,
    @ShiftID Int
AS
BEGIN
	SET NOCOUNT ON    

    DECLARE @JobID int
    SELECT @JobID = JobID FROM manufacture.JobStages WHERE ID = @JobStageID

    SELECT COUNT(f.ID)
    FROM #LoggedInUsers f 
    WHERE f.[Status] = 1 AND f.EmployeeID NOT IN (SELECT a.EmployeeID FROM [manufacture].[JobInstructionReads] a
                                                  INNER JOIN manufacture.JobStages js ON js.ID = a.JobStageID AND js.JobID = @JobID AND js.isDeleted = 0
                                                  WHERE a.ShiftID = @ShiftID AND a.SignDate IS NOT NULL)
END
GO