SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   18.04.2014$*/
/*$Modify:     Yuriy Oleynik$    		$Modify date:   15.04.2015$*/
/*$Version:    1.00$   $Description: Добавление истории для этапа$*/
CREATE PROCEDURE [manufacture].[sp_JobStageChecksHistory_Insert]
    @EmployeeID Int,
    @JobStageCheckID Int,
    @OperationType TinyInt    /*0-insert, 1-update, 2-delete*/
AS
BEGIN
	SET NOCOUNT ON
    
    INSERT INTO  manufacture.JobStageChecksHistory([Name], JobStageID, SortOrder, TmcID, AddPrefix, AddSufix, DelBefore, DelAfter, CheckMask, CheckLink,
      CheckSortTmcID, CheckSortMsg, CheckSort, TypeID, CheckOrder, CheckCorrectPacking, [CheckDB], isDeleted, JobStageCheckID, ImportTemplateColumnID,
      ModifyEmployeeID, ModifyDate, OperationType, CheckUniqOnInsert, MaxCount, MinCount, EqualityCheckID, UseMaskAsStaticValue) 
    SELECT [Name], JobStageID, SortOrder, TmcID, AddPrefix, AddSufix, DelBefore, DelAfter, CheckMask, CheckLink,
      CheckSortTmcID, CheckSortMsg, CheckSort, TypeID, CheckOrder, CheckCorrectPacking, [CheckDB], isDeleted, ID, ImportTemplateColumnID,
      @EmployeeID, GetDate(), @OperationType, CheckUniqOnInsert, MaxCount, MinCount, EqualityCheckID, UseMaskAsStaticValue
    FROM manufacture.JobStageChecks  
    WHERE ID = @JobStageCheckID        

    SELECT 1 AS ID
END
GO