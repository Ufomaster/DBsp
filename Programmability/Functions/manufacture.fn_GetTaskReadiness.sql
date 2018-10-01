SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   10.08.2016$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   07.03.2017$*/
/*$Version:    1.00$   $Decription: Информация о возможности работы со сменкой/сменой$*/
CREATE FUNCTION [manufacture].[fn_GetTaskReadiness] (@ProdTaskID int)
RETURNS tinyint
AS
BEGIN
	DECLARE @T tinyint
    -- 0 - ready to work
    -- 1 - attention, we should ask user for confirmation
    -- 2 - work is forbidden
    SET @T = (SELECT CASE WHEN Getdate() between s.PlanStartDate AND s.PlanEndDate AND pt.EndDate IS NULL THEN 0
                          WHEN (Datediff(mi, Getdate(), s.PlanStartDate) < 120 AND Getdate() < s.PlanStartDate) OR (Datediff(mi, s.PlanEndDate, Getdate()) < 120 AND Getdate() > s.PlanEndDate) THEN 1
                          ELSE 2      
                     END     
              FROM manufacture.ProductionTasks pt
                   LEFT JOIN shifts.Shifts s on s.ID = pt.ShiftID
              WHERE pt.Id = @ProdTaskID)
    
    RETURN (SELECT IsNull(@T,2))
END
GO