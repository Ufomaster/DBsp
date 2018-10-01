SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   21.06.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   22.12.2016$*/
/*$Version:    1.00$   $Decription: Редактирование документа. Правка Количества*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncEditAmountChange]
    @DocDetailID int,
    @OldValue decimal(38, 10),
    @ProdTaskID int,
    @EmployeeID int
AS
BEGIN
    DECLARE @Err Int
    DECLARE @DocID int
        
    SELECT @DocID = a.ProductionTasksDocsID
    FROM manufacture.ProductionTasksDocDetails a
    WHERE a.ID = @DocDetailID

    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY

        SET NOCOUNT ON
        CREATE TABLE #tblID(ID Int)

        INSERT INTO manufacture.ProductionTasksDocsHistory(ModifyDate, ModifyEmployeeID, OperationType, 
            DocID, ProductionTasksID, EmployeeFromID, EmployeeToID, LinkedProductionTasksDocsID, 
            ProductionTasksOperTypeID, ConfirmStatus, CreateDate, StorageStructureSectorID, StorageStructureSectorToID, JobStageID)
        OUTPUT INSERTED.ID INTO #tblID
        SELECT GetDate(), @EmployeeID, 1, 
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
            TMCID, ProductionCardCustomizeID, @OldValue, [Name], MoveTypeID, isMajorTMC, StatusID, EmployeeID, CreateDate,
            RangeFrom, RangeTo, StatusFromID, Comments, ProductionCardCustomizeFromID, ReasonID, FailTypeID
        FROM manufacture.ProductionTasksDocDetails a
        WHERE a.ID = @DocDetailID

        DROP TABLE #tblID
        
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR;
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err;
    END CATCH
END
GO