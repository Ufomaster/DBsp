SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   31.05.20176$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   15.06.2017$*/
/*$Version:    1.00$   $Decription: Вывод данных кумулятив для просомтра по изготовелнной, списываемой и бракумеой продукции$*/
create PROCEDURE [manufacture].[sp_ProductionTasks_FuncProduceMDS_PrepareCumulative]
    @JobStageID int,
    @ShiftID int,
    @PCCID int
AS
BEGIN
	SET NOCOUNT ON;
    
    CREATE TABLE #MDSProduce(TmcID int, Name varchar(255), Amount decimal(38, 10), FailAmount decimal(38,10), isMajorTMC bit, EmployeeID int, StatusID int, DataType smallint)
    
    INSERT INTO #MDSProduce(TmcID, Name, Amount, FailAmount, isMajorTMC, EmployeeID, StatusID, DataType)
    SELECT tt.TmcID, t.Name, tt.Amount, tt.FailAmount, tt.isMajorTMC, tt.EmployeeID, tt.StatusID, tt.DataType
    FROM --status 3 - списано, status 4 - отбраковано. статусы из PTmcStatuses
        (/*Готовая продукция + Брак. Брак Берем для генерации документа бракаавтоматычно*/
        SELECT
            tg.TmcID,
            SUM(tg.Amount * egf.PercOfWork) AS Amount,
            0 AS FailAmount,
            1 AS isMajorTMC,
            egfd.EmployeeID,
            tg.StatusID, --брак пойдет в выработку как ГП но отдельной позицией в документе.
            0 AS DataType
        FROM #TmcGroups tg
        INNER JOIN (SELECT s1.EmployeeGroupsFactID as ID, 1.0/COUNT(s1.EmployeeID) as PercOfWork
                   FROM shifts.EmployeeGroupsFactDetais AS s1
                   INNER JOIN shifts.EmployeeGroupsFact f ON f.ID = s1.EmployeeGroupsFactID AND f.ShiftID = @ShiftID
                   GROUP BY s1.EmployeeGroupsFactID) AS egf on egf.ID = tg.EmployeeGroupsFactID
        INNER JOIN shifts.EmployeeGroupsFactDetais AS egfd ON egfd.EmployeeGroupsFactID = egf.ID
        WHERE tg.DataType = 0
        GROUP BY tg.TmcID, egfd.EmployeeID, tg.StatusID

        UNION ALL

        /*Комплектующие с учетом брака на ГП*/
        SELECT tg.TmcID, 
           CASE WHEN tg.StatusID = 3 THEN SUM(tg.Amount) ELSE 0 END,
           CASE WHEN tg.StatusID = 4 THEN SUM(tg.Amount) ELSE 0 END,           
           0, NULL, tg.StatusID, 1
        FROM #TmcGroups tg
        WHERE tg.DataType <> 0
        GROUP BY tg.TmcID, tg.StatusID
		) tt
        INNER JOIN Tmc t ON t.ID = tt.TMCID
    
    --подтянем текущие отстатки на складе. для сравнния
    DECLARE @ProductionTasksID int
    
    SELECT TOP 1 @ProductionTasksID = ID FROM manufacture.ProductionTasks WHERE EndDate IS NULL AND StorageStructureSectorID = 89 ORDER BY ID DESC

    SELECT
        res.TmcID,
        res.Name, 
        CASE WHEN res.isMajorTMC = 1 THEN 'Собрано' ELSE 'Списано(+Брак)' END AS StatusName, 
        SUM(res.Amount) AS Amount, 
        StorageTMC.Amount AS StorageAmount,
        SUM(res.FailAmount) AS FailAmount,
        CASE WHEN res.DataType = 1 THEN 
           CASE WHEN (SUM(res.Amount) + SUM(res.FailAmount)) - ISNULL(StorageTMC.Amount,0) > 0 THEN CAST((SUM(res.Amount) + SUM(res.FailAmount)) - ISNULL(StorageTMC.Amount,0) AS float) ELSE NULL END 
        ELSE NULL END AS Total           
    FROM #MDSProduce res
    LEFT JOIN (   
        SELECT TMCID, isMajorTMC, CAST(SUM(MoveTypeID * Amount) as decimal(38, 10)) as Amount
        FROM
            (SELECT ptdd.TMCID, CAST(ptdd.MoveTypeID as float) as MoveTypeID,
                  ptdd.Amount, ptdd.isMajorTMC
             FROM manufacture.ProductionTasksDocDetails ptdd 
                  LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
             WHERE (ptd.ConfirmStatus = 1 OR IsNull(ptd.ConfirmStatus,0) = 0)
                 AND ptd.ProductionTasksID = @ProductionTasksID AND ISNULL(ptdd.ProductionCardCustomizeID, @PCCID) = @PCCID
                 --в подсчете игнориуем производство, перемещение куда-то, браковку и приход, если он был со склада
                 AND (ptd.ProductionTasksOperTypeID NOT IN (2,3,6) OR (ptd.ProductionTasksOperTypeID = 1 AND ptd.LinkedProductionTasksDocsID IS NOT NULL))

             UNION ALL

             SELECT ptdd.TMCID, CAST(-1 as float) as MoveTypeID,                        
                  ptdd.Amount, ptdd.isMajorTMC
             FROM manufacture.ProductionTasksDocDetails ptdd
                  LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
                  LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ptd.ProductionTasksID 
             WHERE ptd.ProductionTasksOperTypeID IN (4,5,8,10)
                  AND ptd.ProductionTasksID = @ProductionTasksID AND ISNULL(ptdd.ProductionCardCustomizeID, @PCCID) = @PCCID
             ) a 
        GROUP BY TMCID, isMajorTMC
        ) AS StorageTMC ON StorageTMC.TMCID = res.TmcID 
    GROUP BY res.TmcID, res.Name, res.isMajorTMC, StorageTMC.Amount, res.DataType
    ORDER BY res.DataType, res.Name

    DROP TABLE #MDSProduce
END
GO