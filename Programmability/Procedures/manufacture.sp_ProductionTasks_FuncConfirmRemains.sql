SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    		$Create date:   18.05.2016$*/
/*$Modify:     Yuriy Oleynik$   		$Modify date:   14.03.2017$*/
/*$Version:    1.00$   $Decription: Запуск функции зафиксировать остатки $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncConfirmRemains]
    @SectorID int,
    @ProdTaskID int,
    @EmployeeID int,
    @JobStageID int = NULL,
    @CreateType tinyint = NULL
AS
BEGIN
    SET XACT_ABORT ON
    SET NOCOUNT ON;
    IF EXISTS (SELECT ID FROM manufacture.ProductionTasksDocs 
               WHERE StorageStructureSectorID = @SectorID AND ProductionTasksID = @ProdTaskID AND ProductionTasksOperTypeID = 7)
        RETURN
    
    DECLARE @DocID int, @Err Int, @MaxProdTaskID int
    DECLARE @t TABLE(ID int)

    BEGIN TRAN
    BEGIN TRY        
        /*Выполняем создание документа и его деталей*/
        INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, EmployeeToID,
            StorageStructureSectorID, ProductionTasksOperTypeID, CreateType)
        OUTPUT INSERTED.ID INTO @t
        SELECT @ProdTaskID, @EmployeeID, @SectorID, 7 /*Подтверждение остатков*/, @CreateType

        SELECT @DocID = ID FROM @t
        DELETE FROM @t
        
        /*Хитрый поиск последней сменки.
          Мы ищем сменку с максимальной плановой датой старта СМЕНЫ, которая меньше даты старта смены текущего сменного задания. 
          Исключаем из поиска сменки, которые были созданы, но остатки не были приянты
          */
        SELECT top 1 @MaxProdTaskID = pt.ID
        FROM manufacture.ProductionTasks pt
             LEFT JOIN shifts.shifts s on s.ID = pt.ShiftID
             INNER JOIN (SELECT ptd.ProductionTasksID FROM manufacture.ProductionTasksDocs ptd WHERE ptd.ProductionTasksOperTypeID = 7 GROUP BY ptd.ProductionTasksID) ptd 
                       on ptd.ProductionTasksID = pt.ID 
        WHERE pt.StorageStructureSectorID = @SectorID
              AND s.PlanStartDate < (SELECT s.PlanStartDate FROM manufacture.ProductionTasks pt LEFT JOIN shifts.shifts s on s.ID = pt.ShiftID WHERE pt.ID = @ProdTaskID)
        ORDER BY s.PlanStartDate DESC

        INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID,
            StatusID, ProductionTasksDocsID, isMajorTMC, StatusFromID, ProductionCardCustomizeFromID)      
        SELECT pta.TMCID, pta.ProductionCardCustomizeID, pta.Amount, pta.[Name], 1,
        	pta.ProductionTasksStatusID, @DocID, pta.isMajorTMC, pta.ProductionTasksStatusID, pta.ProductionCardCustomizeID  
        FROM manufacture.vw_ProductionTasksAgregation_Select pta
        WHERE pta.ProductionTasksID = @MaxProdTaskID AND pta.ProductionTasksStatusID NOT IN (2,5,6)
              AND pta.ConfirmStatus = 1 AND pta.Amount > 0 

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO