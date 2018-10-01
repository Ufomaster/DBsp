SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   09.03.2017$*/
/*$Modify:     Yuriy Oleynik$	$Modify date:   09.07.2018$*/
/*$Version:    2.00$   $Decription: Получение информации о выработке операторов$*/
CREATE PROCEDURE [manufacture].[sp_ProductionStatistic_Select2]   
    @EmployeeID int,
    @DateFrom datetime,
    @DateTo datetime
AS
BEGIN
	/*ВНИМАНИЕ! 
      На эту процедуру завязан расчет ЗП, который тянется из QlikView.
      Выбор данных в QlikView происходит через механизм 
      INSERT INTO #...
      EXEC manufacture.sp_ProductionStatistic_Select..
      Набор полей для временной таблицы предопределен. 
      Если в исходящей таблице данной процедуре будут добавлены поля, произойдет ошибка.
      Обязатально необходимо подправить процедуру sp_ProductionStatistic_SelectQlik, из которой тянуться данные в QlikView. */
      
    SET NOCOUNT ON
    IF object_id('tempdb..#SpeklerTime') is not null DROP TABLE #SpeklerTime
    IF object_id('tempdb..#SpeklerAmount') is not null DROP TABLE #SpeklerAmount
    
    /*Calculate total time per shift*/
    SELECT mTime.amount as TimeT,
           mTime.amount - CASE WHEN mTime.amount >= 6*60*60 THEN 60*60 ELSE 0 END as TimeTMinusOne,
          -- mTimeAuto.amount as TimeAuto, --it's old field that are not used now             
           s.ID as ShiftID,
           LTRIM(RTRIM(e.INN)) as [INN],
           e.ID as EmployeeID,
           sss.ID as SectorID,
           ms.[Name] as ManufactureNameT
    INTO #SpeklerTime       
    FROM 
        (SELECT MAX(t.EndDate) as [EndDate], MIN(t.StartDate) as [StartDate], t.ShiftID, t.EmployeeID, sssd.StorageStructureSectorID, SUM(DATEDIFF(s, t.StartDate, t.EndDate)) as amount
        FROM 
            (SELECT 
                src_0.ShiftID, 
                MAX(src_0.WorkPlaceID) AS WorkPlaceID, --поскольку могут добавить дубликат человека на другое рм. берем топ 1 грубо говоря.
                src_0.EmployeeID, 
                MIN(src_0.StartDate) AS StartDate, 
                MAX(src_0.EndDate) AS EndDate
            FROM ( --1из2 дубликатовзапроса, влияет на скорость выполнения. Берутся все регистрации рабочего времени за указанный период.
                  SELECT egf.ShiftID, egf.WorkPlaceID, egfd.EmployeeID, egf.StartDate as [StartDate], egf.EndDate as [EndDate] 
                  FROM shifts.EmployeeGroupsFact egf
                  LEFT JOIN shifts.EmployeeGroupsFactDetais egfd on egf.ID = egfd.EmployeeGroupsFactID
                  LEFT JOIN shifts.Shifts s ON s.ID = egf.ShiftID
                  WHERE ISNULL(egf.IsDeleted,0) = 0 AND ISNULL(egfd.IsDeleted,0) = 0 AND egf.EndDate IS NOT NULL
                      AND ((DATEADD(dd, 0, DATEDIFF(dd, 0, s.PlanStartDate)) >= DATEADD(dd, 0, DATEDIFF(dd, 0, @DateFrom))) OR @DateFrom is null)
                      AND ((DATEADD(dd, 0, DATEDIFF(dd, 0, s.PlanStartDate)) <= DATEADD(dd, 0, DATEDIFF(dd, 0, @DateTo))) OR @DateTo is null)
                      AND ((egfd.EmployeeID = @EmployeeID) OR @EmployeeID IS NULL)
                      AND ISNULL(egf.AutoCreate,0) = 0) AS src_0
            LEFT JOIN (--2из2 дубликатов запроса, влияет на скорость выполнения. Берутся все регистрации рабочего времени за указанный период.
                      SELECT egf.ShiftID, egf.WorkPlaceID, egfd.EmployeeID, egf.StartDate as [StartDate], egf.EndDate as [EndDate]
                      FROM shifts.EmployeeGroupsFact egf
                      LEFT JOIN shifts.EmployeeGroupsFactDetais egfd on egf.ID = egfd.EmployeeGroupsFactID
                      LEFT JOIN shifts.Shifts s on s.ID = egf.ShiftID
                      WHERE ISNULL(egf.IsDeleted,0) = 0 AND ISNULL(egfd.IsDeleted,0) = 0 AND egf.EndDate IS NOT NULL
                          AND ((DATEADD(dd, 0, DATEDIFF(dd, 0, s.PlanStartDate)) >= DATEADD(dd, 0, DATEDIFF(dd, 0, @DateFrom))) OR @DateFrom is null)
                          AND ((DATEADD(dd, 0, DATEDIFF(dd, 0, s.PlanStartDate)) <= DATEADD(dd, 0, DATEDIFF(dd, 0, @DateTo))) OR @DateTo is null)
                          AND ((egfd.EmployeeID = @EmployeeID) OR @EmployeeID IS NULL)
                          AND ISNULL(egf.AutoCreate,0) = 0) AS src_1 
                  --джойним между собой 2 одинаковых набора д. чтобы объединить пересеченияпо времени( включая дубликаты по разным рабочим местам)
                  ON src_0.ShiftID = src_1.ShiftID AND src_0.EmployeeID = src_1.EmployeeID AND src_0.WorkPlaceID = src_1.WorkPlaceID 
                  AND src_1.EndDate >= src_0.StartDate AND src_1.StartDate <= src_0.EndDate
                  AND (src_1.EndDate <> src_0.EndDate OR src_1.StartDate <> src_0.StartDate)           
              GROUP BY 
                  CASE WHEN src_1.StartDate IS NULL THEN src_0.StartDate ELSE 1 END, --если по лефту пусто - то нет пересечений, значит это правильный диапазон
                  CASE WHEN src_1.EndDate IS NULL THEN src_0.EndDate ELSE 1 END, --и нужно группировать доп. по датам, чтобы не сгруппировало неверно. 
                  src_0.ShiftID, 
                  src_0.EmployeeID) t
        LEFT JOIN manufacture.StorageStructureSectorsDetails sssd on sssd.StorageStructureID = t.WorkPlaceID        
        GROUP BY t.ShiftID, sssd.StorageStructureSectorID, t.EmployeeID) as mTime                
    LEFT JOIN shifts.Shifts s on mTime.ShiftID = s.ID        
    LEFT JOIN manufacture.StorageStructureSectors sss on sss.ID = mTime.StorageStructureSectorID    
    LEFT JOIN shifts.ShiftsGroups sg on sg.ID = sss.ShiftsGroupsID    
    LEFT JOIN manufacture.ManufactureStructure ms on ms.ID = sg.ManufactureStructureID
    LEFT JOIN dbo.Employees e on e.id = mTime.EmployeeID        
    ORDER BY s.ID DESC
	
    /*Calculate total amount of production according to table ProductionTasks*/
    SELECT (mAmount.amount * IsNull(sss.Multiplier,1)) as Amount,
           s.ID as ShiftID, 
           LTRIM(RTRIM(e.INN)) as [INN],
           e.ID as EmployeeID,
           mAmount.ProductionCardCustomizeID as PccID,
           sss.ID as SectorID,
           ms.[Name] as ManufactureNameT,
           mAmount.TMCID,
           mAmount.JobStageID,
          /*, sa1.Amount * n.Amount as NormMultiply*/
          /*, sa1.Amount * te.TimeT / pcc.CardCountInvoice as FactMultiply       */
          /*, n.Amount as nAmount --avg norm for Sector*/
          /*, te.TimeT --plan Time for this pcc and this sector       */
          /*if we have no teoretical difficalty for specific ZL, we find average difficulty for current sector       */
           CASE WHEN IsNull(te.TimeT,0) = 0 OR IsNull(pcc.CardCountInvoice,0) = 0 THEN IsNull(n.Amount,1) ELSE te.TimeT / pcc.CardCountInvoice END as Difficalty
    INTO #SpeklerAmount       
    FROM        
        (SELECT s.ID as ShiftID, pt.StorageStructureSectorID, ptdd.ProductionCardCustomizeID, ptdd.EmployeeID, ptdd.TMCID, ptd.JobStageID, SUM(ptdd.MoveTypeID * ptdd.Amount) as Amount
         FROM manufacture.ProductionTasksDocDetails ptdd 
         LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
         LEFT JOIN manufacture.ProductionTasks pt ON pt.ID = ptd.ProductionTasksID 
         LEFT JOIN shifts.Shifts s on pt.ShiftID = s.ID                
         WHERE ptd.ProductionTasksOperTypeID = 2 AND ptdd.StatusID <> 2
              AND ((DATEADD(dd, 0, DATEDIFF(dd, 0, s.PlanStartDate)) >= DATEADD(dd, 0, DATEDIFF(dd, 0, @DateFrom))) OR @DateFrom is null)
              AND ((DATEADD(dd, 0, DATEDIFF(dd, 0, s.PlanStartDate)) <= DATEADD(dd, 0, DATEDIFF(dd, 0, @DateTo))) OR @DateTo is null)
              AND ((ptdd.EmployeeID = @EmployeeID) OR @EmployeeID is null)       
         GROUP BY s.ID, pt.StorageStructureSectorID, ptdd.ProductionCardCustomizeID, ptdd.EmployeeID, ptdd.TMCID, ptd.JobStageID) mAmount
    LEFT JOIN shifts.Shifts s on mAmount.ShiftID = s.ID    
    LEFT JOIN manufacture.StorageStructureSectors sss on sss.ID = mAmount.StorageStructureSectorID    
    LEFT JOIN shifts.ShiftsGroups sg on sg.ID = sss.ShiftsGroupsID    
    LEFT JOIN manufacture.ManufactureStructure ms on ms.ID = sg.ManufactureStructureID
    LEFT JOIN dbo.Employees e on e.id = mAmount.EmployeeID
    LEFT JOIN ProductionCardCustomize pcc on pcc.ID = mAmount.ProductionCardCustomizeID 
    LEFT JOIN manufacture.StorageStructureSectorsNorms n on n.SectorID = sss.ID AND n.DateExpire is null    
    LEFT JOIN (SELECT Sum(t.Amount) AS TimeT, t.ProductionCardCustomizeID AS PccID, t.StorageStructureSectorID AS SectorID
               FROM ProductionCardCustomizeTechOp t
              -- LEFT JOIN TechOperations AS o on o.ID = t.TechOperationID
               GROUP BY t.StorageStructureSectorID, t.ProductionCardCustomizeID) te on te.PccID = mAmount.ProductionCardCustomizeID AND te.SectorID = sss.ID

	/* Get Time For MDS JobStages*/
    --it's a copy of SP manufacture.sp_Stat_ForAllJobsEx for some JobStages
    IF object_id('tempdb..#P') is not null DROP TABLE #P
    IF object_id('tempdb..#Stat') is not null DROP TABLE #Stat
    IF object_id('tempdb..#MDSTime') is not null DROP TABLE #MDSTime
    CREATE TABLE #P(ID int, [StorageStructureID] smallint, [EmployeeGroupsFactID] int, [PackedDate] datetime, RNum int NOT NULL, JobStageID int)
    CREATE TABLE #Stat(pID int, Time float, EmployeeGroupsFactID int, StorageStructureID smallint, ShiftID int, JobStageID int, PackedDate datetime)    
    CREATE TABLE #MDSTime(Time float, EmployeeID int, SectorID tinyint, ShiftID int, JobStageID int)           
     
    DECLARE @SomeTmcID int, @ColumnName varchar(255), @JobStageID int, @Query varchar(8000)
    
    DECLARE CRS CURSOR STATIC LOCAL FOR SELECT sa.JobStageID
                                        FROM #SpeklerAmount sa
                                        GROUP BY sa.JobStageID       
    OPEN CRS
    FETCH NEXT FROM CRS INTO @JobStageID                      
    WHILE @@FETCH_STATUS=0
    BEGIN
        SELECT TOP 1 @SomeTmcID = a.TmcID, @ColumnName = c.GroupColumnName
        FROM manufacture.JobStageChecks a
        INNER JOIN manufacture.PTmcImportTemplateColumns c on c.ID = a.ImportTemplateColumnID
        WHERE a.JobStageID = @JobStageID AND a.TypeID = 2 AND a.isDeleted = 0 AND a.UseMaskAsStaticValue = 0
        ORDER BY a.SortOrder DESC

        SET @Query = 
        'INSERT INTO #P(ID, [StorageStructureID], [EmployeeGroupsFactID], [PackedDate], RNum, JobStageID)
        SELECT p.ID, p.[StorageStructureID], p.[EmployeeGroupsFactID], p.[PackedDate], Row_Number() OVER (ORDER BY p.EmployeeGroupsFactID, p.PackedDate) as RNum, '+ CAST(@JobStageID AS Varchar(13)) +'
        FROM StorageData.pTMC_' + CAST(@SomeTmcID AS Varchar(13)) + ' p
        INNER JOIN StorageData.G_' + CAST(@JobStageID AS Varchar(13)) + ' as g on g.' + @ColumnName +' = p.ID            
        WHERE StatusID = 3 '

        EXEC (@Query)

        FETCH NEXT FROM CRS INTO @JobStageID     
    END     
    
    INSERT INTO #Stat(pID, EmployeeGroupsFactID, Time, StorageStructureID, ShiftID, JobStageID, PackedDate)
    SELECT p.ID, p.EmployeeGroupsFactID, DATEDIFF(ms, p1.PackedDate, p.PackedDate)/1000.0 as Time, p.StorageStructureID, e.ShiftID as ShiftID, p.JobStageID, p.PackedDate
    FROM #P p
         LEFT JOIN #P p1 on (p.RNum = p1.RNum + 1) AND (p.EmployeeGroupsFactID = p1.EmployeeGroupsFactID) AND (p.JobStageID = p1.JobStageID)
         LEFT JOIN shifts.EmployeeGroupsFact e on e.ID = p.EmployeeGroupsFactID

	UPDATE tab
    SET Time = avgTime
    FROM
        (SELECT s.Time, g.avgTime
        FROM #Stat s
             LEFT JOIN (SELECT s.JobStageID, s.EmployeeGroupsFactID, Round(AVG(s.Time),3) as avgTime
                        FROM #Stat s
                        WHERE s.Time is not null
                        GROUP BY s.JobStageID, s.EmployeeGroupsFactID) g on (g.EmployeeGroupsFactID = s.EmployeeGroupsFactID) AND (g.JobStageID = s.JobStageID)
	    WHERE s.Time is NULL) tab         
	
    INSERT INTO #MDSTime(EmployeeID, SectorID, ShiftID, JobStageID, Time)
	SELECT egf.EmployeeID, sssd.StorageStructureSectorID, st.ShiftID, st.JobStageID, Sum(st.TimeSum) as TimeSum
    FROM  
        (SELECT EmployeeGroupsFactID, StorageStructureID, ShiftID, JobStageID, Sum(Time) as TimeSum
        FROM #Stat s
        GROUP BY EmployeeGroupsFactID, StorageStructureID, ShiftID, JobStageID) st
        INNER JOIN shifts.EmployeeGroupsFactDetais egf on egf.EmployeeGroupsFactID = st.EmployeeGroupsFactID
        LEFT JOIN manufacture.StorageStructureSectorsDetails sssd on sssd.StorageStructureID = st.StorageStructureID  
	GROUP BY egf.EmployeeID, sssd.StorageStructureSectorID, st.ShiftID, st.JobStageID
    /* END MDS*/
	
    /*Final select*/
    SELECT 
    	  ms.ID as ManufactureID
          , ms.[Name] as ManufactureName
          , sss.ID as SectorID
          , sss.[Name] as SectorName
          , e.ID as EmployeeID          
          , e.FullName as EmployeeFullName
          , e.Code1C as EmployeeCode1C
          , e.[INN] as [EmployeeINN]
  --        , dpos.PositionName AS EmployeePositionName
          , ISNULL(sa.ShiftID, st.ShiftID) AS ShiftID
          , DATEADD(dd, 0, DATEDIFF(dd, 0, s.PlanStartDate)) as [ShiftStartDate]               
