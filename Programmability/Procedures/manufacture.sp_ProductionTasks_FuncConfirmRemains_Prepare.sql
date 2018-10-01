SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$ 	$Create date:   09.08.2016$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   14.03.2017$*/
/*$Version:    1.00$   $Decription: Предварительное отображение фиксирования остатков $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncConfirmRemains_Prepare]
    @ProdTaskID int
AS
BEGIN
	DECLARE @MaxProdTaskID int, @SectorID int

    SELECT top 1 @SectorID = pt.StorageStructureSectorID
    FROM manufacture.ProductionTasks pt
    WHERE pt.ID = @ProdTaskID
    /*Хитрый поиск последней сменки.
      Мы ищем сменку с максимальной плановой датой старта СМЕНЫ, которая меньше даты старта смены текущего сменного задания. */
    SELECT top 1 @MaxProdTaskID = pt.ID
    FROM manufacture.ProductionTasks pt
         LEFT JOIN shifts.shifts s on s.ID = pt.ShiftID
         INNER JOIN (SELECT ptd.ProductionTasksID FROM manufacture.ProductionTasksDocs ptd WHERE ptd.ProductionTasksOperTypeID = 7 GROUP BY ptd.ProductionTasksID) ptd 
                   on ptd.ProductionTasksID = pt.ID 
    WHERE pt.StorageStructureSectorID = @SectorID
          AND s.PlanStartDate < (SELECT s.PlanStartDate FROM manufacture.ProductionTasks pt LEFT JOIN shifts.shifts s on s.ID = pt.ShiftID WHERE pt.ID = @ProdTaskID)
    ORDER BY s.PlanStartDate DESC
    
    SELECT pta.TMCID, pta.ProductionCardCustomizeID, pta.Amount, pta.[Name], pta.Number, pta.StatusName,
        pta.ProductionTasksStatusID, pta.isMajorTMC, pta.ProductionTasksStatusID, pta.ProductionCardCustomizeID  
    FROM manufacture.vw_ProductionTasksAgregation_Select pta
    WHERE pta.ProductionTasksID = @MaxProdTaskID AND pta.ProductionTasksStatusID NOT IN (2,5,6)
          AND pta.ConfirmStatus = 1 AND pta.Amount > 0 
END
GO