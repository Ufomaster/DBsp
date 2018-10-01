SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   01.11.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   09.12.2016$*/
/*$Version:    1.00$   $Decription: $*/
create PROCEDURE [manufacture].[sp_ProductionTasks_MassMovePrepare_obsolete]
    @ProdTaskID int,
    @JobStageID int
AS
BEGIN
	SET NOCOUNT ON;
    
--    DECLARE @ProdTaskID int, @JobStageID int SELECT @ProdTaskID = 1041, @JobStageID = 554

    --заполним список коефф по НПтмц, макс кол-во на выбранном РМ/участке - WOFAmount оставляем = 0, заполним потом после расчетов что списать нуно.
    INSERT INTO #TMCKoef(ID, TMCID, TmcName, Koef, AddAmount, MaxAmount)
    SELECT 
        j.ID, j.TMCID, t.name, j.Koef, j.AddAmount, SUM(a.Amount)
    FROM manufacture.JobStageNonPersTMC j
    INNER JOIN TMC t ON t.ID = j.TMCID
    LEFT JOIN manufacture.vw_ProductionTasksAgregation_Select a ON a.TMCID = j.TMCID AND a.ProductionTasksID = @ProdTaskID  AND a.ProductionTasksStatusID IN (1,2,3)
    LEFT JOIN manufacture.JobStageChecks c ON c.JobStageID = @JobStageID AND c.isDeleted = 0 AND c.CheckDB = 1 AND c.TmcID = a.TMCID    
    WHERE j.JobStageID = @JobStageID AND c.ID IS NULL
    GROUP BY j.ID, j.TMCID, t.name, j.Koef, j.AddAmount
        
    --заполним список РАБОЧИХ мест поиском по ПТМЦ
    DECLARE @SomeTmcID int, @Query varchar(max), @ColumnName varchar(255), @MaxCount int
    SELECT TOP 1 @SomeTmcID = jsc.TmcID, @ColumnName = c.GroupColumnName
    FROM manufacture.JobStageChecks jsc
        INNER JOIN manufacture.JobStages js on jsc.JobStageID = js.ID
        LEFT JOIN manufacture.PTmcImportTemplateColumns c ON c.ID = jsc.ImportTemplateColumnID
    WHERE js.ID = @JobStageID AND jsc.CheckDB = 1 AND jsc.TypeID = 2 AND jsc.TmcID IS NOT NULL

    IF @SomeTmcID IS NOT NULL
        SELECT @Query = 
            'INSERT INTO #PTMCSS(SSID, Amount, SectorID)
             SELECT res.StorageStructureID, 
                    SUM(res.cnt),
                    manufacture.fn_GetSectorID_JobStageID_SSID (' + CAST(@JobStageID AS varchar) + ', res.StorageStructureID)                              
             FROM (
                 SELECT 
                     a.StorageStructureID, 
                     CASE WHEN a.StatusID = 2 THEN COUNT(a.ID) ELSE 0 END AS cnt,
                     a.StatusID
                FROM StorageData.pTMC_' + CAST(@SomeTmcID AS varchar) + ' a
                INNER JOIN StorageData.G_' + CAST(@JobStageID as varchar(11)) + ' as g on g.' + @ColumnName + ' = a.ID
                INNER JOIN manufacture.StorageStructure ss ON ss.ID = a.StorageStructureID AND ISNULL(ss.CSStorage, 0) = 0
                WHERE a.StorageStructureID IS NOT NULL
                GROUP BY a.StatusID, a.StorageStructureID
                ) res
            GROUP BY res.StorageStructureID'
    ELSE
    BEGIN
        SELECT TOP 1 @SomeTmcID = jsc.TmcID, @ColumnName = c.GroupColumnName, @MaxCount = ISNULL(jsc.MaxCount, 0)
        FROM manufacture.JobStageChecks jsc
             INNER JOIN manufacture.JobStages js on jsc.JobStageID = js.ID
             LEFT JOIN manufacture.PTmcImportTemplateColumns c ON c.ID = jsc.ImportTemplateColumnID             
        WHERE js.ID = @JobStageID AND jsc.CheckDB = 1 AND jsc.TypeID = 1
        ORDER BY jsc.SortOrder DESC 
        
        IF @SomeTmcID IS NOT NULL
            SELECT @Query = 
                'INSERT INTO #PTMCSS(SSID, Amount, SectorID)
                 SELECT 
                     a.StorageStructureID, 
                     COUNT(a.ID) * ' + CAST(ISNULL(@MaxCount, 0) AS varchar) + ', 
                     manufacture.fn_GetSectorID_JobStageID_SSID (' + CAST(@JobStageID AS varchar) + ', a.StorageStructureID)
                FROM StorageData.pTMC_' + CAST(@SomeTmcID AS varchar) + ' a
                --INNER JOIN StorageData.G_' + CAST(@JobStageID as varchar(11)) + ' as g on g.' + @ColumnName + ' = a.ID
                INNER JOIN manufacture.StorageStructure ss ON ss.ID = a.StorageStructureID AND ISNULL(ss.CSStorage, 0) = 0
                WHERE a.StatusID =2 AND a.StorageStructureID IS NOT NULL
                GROUP BY a.StorageStructureID'
    END
    EXEC(@Query)
    
    --найдем последние сменки в которых конфирмнутые остатки
    CREATE TABLE #SSSFilter(SectorID INT)    
    SELECT @Query = 
        'INSERT INTO #SSSFilter(SectorID)
         SELECT
             manufacture.fn_GetSectorID_JobStageID_SSID (' + CAST(@JobStageID AS varchar) + ', a.StorageStructureID)
         FROM StorageData.pTMC_' + CAST(@SomeTmcID AS varchar) + ' a
         INNER JOIN manufacture.StorageStructure ss ON ss.ID = a.StorageStructureID AND ISNULL(ss.CSStorage, 0) = 0
         WHERE a.StorageStructureID IS NOT NULL
         GROUP BY a.StorageStructureID'
         
    EXEC(@Query)

    --заполним список выданных материалов на РМ по сменкам по НпТМЦ    
    INSERT INTO #NTMCActiveTotals(ID, TMCID, TmcName, Amount, SectorID, FailAmount)
    SELECT res.ID, res.TMCID, res.Name, SUM(res.Amount), res.StorageStructureSectorID, SUM(res.FailAmount)
    FROM(
        SELECT pt.ID, a.TMCID, a.Name, 
            CASE WHEN a.ProductionTasksStatusID = 1 THEN SUM(a.Amount) ELSE 0 END AS Amount, 
            pt.StorageStructureSectorID, 
            0 AS FailAmount
        FROM manufacture.vw_ProductionTasksAgregation_Select a
        INNER JOIN manufacture.ProductionTasks pt ON pt.ID = a.ProductionTasksID
        INNER JOIN (SELECT MAX(v.ID) AS ID
                    FROM manufacture.ProductionTasks v
                    INNER JOIN manufacture.ProductionTasksDocs dd ON dd.ProductionTasksID = v.ID AND dd.ProductionTasksOperTypeID = 7
                    GROUP BY v.StorageStructureSectorID) ptf ON ptf.ID = pt.ID
        INNER JOIN #SSSFilter p ON p.SectorID = pt.StorageStructureSectorID
        LEFT JOIN manufacture.JobStageChecks c ON c.JobStageID = @JobStageID AND c.isDeleted = 0 AND c.CheckDB = 1 AND c.TmcID = a.TMCID
        INNER JOIN manufacture.JobStageNonPersTMC jp ON jp.JobStageID = @JobStageID AND a.TMCID = jp.TMCID
        WHERE a.ProductionTasksStatusID = 1 AND /*pt.EndDate IS NULL AND pt.StartDate IS NOT NULL AND*/ a.Amount <> 0 AND c.ID IS NULL
        GROUP BY pt.ID, a.TMCID, a.Name, pt.StorageStructureSectorID, a.ProductionTasksStatusID, a.ProductionTasksID) res
    GROUP BY res.ID, res.TMCID, res.Name, res.StorageStructureSectorID

    DROP TABLE #SSSFilter
                                           
    INSERT INTO #DetailRes(TMCID, TmcName, 
        AmountNTMCOnPlace, --Кол-во НПТМЦ на РМ
        MaxAmount, 
        WOFAmount, 
        SSID, 
        AmountPTMCOnPlace, --Кол-во ПТМЦ на РМ
        SectorID, SectorName, 
        AmountNeeded)
    SELECT a.TMCID, a.TmcName, ISNULL(c.Amount, 0), a.MaxAmount, 
    	ISNULL(a.Koef * b.Amount, 0) + ISNULL(a.AddAmount, 0),
        b.SSID, ISNULL(b.Amount, 0) AS AmountPTMCOnPlace, 
        b.SectorID, s.Name,
        ISNULL(c.Amount, 0) - (ISNULL(a.Koef * b.Amount, 0) + ISNULL(a.AddAmount, 0))  /*+ ISNULL(a.MaxAmount, 0)*/ --сколько нужно на РМ
    FROM #TMCKoef a
    CROSS JOIN #PTMCSS b --ON 1=1
    INNER JOIN manufacture.StorageStructureSectors AS s ON s.ID = b.SectorID
    LEFT JOIN #NTMCActiveTotals AS c ON c.TMCID = a.TMCID AND c.SectorID = b.SectorID
    
    UPDATE a 
    SET a.WOFAmount = CASE WHEN z.WOFAmount*(-1) < 0 THEN 0 ELSE z.WOFAmount*(-1) END
    FROM #TMCKoef a
    INNER JOIN (SELECT TMCID, Sum(ISNULL(AmountNTMCOnPlace,0) - ISNULL(WOFAmount,0)) AS WOFAmount FROM #DetailRes GROUP BY TMCID) z ON z.TMCID = a.TMCID
		
		   --интерфейс использует таблицы #TMCKoef и #DetailRes  
           
/* Мастер селект на форме
         SELECT SSID, AmountPTMCOnPlace, SectorID, SectorName, 
ISNULL(AmountPTMCOnPlace,0) - ISNULL(MIN(AmountNTMCOnPlace), 0) AS Total, 
MIN(AmountNTMCOnPlace) AS AmountNTMCOnPlace
FROM #DetailRes 
GROUP BY SSID, AmountPTMCOnPlace, SectorID, SectorName
ORDER BY SectorID*/

/*Дитейл селект на форме 
  SELECT * FROM #DetailRes*/
   
END
GO