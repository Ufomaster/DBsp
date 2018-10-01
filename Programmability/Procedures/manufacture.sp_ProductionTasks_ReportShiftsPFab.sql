SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleksii Poliatykin$    $Create date:   25.10.2017$*/
/*$Modify:     Oleksii Poliatykin$    $Modify date:   03.11.2017$*/
/*$Version:    1.00$   $Decription: Выборка для отчета по производству за смены - ПОЛУФАБРИКАТЫ$*/

CREATE PROCEDURE [manufacture].[sp_ProductionTasks_ReportShiftsPFab]
@ShiftDate DATETIME,
@ManufactureStructureID int, 
@ShiftsTypesNamesID int
AS
BEGIN
-- для тестовоно запуска в менеджере 
-- запрос по готой продукции по участкам
-- закоментировать в процедуре    
/*
    DECLARE 
    @ShiftDate DATETIME,
    @ManufactureStructureID int, 
    @ShiftsTypesNamesID int
    SELECT  @ShiftDate = '2017-10-20', @ManufactureStructureID = 2,  @ShiftsTypesNamesID = 2
*/
-- end закоментировать в процедуре


    IF object_id('tempdb..#shifts') IS NOT NULL DROP TABLE #shifts
    IF object_id('tempdb..#StatusMajor') IS NOT NULL DROP TABLE #StatusMajor
    IF object_id('tempdb..#ReportO') IS NOT NULL DROP TABLE #ReportO
    IF object_id('tempdb..#ReportKK') IS NOT NULL DROP TABLE #ReportKK
    IF object_id('tempdb..#Rep') IS NOT NULL DROP TABLE #Rep
    IF object_id('tempdb..#RepOut') IS NOT NULL DROP TABLE #RepOut    
        
    SELECT 
          isnull(b.id, a.id) AS id 
        , case when  b.id is null then 1 else 0 end AS old
        , case when  b.id is null then a.StorageStructureSectorID else b.StorageStructureSectorID end AS StorageStructureSectorID
    INTO #shifts
    FROM 
        (
        SELECT 
              max(s.ID) AS Id 
            , max(s.PlanStartDate) AS Dates
            , pt.StorageStructureSectorID
            , sss.Name AS SectorName
            , ms.name AS ManufactureName
            , 1 old
        FROM shifts.Shifts s
            JOIN shifts.ShiftsTypes st on st.ID = s.ShiftTypeID 
            JOIN  manufacture.ProductionTasks pt on pt.ShiftID = s.id
            JOIN manufacture.StorageStructureSectors sss on sss.id = pt.StorageStructureSectorID
            JOIN shifts.ShiftsGroups sg on sg.ID = sss.ShiftsGroupsID
            JOIN manufacture.ManufactureStructure ms on ms.id = sg.ManufactureStructureID
        WHERE 
                sg.ManufactureStructureID = @ManufactureStructureID
            AND 
            (
                (s.PlanStartDate < DATEADD(day, 1, @shiftDate)) 
                or  
                (   
                        st.ShiftsTypesNamesID = @ShiftsTypesNamesID   
                    AND s.PlanStartDate >= DATEADD(SECOND, 1, @shiftDate) 
                    AND s.PlanStartDate < DATEADD(day, 1, @shiftDate)
                    AND s.PlanEndDate >= DATEADD(SECOND, 1, @shiftDate) 
                    AND s.PlanEndDate < DATEADD(day, 1, @shiftDate)                    
                )
            )
        GROUP BY pt.StorageStructureSectorID , sss.Name, ms.name
        ) a 
        LEFT JOIN 
            (
            SELECT 
                  max(s.ID) AS Id 
                , max(s.PlanStartDate) AS Dates
                , pt.StorageStructureSectorID
                , sss.Name AS SectorName
                , ms.name AS ManufactureName
                , 0 old
            FROM shifts.Shifts s
                JOIN shifts.ShiftsTypes st on st.ID = s.ShiftTypeID 
                JOIN  manufacture.ProductionTasks pt on pt.ShiftID = s.id
                JOIN manufacture.StorageStructureSectors sss on sss.id = pt.StorageStructureSectorID
                JOIN shifts.ShiftsGroups sg on sg.ID = sss.ShiftsGroupsID
                JOIN manufacture.ManufactureStructure ms on ms.id = sg.ManufactureStructureID
            WHERE 
                    sg.ManufactureStructureID = @ManufactureStructureID
                AND st.ShiftsTypesNamesID = @ShiftsTypesNamesID
                AND s.PlanStartDate >= DATEADD(SECOND, 1, @shiftDate) 
                AND s.PlanStartDate < DATEADD(day, 1, @shiftDate)
            GROUP BY pt.StorageStructureSectorID , sss.Name, ms.name
            ) b on b.StorageStructureSectorID = a.StorageStructureSectorID

    SELECT DISTINCT  -- статусы готовой продукции на участке
          sss.id
        , pts.id AS StatusToID
        , pts.Name AS StatusToName
        , sss.Name AS StorageStructureSectorName
        , sssd.StorageStructureSectorID
    INTO #StatusMajor    
    FROM manufacture.StorageStructureManufactures ssm
        LEFT JOIN manufacture.StorageStructure ss on ss.id = ssm.StorageStructureID
        LEFT JOIN manufacture.ProductionTasksStatuses pts on  pts.ID = ssm.ProductionTasksStatusID
        LEFT JOIN manufacture.StorageStructureSectorsDetails sssd on sssd.StorageStructureID = ssm.StorageStructureID
        LEFT JOIN manufacture.StorageStructureSectors sss on sss.ID = sssd.StorageStructureSectorID
    WHERE ssm.ManufactureStructureID = @ManufactureStructureID

    SELECT 
        t.ShiftID, 
        t.StorageStructureSectorID, 
        sss.name Sector,  
        pcc.Name AS ProductionCardCustomizeName,
        pcc.Number,
        tmc.Name,
        pts.Name AS StatusName,
        IsNull(u.[Name],'шт.') AS UnitName,
        t.ProductionTasksID, 
        t.TMCID, 
        t.StatusID, 
        t.ProductionCardCustomizeID, 
        t.isMajorTMC,
        t.Amount,
        t.ConfirmStatus
    INTO #ReportO       
    FROM 
        (SELECT ShiftID,StorageStructureSectorID, ProductionTasksID, TMCID, StatusID, ProductionCardCustomizeID, isMajorTMC, CAST(SUM(MoveTypeID * Amount) AS decimal(38, 10)) AS Amount, ConfirmStatus
        FROM
            (/*Data FROM documents*/
            SELECT pt.ShiftID, pt.StorageStructureSectorID, ptd.ProductionTasksID AS ProductionTasksID, ptdd.TMCID, ptdd.StatusID, ptdd.ProductionCardCustomizeID, CAST(ptdd.MoveTypeID AS float) AS MoveTypeID,
                ptdd.Amount, ptdd.isMajorTMC, IsNull(ptd.ConfirmStatus,1) AS ConfirmStatus
            FROM manufacture.ProductionTasksDocDetails ptdd 
                LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
                LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ptd.ProductionTasksID        
                
            WHERE (ptd.ConfirmStatus = 1 OR IsNull(ptd.ConfirmStatus,0) = 0)
            UNION ALL      
            /*ADD corrections to production, nonconformance AND write-offs*/
            SELECT pt.ShiftID, pt.StorageStructureSectorID, pt.id, ptdd.TMCID, ptdd.StatusFromID AS StatusID, ptdd.ProductionCardCustomizeFromID AS ProductionCardCustomizeID, CAST(-1 AS float) AS MoveTypeID,
                ptdd.Amount, ptdd.isMajorTMC, 1
            FROM manufacture.ProductionTasksDocDetails ptdd
                LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
                LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ptd.ProductionTasksID 
            WHERE (ptd.ProductionTasksOperTypeID IN (4,5,6,8,10))
                /*ADD additional minus for previous status to MajorTMC*/
                OR (ptdd.isMajorTMC = 1 AND ptd.ProductionTasksOperTypeID IN (2) AND ptdd.StatusID = 2)
                OR (ptdd.isMajorTMC = 0 AND ptd.ProductionTasksOperTypeID IN (2) AND ptdd.StatusFromID is not null)
            ) a 
        GROUP BY ShiftID, StorageStructureSectorID, ProductionTasksID, TMCID, StatusID, ProductionCardCustomizeID, isMajorTMC, ConfirmStatus
        ) t
        LEFT JOIN ProductionCardCustomize pcc  on pcc.ID = t.ProductionCardCustomizeID
        LEFT JOIN TMC tmc on tmc.ID = t.tmcID
        LEFT JOIN manufacture.ProductionTasksStatuses pts on pts.ID = t.StatusID
        LEFT JOIN Units u ON u.ID = tmc.UnitID
        LEFT JOIN manufacture.ProductionTasks pt on pt.ID = t.ProductionTasksID 
        LEFT JOIN manufacture.StorageStructureSectors sss on sss.ID = pt.StorageStructureSectorID
        JOIN #shifts s on s.id = t.ShiftID and s.StorageStructureSectorID = t.StorageStructureSectorID

    SELECT
        pt.ShiftID,
        ptdd.TMCID, 
        ptd.ProductionTasksOperTypeID,
        ptdd.StatusID,
        ptdd.StatusFromID,
        ptdd.ProductionCardCustomizeID,
        pcc.Number,
        ptdd.isMajorTMC,
        pt.StorageStructureSectorID,
        min(ptdd.id) AS sort,
        tmc.Name,
        sum(ptdd.Amount) AS Amount,
        ptot.Name AS OperType,
        ptsTo.Name AS StatusTo,
        ptsFrom.Name AS StatusFrom,
        sss.Name AS Sector
        ,sss.IsCS
    INTO #ReportKK
    FROM manufacture.ProductionTasksDocDetails ptdd
        LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID
        LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ptd.ProductionTasksID 
        LEFT JOIN manufacture.StorageStructureSectors sss on sss.ID = pt.StorageStructureSectorID
        LEFT JOIN manufacture.ProductionTasksStatuses ptsTo on ptsTo.ID = ptdd.StatusID
        LEFT JOIN manufacture.ProductionTasksStatuses ptsFrom on ptsFrom.ID = ptdd.StatusFromID
        LEFT JOIN manufacture.ProductionTasksOperationTypes ptot on ptot.id = ptd.ProductionTasksOperTypeID
        LEFT JOIN TMC tmc on tmc.ID = ptdd.TMCID
        LEFT JOIN ProductionCardCustomize pcc on pcc.id = ptdd.ProductionCardCustomizeID        
        JOIN #shifts s on s.id = pt.ShiftID and s.StorageStructureSectorID = pt.StorageStructureSectorID
    GROUP BY 
        pt.ShiftID,
        ptdd.TMCID,
        ptdd.StatusID,
        ptdd.StatusFromID,
        ptd.ProductionTasksOperTypeID,
        ptdd.ProductionCardCustomizeID,
        pt.StorageStructureSectorID,
        ptdd.isMajorTMC,
        tmc.Name,
        ptot.name,
        ptsFrom.Name,
        ptsTo.Name,
        pcc.Number,
        sss.Name
        ,sss.IsCS
    ORDER BY Sort 

    SELECT 
          os.ShiftID
        , os.tmcid
        , os.ProductionCardCustomizeID
        , os.StorageStructureSectorID
        , sss.Name AS Sektor
        , pts.Name AS Status
        , case when sss.IsCS = 1  then 'ЦС. РМ операторів'  else sss.Name end SektorName 
        , case when sss.IsCS = 1  then 0 else sss.SortOrder end SortOrder 
        , os.StatusID
        , POstatki.amount AS POstatki
        , Prichod.amount AS Prichod
        , Zrobleno.amount AS Zrobleno
        , Moved.amount AS Moved
        , os.amount AS Ostatok
        , otgruzka.amount AS otgruzka
    INTO #Rep
    FROM 
        (SELECT o.* 
        FROM #ReportO o 
            JOIN #statusmajor sm on sm.StatusToID = o.StatusID  AND sm.StorageStructureSectorID = o.StorageStructureSectorID
        ) AS os
        LEFT JOIN manufacture.StorageStructureSectors sss on sss.ID = os.StorageStructureSectorID
        LEFT JOIN manufacture.ProductionTasksStatuses pts on pts.ID = os.StatusID
        LEFT JOIN 
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusfromid, sum(k.Amount) Amount 
                FROM #ReportKK k
                WHERE k.ProductionTasksOperTypeID = 4 AND k.statusfromid <> 3  -- отгрузка
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusfromid
                ) AS otgruzka on
                        otgruzka.statusfromid = os.statusid  
                    AND otgruzka.ShiftID = os.ShiftID
                    AND otgruzka.tmcid = os.tmcid 
                    AND otgruzka.ProductionCardCustomizeID = os.ProductionCardCustomizeID
                    AND otgruzka.StorageStructureSectorID = os.StorageStructureSectorID
        LEFT JOIN
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusfromid, sum(k.Amount) Amount 
                FROM #ReportKK k
                WHERE k.ProductionTasksOperTypeID = 2 -- производство 
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusfromid
                ) AS Zrobleno on
                        Zrobleno.statusid = os.statusid 
                    AND Zrobleno.ShiftID = os.ShiftID
                    AND Zrobleno.tmcid = os.tmcid 
                    AND Zrobleno.ProductionCardCustomizeID = os.ProductionCardCustomizeID
                    AND Zrobleno.StorageStructureSectorID = os.StorageStructureSectorID
        LEFT JOIN
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusfromid, sum(k.Amount) Amount 
                FROM #ReportKK k
                WHERE k.ProductionTasksOperTypeID = 7
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusfromid
                ) AS POstatki on
                        POstatki.statusid = os.statusid  
                    AND POstatki.ShiftID = os.ShiftID
                    AND POstatki.tmcid = os.tmcid 
                    AND POstatki.ProductionCardCustomizeID = os.ProductionCardCustomizeID
                    AND POstatki.StorageStructureSectorID = os.StorageStructureSectorID
        LEFT JOIN
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusfromid, sum(k.Amount) Amount
                FROM #ReportKK k
                WHERE k.ProductionTasksOperTypeID = 1 -- AND k.statusfromid is not null
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusfromid
                ) AS Prichod on
                        Prichod.statusid = os.statusid  
                    AND Prichod.ShiftID = os.ShiftID
                    AND Prichod.tmcid = os.tmcid 
                    AND Prichod.ProductionCardCustomizeID = os.ProductionCardCustomizeID
                    AND Prichod.StorageStructureSectorID = os.StorageStructureSectorID
        LEFT JOIN
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusfromid, sum(k.Amount) Amount 
                FROM #ReportKK k
                WHERE k.ProductionTasksOperTypeID = 3
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusfromid
                ) AS Moved on
                        Moved.statusid = os.statusid  
                    AND Moved.ShiftID = os.ShiftID
                    AND Moved.tmcid = os.tmcid 
                    AND Moved.ProductionCardCustomizeID = os.ProductionCardCustomizeID
                    AND Moved.StorageStructureSectorID = os.StorageStructureSectorID
    ORDER BY sss.SortOrder

    SELECT 
          r.ShiftID
        , r.tmcid
        , r.ProductionCardCustomizeID
        , r.Status
        , r.SektorName 
        , r.SortOrder 
        , r.StatusID
        , tmc.name
        , pcc.Number
        , case when s.old = 1 then  0 else isnull(Sum(r.POstatki), 0) end AS POstatki
        , case when s.old = 1 then  0 else isnull(Sum(r.Prichod), 0) end AS Prichod
        , case when s.old = 1 then  0 else isnull(Sum(r.Zrobleno), 0) end AS Zrobleno
        , case when s.old = 1 then  0 else isnull(Sum(r.Moved), 0) end AS Moved
        , isnull(Sum(r.Ostatok), 0) AS Ostatok
        , case when s.old = 1 then  0 else isnull(Sum(r.otgruzka), 0) end AS otgruzka
        , s.old
    INTO #RepOut
    FROM #Rep r
        LEFT JOIN TMC tmc on tmc.ID = r.TMCID
        LEFT JOIN ProductionCardCustomize pcc on pcc.id = r.ProductionCardCustomizeID
        LEFT JOIN #shifts s on s.id = r.ShiftID and s.StorageStructureSectorID = r.StorageStructureSectorID
    GROUP BY 
          r.ShiftID
        , r.tmcid
        , r.ProductionCardCustomizeID
        , r.Status
        , r.SektorName 
        , r.SortOrder 
        , r.StatusID
        , tmc.name
        , pcc.Number
        , s.old

    SELECT 
        * 
    FROM #RepOut
    WHERE 
           POstatki <> 0
        or Prichod <> 0
        or Zrobleno <> 0 
        or Moved <> 0
        or Ostatok <> 0
        or otgruzka <> 0
    ORDER BY SortOrder, StatusID, ProductionCardCustomizeID
END
GO