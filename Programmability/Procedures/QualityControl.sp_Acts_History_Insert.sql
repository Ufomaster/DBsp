SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   22.05.2015$*/
/*$Modify:     Oleksii Poliatykin$    $Modify date:   30.08.2017$*/
/*$Version:    1.00$   $Description: Добавление истории редактирования актов*/
CREATE PROCEDURE [QualityControl].[sp_Acts_History_Insert]
    @EmployeeID Int,
    @ActID Int,
    @OperationType Int  /*0-insert, 1-update, 2-delete*/
AS
BEGIN
	SET NOCOUNT ON
    CREATE TABLE #tblID(ID int)

    DECLARE @ActHistoryID int
    /*основная запись истории*/
    INSERT INTO QualityControl.ActsHistory(OperationType, ModifyEmployeeID, ModifyDate, ActsID,
        Number, CreateDate, TestCount, [Description], ViolationPlaceID, ActTemplatesID, PVREmployeeID,
        AuthorEmployeeID, PartCount, ProtocolID, StatusID, CancelComment, FaultsReasonsClassID, AllSeeAll, Properties, MasterActID, ResultComment, CustomerID, MainReasonID, AmountMoney, FilePath)    
    OUTPUT INSERTED.ID INTO #tblID
    SELECT @OperationType, @EmployeeID, GetDate(), @ActID,
        Number, CreateDate, TestCount, [Description], ViolationPlaceID, ActTemplatesID, PVREmployeeID,
        AuthorEmployeeID, PartCount, ProtocolID, StatusID, CancelComment, FaultsReasonsClassID, AllSeeAll, Properties, MasterActID, ResultComment, CustomerID, MainReasonID, AmountMoney, FilePath
    FROM QualityControl.Acts
    WHERE ID = @ActID

    SELECT @ActHistoryID = ID FROM #tblID

    /*Далее детальные части*/
    INSERT INTO QualityControl.ActsHistoryCCIDs(CCID, [Batch], Box, [Description], ActsHistoryID)
    SELECT CCID, [Batch], Box, [Description], @ActHistoryID
    FROM QualityControl.ActsCCIDs
    WHERE ActsID = @ActID
    
    INSERT INTO QualityControl.ActsHistoryDetails(XMLData, ParagraphCaption, EmployeeID, SortOrder, SignDate, ActsHistoryID)
    SELECT XMLData, ParagraphCaption, EmployeeID, SortOrder, SignDate, @ActHistoryID
    FROM QualityControl.ActsDetails d
    WHERE d.ActsID = @ActID
    
    INSERT INTO QualityControl.ActsHistoryReasons([Name], FaultsReasonsClassID, ActsHistoryID)
    SELECT [Name], FaultsReasonsClassID, @ActHistoryID
    FROM QualityControl.ActsReasons d
    WHERE d.ActID = @ActID    
    
    INSERT INTO QualityControl.ActsHistoryTasks([Name], [AssignedToEmployeeID], [ControlEmployeeID], [Status], 
        [CreateDate], [Comment], [TasksID], [BeginFromDate], ActsHistoryID)
    SELECT [Name], [AssignedToEmployeeID], [ControlEmployeeID], [Status], 
        [CreateDate], [Comment], [TasksID], [BeginFromDate], @ActHistoryID
    FROM QualityControl.ActsTasks d
    WHERE d.ActID = @ActID    

    DROP TABLE #tblID
END
GO