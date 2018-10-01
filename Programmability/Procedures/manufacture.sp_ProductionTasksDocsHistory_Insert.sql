SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   16.06.2016$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   22.07.2016$*/
/*$Version:    1.00$   $Description: Добавление истории редактирования документов*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasksDocsHistory_Insert]
    @EmployeeID Int,
    @DocID Int,
    @OperationType Int /*0-insert, 1-update, 2-delete*/
AS
BEGIN
	SET NOCOUNT ON
    CREATE TABLE #tblID(ID Int)

    INSERT INTO manufacture.ProductionTasksDocsHistory(ModifyDate, ModifyEmployeeID, OperationType, 
        DocID, ProductionTasksID, EmployeeFromID, EmployeeToID, LinkedProductionTasksDocsID, 
        ProductionTasksOperTypeID, ConfirmStatus, CreateDate, StorageStructureSectorID, StorageStructureSectorToID, JobStageID)
    OUTPUT INSERTED.ID INTO #tblID
    SELECT GetDate(), @EmployeeID, @OperationType, 
        ID, ProductionTasksID, EmployeeFromID, EmployeeToID, LinkedProductionTasksDocsID, 
        ProductionTasksOperTypeID, ConfirmStatus, CreateDate, StorageStructureSectorID, StorageStructureSectorToID, JobStageID
    FROM manufacture.ProductionTasksDocs
    WHERE ID = @DocID

    DECLARE @HistoryID Int
    SELECT @HistoryID = ID FROM #tblID

    INSERT INTO manufacture.ProductionTasksDocsDetailsHistory(DocHistoryID,
       TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, isMajorTMC, StatusID, EmployeeID, CreateDate,
        RangeFrom, RangeTo, StatusFromID, Comments, ProductionCardCustomizeFromID, ReasonID, FailTypeID)    
    SELECT @HistoryID,
        TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, isMajorTMC, StatusID, EmployeeID, CreateDate,
        RangeFrom, RangeTo, StatusFromID, Comments, ProductionCardCustomizeFromID, ReasonID, FailTypeID
    FROM manufacture.ProductionTasksDocDetails
    WHERE ProductionTasksDocsID = @DocID

    DROP TABLE #tblID
END
GO