--          , sa.[INN] as [INN]
          , sa.PccID as PCCID
    /*      , IsNull(tp.ProductionCardCustomizeID, sa.PccID) as ProductionCardCustomizeID*/
          , pcc.Name as PCCName
          , pcc.Number as PCCNumber
--          , tp.CardCount
--          , tpAll.CardCountAll
--          , IsNull(sa.Amount,0) as saAmount /* card count that were produced  */
          , pcc.CardCountInvoice
          , sa.TmcID      
--          , sa.Difficalty           
--          , sa.Amount * sa.Difficalty as AmountAvg 
--          , saG.AmountDifficalty
--          , (sa.Amount * sa.Difficalty) / (saG.AmountDifficalty) as Proportion
          , st.TimeT as TimeAll
          , st.TimeTMinusOne as TimeAllMinusOne
          /*get proportion for ZL*/
          , sa.Amount /*Count that user write down in production tasks*/
            * CASE WHEN tp.ID is null THEN 1 ELSE CASE WHEN tpAll.TmcID <> 0 THEN CAST(tp.CardCount as float) / tpAll.CardCountAll ELSE 0 END END /*Calc part of complex TL for current ZL*/
            as [Amount]  
--          , toC.[Name] as [ТО]
--          , js.TekOp
	      , CASE WHEN toC.ID IS NULL THEN js.TechnologicalOperationID ELSE toC.ID END AS TechnologicalOperationID 
