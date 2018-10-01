SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    		$Create date:   07.06.2016$*/
/*$Modify:     Poliatykin Oleksii$    $Modify date:   29.08.2017$*/
/*$Version:    1.00$   $Decription:  $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_SummarySelect]
AS
BEGIN
    SET NOCOUNT ON;
    --Use three OperationTypes:
    -- 2 - production
    --   sum it value without any corrections
    -- 6 - defect
    --   sum it value 
    --   add corrections to production
    -- 8 - return from defect
    --   sum it value to production
    --   add corrections to defect 
    IF object_id('tempdb..#PTStats') is not null DROP TABLE #PTStats
    IF object_id('tempdb..#TRest') is not null DROP TABLE #TRest  
    CREATE TABLE #PTStats (ProductionTasksID int, TMCID int, StatusID tinyint, ProductionCardCustomizeID int, MoveTypeID int, Amount decimal(38,10), Type tinyint, isLinked bit, FailTypeID int)

    INSERT INTO #PTStats (ProductionTasksID, TMCID, StatusID, ProductionCardCustomizeID, MoveTypeID, Amount, Type, isLinked, FailTypeID)
    SELECT ptd.ProductionTasksID as ProductionTasksID, ptdd.TMCID, ptdd.StatusID, IsNull(tp.ProductionCardCustomizeID, ptdd.ProductionCardCustomizeID) as ProductionCardCustomizeID, ptdd.MoveTypeID, ptdd.Amount, 1 as Type, CAST(null as bit) isLinked, ptdd.FailTypeID
    FROM manufacture.ProductionTasksDocDetails ptdd 
        LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
        LEFT JOIN manufacture.ProductionTasks pt ON pt.ID = ptd.ProductionTasksID 
        --Поскольку в одном полуфабрикате может находится множество ЗЛ-ов
        LEFT JOIN TmcPCC tp on tp.TmcID = ptdd.TMCID
        LEFT JOIN (SELECT tp.TmcID, SUM(tp.CardCount) as CardCountAll
                   FROM TmcPCC tp
                   GROUP BY tp.TmcID) tpAll on tp.TmcID = tpAll.TmcID
        LEFT JOIN (SELECT zs.ShiftID, zs.Selected FROM #PT_ShiftFilter zs GROUP BY zs.ShiftID, zs.Selected) zs ON zs.ShiftID = pt.ShiftID AND zs.Selected = 1
        LEFT JOIN #PT_ZLFilter zf ON zf.PCCID = IsNull(tp.ProductionCardCustomizeID, ptdd.ProductionCardCustomizeID) AND zf.Selected = 1
    WHERE ((ptd.ProductionTasksOperTypeID in (6,8) AND ptdd.isMajorTMC = 1) OR (ptd.ProductionTasksOperTypeID = 2 AND ptdd.StatusID <> 2))
          --AND ptdd.isMajorTMC = 1
          AND (zs.ShiftID is not null OR zf.PCCID is not null)
    UNION ALL      
    /*ADD corrections to production, nonconformance and write-offs*/
    SELECT pt.id, ptdd.TMCID, ptdd.StatusFromID as StatusID, IsNull(tp.ProductionCardCustomizeID, ptdd.ProductionCardCustomizeID) as ProductionCardCustomizeID, -1 as MoveTypeID, ptdd.Amount, 1 as Type, null isLinked, ptdd.FailTypeID
    FROM manufacture.ProductionTasksDocDetails ptdd
        LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
        LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ptd.ProductionTasksID 
        --Поскольку в одном полуфабрикате может находится множество ЗЛ-ов        
        LEFT JOIN TmcPCC tp on tp.TmcID = ptdd.TMCID
        LEFT JOIN (SELECT tp.TmcID, SUM(tp.CardCount) as CardCountAll
                   FROM TmcPCC tp
                   GROUP BY tp.TmcID) tpAll on tp.TmcID = tpAll.TmcID    
        LEFT JOIN (SELECT zs.ShiftID, zs.Selected FROM #PT_ShiftFilter zs GROUP BY zs.ShiftID, zs.Selected) zs ON zs.ShiftID = pt.ShiftID AND zs.Selected = 1
        LEFT JOIN #PT_ZLFilter zf ON zf.PCCID = IsNull(tp.ProductionCardCustomizeID, ptdd.ProductionCardCustomizeID) AND zf.Selected = 1                       
    WHERE (ptd.ProductionTasksOperTypeID IN (6,8))              
          AND ptdd.isMajorTMC = 1   
          AND (zs.ShiftID is not null OR zf.PCCID is not null)             
    UNION ALL
    /*ADD corrections to production*/
    SELECT pt.id, ptdd.TMCID, ptdd.StatusFromID as StatusID, IsNull(tp.ProductionCardCustomizeID, ptdd.ProductionCardCustomizeID) as ProductionCardCustomizeID, -1 as MoveTypeID, ptdd.Amount, 3 as Type, null isLinked, ptdd.FailTypeID
    FROM manufacture.ProductionTasksDocDetails ptdd
        LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
        LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ptd.ProductionTasksID 
        --Поскольку в одном полуфабрикате может находится множество ЗЛ-ов        
        LEFT JOIN TmcPCC tp on tp.TmcID = ptdd.TMCID
        LEFT JOIN (SELECT tp.TmcID, SUM(tp.CardCount) as CardCountAll
                   FROM TmcPCC tp
                   GROUP BY tp.TmcID) tpAll on tp.TmcID = tpAll.TmcID    
    WHERE ptd.ProductionTasksOperTypeID IN (2) AND ptdd.StatusID = 2 AND ptdd.isMajorTMC = 1             
    UNION ALL
    /*ADDED tmcs*/
    SELECT ptd.ProductionTasksID, ptdd.TMCID, ptdd.StatusID, IsNull(tp.ProductionCardCustomizeID, ptdd.ProductionCardCustomizeID) as ProductionCardCustomizeID, ptdd.MoveTypeID, ptdd.Amount, 2, CASE WHEN PTD.LinkedProductionTasksDocsID is not null THEN 1 ELSE 0 END as isLinked, ptdd.FailTypeID
    FROM manufacture.ProductionTasksDocDetails ptdd 
        LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
        LEFT JOIN manufacture.ProductionTasks pt ON pt.ID = ptd.ProductionTasksID 
        --Поскольку в одном полуфабрикате может находится множество ЗЛ-ов        
        LEFT JOIN TmcPCC tp on tp.TmcID = ptdd.TMCID
        LEFT JOIN (SELECT tp.TmcID, SUM(tp.CardCount) as CardCountAll
                   FROM TmcPCC tp
                   GROUP BY tp.TmcID) tpAll on tp.TmcID = tpAll.TmcID    
        LEFT JOIN (SELECT zs.ShiftID, zs.Selected FROM #PT_ShiftFilter zs GROUP BY zs.ShiftID, zs.Selected) zs ON zs.ShiftID = pt.ShiftID AND zs.Selected = 1
        LEFT JOIN #PT_ZLFilter zf ON zf.PCCID = IsNull(tp.ProductionCardCustomizeID, ptdd.ProductionCardCustomizeID) AND zf.Selected = 1                       
    WHERE ptd.ProductionTasksOperTypeID in (1)
          AND ptdd.isMajorTMC = 1   
          AND (zs.ShiftID is not null OR zf.PCCID is not null)     
    
    --Calculate the rest of card on sectors      
	SELECT ProductionCardCustomizeID, StorageStructureSectorID, SUM(amount) as Amount
    INTO #TRest
    FROM 
    	(SELECT p.ProductionCardCustomizeID, p.StatusID
        	   , sum(Amount * MoveTypeID * IsNull(pts.Multiplier,1) * CASE WHEN tp.ID is null THEN 1 ELSE CASE WHEN tpAll.TmcID <> 0 THEN CAST(tp.CardCount as float) ELSE 0 END END) as amount
         FROM #PTStats p
               LEFT JOIN manufacture.ProductionTasksStatuses pts ON pts.ID = p.StatusID      
               LEFT JOIN TmcPCC tp on p.TmcID = tp.TMCID AND p.ProductionCardCustomizeID = tp.ProductionCardCustomizeID
               LEFT JOIN (SELECT tp.TmcID, SUM(tp.CardCount) as CardCountAll
                          FROM TmcPCC tp
                          GROUP BY tp.TmcID) tpAll on tp.TmcID = tpAll.TmcID    
         WHERE p.Type in (1,3)  
         GROUP BY p.ProductionCardCustomizeID, p.StatusID) tRest
         LEFT JOIN 
              (SELECT sssd.StorageStructureSectorID, ssm.ProductionTasksStatusID
               FROM 
                    manufacture.StorageStructureManufactures ssm 
                    LEFT JOIN manufacture.StorageStructureSectorsDetails sssd on sssd.StorageStructureID = ssm.StorageStructureID
               GROUP BY sssd.StorageStructureSectorID, ssm.ProductionTasksStatusID) ssm on tRest.StatusID = ssm.ProductionTasksStatusID
    GROUP BY ProductionCardCustomizeID, StorageStructureSectorID                       
    
    --Main script
    SELECT pcc.Name as ProductionCardCustomizeName,
           pcc.Number,
           tmc.Name as TmcName,       
           s.Name as SectorName,
           s.ID as SectorID,
           t.TMCID, 
           t.ProductionCardCustomizeID, 
           t.Amount as Amount,
           ISNULL(t.AmountF, 0) AS AmountF,
           ISNULL(t.AmountIn, 0) AS AmountIn,           
           ISNULL(t.AmountADD, 0) AS AmountADD,                
           pcc.CardCountInvoice as AmountAll,
           ISNULL(tr.Amount, 0) AS AmountRest,
           CASE WHEN (t.Amount + ISNULL(t.AmountF, 0)) > 0 THEN ROUND(ISNULL(t.AmountF * 100, 0)/(t.Amount + ISNULL(t.AmountF, 0)), 2) ELSE 0 END AS AmountFPercent,
           CEILING(tirage.Norma * CASE WHEN pct.ID = 1 THEN 24 / 2 ELSE CASE WHEN pct.ID = 2 THEN 132 ELSE 0 END END / tirage.cnt) as AmountNorma,
           CAST(CASE WHEN pcc.StatusID = 5 THEN 1 ELSE 0 END as bit) as isManufactured
    --    INTO #TTT       
    FROM (SELECT a1.ProductionCardCustomizeID, p.StorageStructureSectorID, min(a1.TmcID) as TmcID
                , SUM(CASE WHEN Type = 1 AND ssm.ProductionTasksStatusID is not null THEN a1.Amount  * CASE WHEN tp.ID is null THEN 1 ELSE CASE WHEN tpAll.TmcID <> 0 THEN CAST(tp.CardCount as float) ELSE 0 END END END) as Amount
                , SUM(CASE WHEN Type = 1 AND a1.StatusID = 3 THEN a1.Amount  * CASE WHEN tp.ID is null THEN 1 ELSE CASE WHEN tpAll.TmcID <> 0 THEN CAST(tp.CardCount as float) ELSE 0 END END END) as AmountF
                , SUM(CASE WHEN Type = 2 AND isLinked = 1 THEN a1.Amount  * CASE WHEN tp.ID is null THEN 1 ELSE CASE WHEN tpAll.TmcID <> 0 THEN CAST(tp.CardCount as float) / tpAll.CardCountAll ELSE 0 END END END) as AmountIn
                , SUM(CASE WHEN Type = 2 AND isLinked = 0 THEN a1.Amount  * CASE WHEN tp.ID is null THEN 1 ELSE CASE WHEN tpAll.TmcID <> 0 THEN CAST(tp.CardCount as float) / tpAll.CardCountAll ELSE 0 END END END) as AmountADD
                , null as AmountRest
         FROM
              (SELECT ProductionTasksID, TMCID, StatusID, ProductionCardCustomizeID, Type, isLinked, SUM(MoveTypeID * Amount) as Amount
               FROM #PTStats a 
               GROUP BY ProductionTasksID, TMCID, StatusID, ProductionCardCustomizeID, Type, isLinked) a1
               LEFT JOIN manufacture.ProductionTasks p ON p.ID = a1.ProductionTasksID  
               LEFT JOIN manufacture.ProductionTasksStatuses pts ON pts.ID = a1.StatusID      
               LEFT JOIN TmcPCC tp on a1.TmcID = tp.TMCID AND a1.ProductionCardCustomizeID = tp.ProductionCardCustomizeID
               LEFT JOIN (SELECT tp.TmcID, SUM(tp.CardCount) as CardCountAll
                          FROM TmcPCC tp
                          GROUP BY tp.TmcID) tpAll on tp.TmcID = tpAll.TmcID                        
               LEFT JOIN (SELECT sssd.StorageStructureSectorID, ssm.ProductionTasksStatusID
                          FROM 
                              manufacture.StorageStructureManufactures ssm 
                              LEFT JOIN manufacture.StorageStructureSectorsDetails sssd on sssd.StorageStructureID = ssm.StorageStructureID
                          GROUP BY sssd.StorageStructureSectorID, ssm.ProductionTasksStatusID) ssm on ssm.ProductionTasksStatusID = a1.StatusID AND ssm.StorageStructureSectorID = p.StorageStructureSectorID                                 
          WHERE a1.Amount <> 0
          GROUP BY a1.ProductionCardCustomizeID, p.StorageStructureSectorID     
          ) t
         LEFT JOIN #TRest tr on tr.StorageStructureSectorID = t.StorageStructureSectorID AND tr.ProductionCardCustomizeID = t.ProductionCardCustomizeID          
         LEFT JOIN manufacture.StorageStructureSectors s ON s.ID = t.StorageStructureSectorID      
         LEFT JOIN manufacture.ProductionTasksStatuses pts ON pts.ID = t.StorageStructureSectorID               
         LEFT JOIN ProductionCardCustomize pcc on pcc.ID = t.ProductionCardCustomizeID
         LEFT JOIN ProductionCardTypes pct on pct.ProductionCardPropertiesID = pcc.TypeID
         LEFT JOIN TMC tmc on tmc.ID = t.tmcID
         LEFT JOIN (SELECT pcm.ProductionCardCustomizeID, Sum(pcm.Norma) as Norma, COUNT(pcm.Norma) as cnt
                    FROM ProductionCardCustomizeMaterials pcm 
                         INNER JOIN TmcPCC tp on tp.TmcID = pcm.TmcID AND pcm.ProductionCardCustomizeID = tp.ProductionCardCustomizeID
                    GROUP BY pcm.ProductionCardCustomizeID
                    ) tirage on tirage.ProductionCardCustomizeID = t.ProductionCardCustomizeID
    WHERE t.Amount > 0 OR ISNULL(t.AmountF, 0) > 0            
    ORDER BY s.SortOrder
        
    DROP TABLE #PTStats   
    DROP TABLE #TRest       
END
GO