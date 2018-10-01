SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    		$Create date:   10.03.2016$*/
/*$Modify:     Yuriy Oleynik$    		$Modify date:   15.06.2017$*/
/*$Version:    1.00$   $Decription: Запуск функции принять $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncConfirmOneIncoming]
    @DID int,
    @SectorID int, 
    @ProdTaskID int,
    @EmployeeToID int,
    @JobStageID int = NULL,
    @CreateType tinyint = NULL
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @ID int, @DocID int, @Err Int
    DECLARE @t TABLE(ID int)

    /*проверка*/
    SELECT @ID = d1.ID     
    FROM manufacture.ProductionTasksDocs d1 
    WHERE d1.StorageStructureSectorToID = @SectorID AND d1.ConfirmStatus = 0 AND d1.ID = @DID        
    IF @ID IS NULL RETURN
            
    BEGIN TRAN
    BEGIN TRY   
        /*Выполняем копирование документа и его деталей*/
        INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, EmployeeFromID, EmployeeToID,
            StorageStructureSectorID, ProductionTasksOperTypeID, LinkedProductionTasksDocsID, CreateType, JobStageID)
        OUTPUT INSERTED.ID INTO @t
        SELECT @ProdTaskID, a.EmployeeFromID, @EmployeeToID, @SectorID, 1/*приход*/, a.ID, @CreateType, @JobStageID
        FROM manufacture.ProductionTasksDocs a 
        WHERE ID = @ID

        SELECT @DocID = ID FROM @t
        DELETE FROM @t

        INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
            StatusID, ProductionTasksDocsID, isMajorTMC, StatusFromID, ProductionCardCustomizeFromID)
        OUTPUT INSERTED.ID INTO @t
        SELECT p.TMCID, p.ProductionCardCustomizeID, p.Amount, p.[Name], 1, 
            p.StatusID, @DocID, p.isMajorTMC, p.StatusFromID, p.ProductionCardCustomizeID
        FROM manufacture.ProductionTasksDocDetails p
        WHERE p.ProductionTasksDocsID = @ID

        /*синхронизируем LinkedProductionTasksID и ConfirmStatus в наших исходных документах*/
        UPDATE d
        SET d.ConfirmStatus = 1, d.LinkedProductionTasksDocsID = @DocID, d.EmployeeToID = @EmployeeToID
        FROM manufacture.ProductionTasksDocs d
        WHERE ID = @ID

        COMMIT TRAN      
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH     
END
GO