--          , CASE WHEN toC.[Name] is null THEN js.TekOp ELSE toC.[Name] END as [TO]
          , CASE WHEN toC.[Name] is null THEN 'TOFact' ELSE 'TOPlan' END as TOType
          , st.TimeTMinusOne 
            * CASE WHEN tp.ID is null THEN 1 ELSE CASE WHEN tpAll.TmcID <> 0 THEN CAST(tp.CardCount as float) / tpAll.CardCountAll ELSE 0 END END /*Calc part of complex TL for current ZL*/
            /* (mt.Time / sa.Amount / 3600) - actual difficalty coefficient */
            /* (sa.Difficalty) - teoretical difficalty coefficient */
            * CASE WHEN IsNull(saG.AmountDifficalty,0) <> 0 THEN
                  (sa.Amount * CASE WHEN ISNULL(sa.Amount,0)=0 OR IsNull(mt.Time,0)=0 THEN sa.Difficalty ELSE mt.Time/sa.Amount/3600 END) / (saG.AmountDifficalty) 
              ELSE null
              END 
            as TimeAmountSec     
         , CAST(st.TimeTMinusOne 
            * CASE WHEN tp.ID is null THEN 1 ELSE CASE WHEN tpAll.TmcID <> 0 THEN CAST(tp.CardCount as float) / tpAll.CardCountAll ELSE 0 END END /*Calc part of complex TL for current ZL*/
            * CASE WHEN IsNull(saG.AmountDifficalty,0) <> 0 THEN
                  (sa.Amount * CASE WHEN ISNULL(sa.Amount,0)=0 OR IsNull(mt.Time,0)=0 THEN sa.Difficalty ELSE mt.Time/sa.Amount/3600 END) / (saG.AmountDifficalty) 
              ELSE null
              END    
            / 3600 as numeric(38,10))
            as TimeAmountHour
         , tOper.TimeAmount/IsNull(pcc.CardCountInvoice, 1) as TOTimePerOneCard
    FROM #SpeklerAmount sa
         LEFT JOIN (SELECT sa.SectorID, sa.[ShiftID], sa.[EmployeeID], sum(IsNull(sa.Amount,0)) Amount, sum(IsNull(sa.Amount,0)* 
                                                                                                        CASE WHEN IsNull(sa.Amount,0) = 0 OR IsNull(mt.Time,0)=0 
                                                                                                             THEN IsNull(sa.Difficalty,0)
                                                                                                             ELSE mt.Time/sa.Amount/3600 
                                                                                                        END) AmountDifficalty
                    FROM #SpeklerAmount sa
                    LEFT JOIN #MDSTime mt on mt.SectorID = sa.SectorID AND mt.ShiftID = sa.ShiftID AND mt.EmployeeID = sa.EmployeeID AND mt.JobStageID = sa.JobStageID     
                    GROUP BY sa.SectorID, sa.[ShiftID], sa.[EmployeeID]) saG on saG.SectorID = sa.SectorID AND saG.ShiftID = sa.ShiftID AND saG.EmployeeID = sa.EmployeeID
         /*Поскольку в одном полуфабрикате может находится множество ЗЛ-ов       */
         LEFT JOIN TmcPCC tp on tp.TmcID = sa.TMCID
         LEFT JOIN (SELECT tp.TmcID, SUM(tp.CardCount) as CardCountAll
                    FROM TmcPCC tp
                    GROUP BY tp.TmcID) tpAll on tpAll.TmcID = sa.TmcID
         LEFT JOIN ProductionCardCustomize pcc on pcc.ID = IsNull(tp.ProductionCardCustomizeID, sa.PccID)                
         LEFT JOIN ProductionCardTypes pct on pct.ProductionCardPropertiesID = pcc.TypeID     
         /* MDS */
         LEFT JOIN #MDSTime mt on mt.SectorID = sa.SectorID AND mt.ShiftID = sa.ShiftID AND mt.EmployeeID = sa.EmployeeID AND mt.JobStageID = sa.JobStageID
		 /* END MDS */
         /* Don't need - only for upload*/
         /*END*/
         FULL JOIN #SpeklerTime st on st.SectorID = sa.SectorID AND st.ShiftID = sa.ShiftID AND st.EmployeeID = sa.EmployeeID
         LEFT JOIN vw_Employees e on e.ID = ISNULL(sa.EmployeeID, st.EmployeeID)
