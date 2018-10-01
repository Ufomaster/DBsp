SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create FUNCTION [manufacture].[fn_GetPCCIDbyJobStageID] (@JobStageID int)
RETURNS integer
AS
BEGIN
    RETURN(
    SELECT j.ProductionCardCustomizeID
    FROM manufacture.JobStages js
    INNER JOIN manufacture.Jobs j ON j.ID = js.JobID AND ISNULL(j.isDeleted, 0) = 0
    WHERE js.ID = @JobStageID AND ISNULL(js.isDeleted, 0) = 0)
END
GO