--         LEFT JOIN vw_DepartmentPositions dpos ON dpos.ID = e.DepartmentPositionID
         LEFT JOIN Shifts.Shifts s on s.ID = ISNULL(sa.ShiftID, st.ShiftID)
         LEFT JOIN manufacture.StorageStructureSectors sss on sss.ID = ISNULL(sa.SectorID, st.SectorID)
         LEFT JOIN shifts.ShiftsGroups sg on sg.ID = sss.ShiftsGroupsID
         LEFT JOIN manufacture.ManufactureStructure ms on ms.ID = sg.ManufactureStructureID
         LEFT JOIN (SELECT SUM(t.Amount) AS TimeAmount, t.ProductionCardCustomizeID, t.StorageStructureSectorID, MAX(t.TechnologicalOperationID) as TechnologicalOperationID
                   FROM ProductionCardCustomizeTechOp t 
                   GROUP BY t.ProductionCardCustomizeID, t.StorageStructureSectorID) tOper on tOper.StorageStructureSectorID = sa.SectorID and tOper.ProductionCardCustomizeID = sa.PCCID
         LEFT JOIN manufacture.TechnologicalOperations toC on toC.ID = tOper.TechnologicalOperationID
         LEFT JOIN manufacture.JobStages js on js.ID = sa.JobStageID
    --ignore all results with zero production     
    --WHERE IsNull(sa.Amount,0) > 0  Oleynik - commented   
    ORDER BY ShiftStartDate, SectorName, PCCNumber
    
    DROP TABLE #P
    DROP TABLE #Stat
    DROP TABLE #MDSTime
    DROP TABLE #SpeklerTime
    DROP TABLE #SpeklerAmount
END
GO