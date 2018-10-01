SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleksii Poliatykin$    $Create date:   25.10.2017$*/
/*$Modify:     Oleksii Poliatykin$    $Modify date:   26.12.2017$*/
/*$Version:    1.00$   $Decription: Выборка для отчета по производству за смены - МАТЕРИАЛЫ$*/

CREATE PROCEDURE [manufacture].[sp_ProductionTasks_ReportShiftsMat]
@ShiftDate DATETIME,
@ManufactureStructureID int, 
@ShiftsTypesNamesID int
AS
BEGIN
-- для тестовоно запуска в менеджере 
-- закоментировать в процедуре    
/*
    DECLARE 
    @ShiftDate DATETIME,
    @ManufactureStructureID int, 
    @ShiftsTypesNamesID int
--SELECT  @ShiftDate = '2017-12-10', @ManufactureStructureID = 1,  @ShiftsTypesNamesID = 2
--SELECT  @ShiftDate = '2017-12-11', @ManufactureStructureID = 1,  @ShiftsTypesNamesID = 1
--SELECT  @ShiftDate = '2017-12-18', @ManufactureStructureID = 2,  @ShiftsTypesNamesID = 1
 SELECT  @ShiftDate = '2017-11-28', @ManufactureStructureID = 2,  @ShiftsTypesNamesID = 1
--SELECT  @ShiftDate = '2017-11-30', @ManufactureStructureID = 2,  @ShiftsTypesNamesID = 1
*/
-- end закоментировать в процедуре
    IF object_id('tempdb..#shifts') IS NOT NULL DROP TABLE #shifts
    IF object_id('tempdb..#StatusMajor') IS NOT NULL DROP TABLE #StatusMajor
    IF object_id('tempdb..#ReportO') IS NOT NULL DROP TABLE #ReportO
    IF object_id('tempdb..#ReportKK') IS NOT NULL DROP TABLE #ReportKK
    IF object_id('tempdb..#Rep') IS NOT NULL DROP TABLE #Rep
    IF object_id('tempdb..#RepOut') IS NOT NULL DROP TABLE #RepOut
    IF object_id('tempdb..#RepOutCS') IS NOT NULL DROP TABLE #RepOutCS
    IF object_id('tempdb..#RepOutput') IS NOT NULL DROP TABLE #RepOutput

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
        (
            SELECT ShiftID,StorageStructureSectorID, ProductionTasksID, TMCID, StatusID, ProductionCardCustomizeID, isMajorTMC, CAST(SUM(MoveTypeID * Amount) AS decimal(38, 10)) AS Amount, ConfirmStatus
            FROM
                (/*Data FROM documents*/
                SELECT 
                    pt.ShiftID, pt.StorageStructureSectorID, ptd.ProductionTasksID AS ProductionTasksID, ptdd.TMCID, ptdd.StatusID, ptdd.ProductionCardCustomizeID, CAST(ptdd.MoveTypeID AS float) AS MoveTypeID,
                    ptdd.Amount, ptdd.isMajorTMC, IsNull(ptd.ConfirmStatus,1) AS ConfirmStatus
                FROM manufacture.ProductionTasksDocDetails ptdd 
                    LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
                    LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ptd.ProductionTasksID        
                WHERE (ptd.ConfirmStatus = 1 OR IsNull(ptd.ConfirmStatus,0) = 0)
                UNION ALL      
                /*ADD corrections to production, nonconformance AND write-offs*/
                SELECT
                    pt.ShiftID, pt.StorageStructureSectorID, pt.id, ptdd.TMCID, ptdd.StatusFromID AS StatusID, ptdd.ProductionCardCustomizeFromID AS ProductionCardCustomizeID, CAST(-1 AS float) AS MoveTypeID,                        
                    ptdd.Amount, ptdd.isMajorTMC, 1
                FROM manufacture.ProductionTasksDocDetails ptdd
                    LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
                    LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ptd.ProductionTasksID 
                WHERE
                    (ptd.ProductionTasksOperTypeID IN (4,5,6,8,10))
                    /*ADD additional minus for previous status to MajorTMC*/
                    OR (ptdd.isMajorTMC = 1 AND ptd.ProductionTasksOperTypeID IN (2) AND ptdd.StatusID = 2)
                    OR (ptdd.isMajorTMC = 0 AND ptd.ProductionTasksOperTypeID IN (2) AND ptdd.StatusFromID is not null)
                ) a 
            GROUP BY ShiftID, StorageStructureSectorID, ProductionTasksID, TMCID, StatusID, ProductionCardCustomizeID, isMajorTMC, ConfirmStatus
        ) t
        JOIN #shifts s on s.id = t.ShiftID and s.StorageStructureSectorID = t.StorageStructureSectorID
        LEFT JOIN ProductionCardCustomize pcc  on pcc.ID = t.ProductionCardCustomizeID
        LEFT JOIN TMC tmc on tmc.ID = t.tmcID
        LEFT JOIN manufacture.ProductionTasksStatuses pts on pts.ID = t.StatusID
        LEFT JOIN Units u ON u.ID = tmc.UnitID
        LEFT JOIN manufacture.ProductionTasks pt on pt.ID = t.ProductionTasksID 
        LEFT JOIN manufacture.StorageStructureSectors sss on sss.ID = pt.StorageStructureSectorID
 
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
        sss.Name AS Sector,
        sss.IsCS
    INTO #ReportKK
    FROM manufacture.ProductionTasksDocDetails ptdd
        LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID
        LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ptd.ProductionTasksID 
        JOIN #shifts s on s.id = pt.ShiftID and s.StorageStructureSectorID = pt.StorageStructureSectorID
        LEFT JOIN manufacture.StorageStructureSectors sss on sss.ID = pt.StorageStructureSectorID
        LEFT JOIN manufacture.ProductionTasksStatuses ptsTo on ptsTo.ID = ptdd.StatusID
        LEFT JOIN manufacture.ProductionTasksStatuses ptsFrom on ptsFrom.ID = ptdd.StatusFromID
        LEFT JOIN manufacture.ProductionTasksOperationTypes ptot on ptot.id = ptd.ProductionTasksOperTypeID
        LEFT JOIN TMC tmc on tmc.ID = ptdd.TMCID
        LEFT JOIN ProductionCardCustomize pcc on pcc.id = ptdd.ProductionCardCustomizeID
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
        sss.Name,
        sss.IsCS
    ORDER BY Sort 
 
    SELECT 
          os.ShiftID, os.tmcid, os.ProductionCardCustomizeID, os.StorageStructureSectorID, sss.Name AS Sektor
        , case when sss.IsCS = 1  then 'ЦС. РМ операторів'  else sss.Name end SektorName 
        , case when sss.IsCS = 1  then 0 else sss.SortOrder end SortOrder 
        , POstatki.amount AS POstatki
        , POstatkiBrak.amount AS POstatkiBrak
        , Prichod.amount AS Prichod
        , PSpisano.amount AS PSpisano
        , PSpisano2.amount AS PSpisano2
        , isnull(Brak.amount,0) AS Brak
        , OtgruzkaBrak.amount AS OtgruzkaBrak
        , Sklad.amount AS Sklad
        , Util.amount AS Util
        , Ostatok.amount AS Ostatok
        
    INTO #Rep
    FROM 
        (
        SELECT  DISTINCT
            o.ShiftID, 
            o.StorageStructureSectorID, 
            o.Number,
            o.ProductionTasksID, 
            o.TMCID, 
            o.ProductionCardCustomizeID, 
            o.isMajorTMC,
            sum(o.amount) amount
        FROM #ReportO o 
        WHERE 
            o.ismajortmc = 0
        GROUP BY  
            o.ShiftID, 
            o.StorageStructureSectorID, 
            o.Number,
            o.ProductionTasksID, 
            o.TMCID, 
            o.ProductionCardCustomizeID, 
            o.isMajorTMC
        ) AS os
        LEFT JOIN manufacture.StorageStructureSectors sss on sss.ID = os.StorageStructureSectorID
        LEFT JOIN 
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid, sum(k.Amount) Amount 
                FROM #ReportKK k
                WHERE k.ProductionTasksOperTypeID = 2  AND  k.statusid = 2
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid
                ) AS PSpisano on 
                    PSpisano.ShiftID = os.ShiftID
                AND PSpisano.tmcid = os.tmcid 
                AND ( (PSpisano.ProductionCardCustomizeID = os.ProductionCardCustomizeID AND PSpisano.ProductionCardCustomizeID is not null) OR ( os.ProductionCardCustomizeID is null AND PSpisano.ProductionCardCustomizeID is  null)  )
                AND PSpisano.StorageStructureSectorID = os.StorageStructureSectorID
        LEFT JOIN
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid, sum(k.Amount) Amount 
                FROM #ReportKK k
                WHERE k.ProductionTasksOperTypeID = 5  AND  k.statusid = 2
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid
                ) AS PSpisano2 on 
                    PSpisano2.ShiftID = os.ShiftID
                AND PSpisano2.tmcid = os.tmcid 
                AND ( (PSpisano2.ProductionCardCustomizeID = os.ProductionCardCustomizeID AND PSpisano2.ProductionCardCustomizeID is not null) OR ( os.ProductionCardCustomizeID is null AND PSpisano2.ProductionCardCustomizeID is  null)  )
                AND PSpisano2.StorageStructureSectorID = os.StorageStructureSectorID
        LEFT JOIN
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid, sum(k.Amount) Amount 
                FROM #ReportKK k
                WHERE k.ProductionTasksOperTypeID = 7 AND k.statusid = 1
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid
                ) AS POstatki on 
                    POstatki.ShiftID = os.ShiftID
                AND POstatki.tmcid = os.tmcid 
                AND ( (POstatki.ProductionCardCustomizeID = os.ProductionCardCustomizeID AND POstatki.ProductionCardCustomizeID is not null) OR ( os.ProductionCardCustomizeID is null AND POstatki.ProductionCardCustomizeID is  null)  )
                AND POstatki.StorageStructureSectorID = os.StorageStructureSectorID
        LEFT JOIN
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid, sum(k.Amount) Amount 
                FROM #ReportKK k
                WHERE k.ProductionTasksOperTypeID = 7 AND k.statusid = 3
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid
                ) AS POstatkiBrak on 
                    POstatkiBrak.ShiftID = os.ShiftID
                AND POstatkiBrak.tmcid = os.tmcid 
                AND ( (POstatkiBrak.ProductionCardCustomizeID = os.ProductionCardCustomizeID AND POstatkiBrak.ProductionCardCustomizeID is not null) OR ( os.ProductionCardCustomizeID is null AND POstatkiBrak.ProductionCardCustomizeID is  null)  )
                AND POstatkiBrak.StorageStructureSectorID = os.StorageStructureSectorID
        LEFT JOIN
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid, sum(k.Amount) Amount
                FROM #ReportKK k
                WHERE k.ProductionTasksOperTypeID = 6
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid
                ) AS Brak on 
                    Brak.ShiftID = os.ShiftID
                AND Brak.tmcid = os.tmcid 
                AND ( (Brak.ProductionCardCustomizeID = os.ProductionCardCustomizeID AND Brak.ProductionCardCustomizeID is not null) OR ( os.ProductionCardCustomizeID is null AND Brak.ProductionCardCustomizeID is  null)  )
                AND Brak.StorageStructureSectorID = os.StorageStructureSectorID
        LEFT JOIN
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid, sum(k.Amount) Amount
                FROM #ReportKK k
                WHERE k.ProductionTasksOperTypeID = 1  AND k.statusid = 1
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid
                ) AS Prichod on 
                    Prichod.ShiftID = os.ShiftID
                AND Prichod.tmcid = os.tmcid 
                AND ( (Prichod.ProductionCardCustomizeID = os.ProductionCardCustomizeID AND Prichod.ProductionCardCustomizeID is not null) OR ( os.ProductionCardCustomizeID is null AND Prichod.ProductionCardCustomizeID is  null)  )
                AND Prichod.StorageStructureSectorID = os.StorageStructureSectorID
        LEFT JOIN
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid, sum(k.Amount) Amount 
                FROM #ReportKK k
                WHERE (k.ProductionTasksOperTypeID = 4 AND k.statusid = 5 and k.statusFROMid = 3)  -- отгрузка брака
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid
                ) AS OtgruzkaBrak on 
                    OtgruzkaBrak.ShiftID = os.ShiftID
                AND OtgruzkaBrak.tmcid = os.tmcid 
                AND ( (OtgruzkaBrak.ProductionCardCustomizeID = os.ProductionCardCustomizeID AND OtgruzkaBrak.ProductionCardCustomizeID is not null) OR ( os.ProductionCardCustomizeID is null AND OtgruzkaBrak.ProductionCardCustomizeID is  null)  )
                AND OtgruzkaBrak.StorageStructureSectorID = os.StorageStructureSectorID
        LEFT JOIN
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid, sum(k.Amount) Amount
                FROM #ReportKK k
                WHERE k.ProductionTasksOperTypeID = 4 AND k.statusid = 5 and k.statusFROMid = 1
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid
                ) AS Sklad on 
                    Sklad.ShiftID = os.ShiftID
                AND Sklad.tmcid = os.tmcid 
                AND ( (Sklad.ProductionCardCustomizeID = os.ProductionCardCustomizeID AND Sklad.ProductionCardCustomizeID is not null) OR ( os.ProductionCardCustomizeID is null AND Sklad.ProductionCardCustomizeID is  null)  )
                AND Sklad.StorageStructureSectorID = os.StorageStructureSectorID
        LEFT JOIN
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid, sum(k.Amount) Amount
                FROM #ReportKK k
                WHERE k.ProductionTasksOperTypeID = 10
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, k.statusFROMid
                ) AS Util on 
                    Util.ShiftID = os.ShiftID
                AND Util.tmcid = os.tmcid 
                AND ( (Util.ProductionCardCustomizeID = os.ProductionCardCustomizeID AND Util.ProductionCardCustomizeID is not null) OR ( os.ProductionCardCustomizeID is null AND Util.ProductionCardCustomizeID is  null)  )
                AND Util.StorageStructureSectorID = os.StorageStructureSectorID
        LEFT JOIN
                (SELECT k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid, sum(k.Amount) Amount 
                FROM #ReportO k
                WHERE k.statusid = 1
                GROUP BY k.ShiftID, k.tmcid, k.ProductionCardCustomizeID, k.StorageStructureSectorID, k.statusid
                ) AS Ostatok on
                     Ostatok.statusid = 1
                AND  Ostatok.ShiftID = os.ShiftID
                AND Ostatok.tmcid = os.tmcid 
                AND ( (Ostatok.ProductionCardCustomizeID = os.ProductionCardCustomizeID AND Ostatok.ProductionCardCustomizeID is not null) OR ( os.ProductionCardCustomizeID is null AND Ostatok.ProductionCardCustomizeID is  null)  )
                AND Ostatok.StorageStructureSectorID = os.StorageStructureSectorID
    ORDER BY sss.SortOrder

    SELECT 
          r.ShiftID
        , r.tmcid
        , r.ProductionCardCustomizeID
        , r.SektorName 
        , r.SortOrder 
        , tmc.name
        , pcc.Number
        , IsNull(u.[Name],'шт.') AS UnitName
        , Sum(r.POstatki) AS POstatki
        , Sum(r.POstatkiBrak) AS POstatkiBrak
        , Sum(r.Prichod) AS Prichod
        , sum(r.PSpisano) AS Spisano
        , sum(r.PSpisano2) AS Spisano2
        , Sum(r.Brak) AS Brak
        , Sum(r.OtgruzkaBrak) AS OtgruzkaBrak
        , Sum(r.Sklad) AS Sklad
        , Sum(r.Util) AS Util
        , Sum(r.Ostatok) AS Ostatok
    INTO #RepOutCS
    FROM #Rep r
        LEFT JOIN TMC tmc on tmc.ID = r.TMCID
        LEFT JOIN ProductionCardCustomize pcc on pcc.id = r.ProductionCardCustomizeID
        LEFT JOIN Units u ON u.ID = tmc.UnitID
    GROUP BY 
          r.ShiftID
        , r.tmcid
        , r.ProductionCardCustomizeID
        , r.SektorName 
        , r.SortOrder 
        , tmc.name
        , pcc.Number
        , IsNull(u.[Name],'шт.')
    ORDER BY 
          r.SortOrder 
        , tmc.name
        , r.tmcid
        , r.ProductionCardCustomizeID

    SELECT DISTINCT
          cs.ShiftID
        , cs.tmcid
        , cs.ProductionCardCustomizeID
        , cs.SektorName 
        , cs.SortOrder 
        , cs.name
        , cs.Number
        , cs.UnitName
        , case when s.old = 1 then 0 else isnull(cs.POstatki,0) + isnull(rm.POstatki,0) + isnull(cs.POstatkiBrak,0) + isnull(rm.POstatkiBrak,0) end AS POstatkiAll
        , case when s.old = 1 then 0 else isnull(cs.POstatki,0) + isnull(rm.POstatki,0) end AS POstatki
        , case when s.old = 1 then 0 else isnull(cs.POstatkiBrak,0) + isnull(rm.POstatkiBrak,0) end AS POstatkiBrak
        , case when s.old = 1 then 0 else isnull(cs.Prichod,0) end AS Prichod
        , case when s.old = 1 then 0 else isnull(cs.Spisano,0) + isnull(rm.Spisano,0) end AS Spisano1
        , case when s.old = 1 then 0 else isnull(cs.Spisano2,0) + isnull(rm.Spisano2,0) end AS Spisano2
        , case when s.old = 1 then 0 else
              isnull(cs.Spisano,0) + isnull(rm.Spisano,0) + isnull(cs.Spisano2,0) + isnull(rm.Spisano2,0) + 
                  case when 
                      (isnull(cs.Brak,0) + isnull(rm.Brak,0) -(isnull(cs.OtgruzkaBrak,0) + isnull(rm.OtgruzkaBrak,0)))<0 
                      then 0 else  isnull(cs.Brak,0) + isnull(rm.Brak,0) -(isnull(cs.OtgruzkaBrak,0) + isnull(rm.OtgruzkaBrak,0))
                  end          
          end AS SpisanoAll
        , case when s.old = 1 then 0 else isnull(cs.Spisano,0) + isnull(rm.Spisano,0) + isnull(cs.Spisano2,0) + isnull(rm.Spisano2,0) end AS Spisano
        , case when s.old = 1 then 0 else isnull(cs.Brak,0) + isnull(rm.Brak,0) end AS Brak        
        , case when s.old = 1 then 0 else
              case when 
                  (isnull(cs.Brak,0) + isnull(rm.Brak,0) -(isnull(cs.OtgruzkaBrak,0) + isnull(rm.OtgruzkaBrak,0)))<0 
              then 0 else  isnull(cs.Brak,0) + isnull(rm.Brak,0) -(isnull(cs.OtgruzkaBrak,0) + isnull(rm.OtgruzkaBrak,0))    
         end          
         end AS SpisanoBrak
        , case when s.old = 1 then 0 else isnull(cs.OtgruzkaBrak,0) + isnull(rm.OtgruzkaBrak,0) end AS OtgruzkaBrak
        , case when s.old = 1 then 0 else isnull(cs.Sklad,0) + isnull(rm.Sklad,0) + isnull(cs.Util,0) + isnull(rm.Util,0) end AS SdanoAll
        , case when s.old = 1 then 0 else isnull(cs.Sklad,0) + isnull(rm.Sklad,0) end AS SdanoSklad
        , case when s.old = 1 then 0 else isnull(cs.Util,0) + isnull(rm.Util,0) end AS SdanoBrak
        , isnull(cs.Ostatok,0) + isnull(rm.Ostatok,0) + isnull(cs.POstatkiBrak,0) + isnull(rm.POstatkiBrak,0) + isnull(cs.Brak,0) + isnull(rm.Brak,0) - (isnull(cs.OtgruzkaBrak,0) + isnull(rm.OtgruzkaBrak,0)) - (isnull(cs.Util,0) + isnull(rm.Util,0)) AS OstatokAll
        , isnull(cs.Ostatok,0) + isnull(rm.Ostatok,0) AS Ostatok
        , isnull(cs.POstatkiBrak,0) + isnull(rm.POstatkiBrak,0) + isnull(cs.Brak,0) + isnull(rm.Brak,0) - (isnull(cs.OtgruzkaBrak,0) + isnull(rm.OtgruzkaBrak,0)) - (isnull(cs.Util,0) + isnull(rm.Util,0))  AS OstatokBrak
        
    INTO #RepOutput
    FROM #RepOutCS cs 
        LEFT JOIN (SELECT * FROM  #RepOutCS WHERE SektorName = 'ЦС. РМ операторів') rm on  
                 cs.ShiftID = rm.ShiftID
            AND  cs.tmcid = rm.tmcid
            AND  cs.ProductionCardCustomizeID = rm.ProductionCardCustomizeID
        LEFT JOIN #shifts s on s.id = cs.ShiftID  

    SELECT DISTINCT
          r.*
        , case when k.tmcid is null then 0 else 1 end  AS k
        , case when n.tmcid is null then 0 else 1 end  AS n
    FROM #RepOutput r
        LEFT JOIN #RepOutput k on 
                k.ShiftID = r.ShiftID 
            AND k.tmcid = r.tmcid
            AND k.SektorName = r.SektorName
            AND r.ProductionCardCustomizeID is not null 
            AND k.ProductionCardCustomizeID is null  
        LEFT JOIN ( Select DISTINCT ShiftID, tmcid, SektorName FROM #RepOutput  WHERE ProductionCardCustomizeID is not null  ) n  on 
                n.ShiftID = r.ShiftID 
            AND n.tmcid = r.tmcid
            AND n.SektorName = r.SektorName
            AND r.ProductionCardCustomizeID is null  
    WHERE 
        r.SektorName <> 'ЦС. РМ операторів'
        AND 
            (
               r.POstatkiAll <> 0 
            OR r.POstatki <> 0
            OR r.POstatkiBrak <> 0
            OR r.Prichod <> 0
            OR r.SpisanoAll <> 0
            OR r.Spisano <> 0
            OR r.SpisanoBrak <> 0
            OR r.SdanoAll <> 0
            OR r.SdanoSklad <> 0 
            OR r.SdanoBrak <> 0 
            OR r.OstatokAll <> 0 
            OR r.Ostatok <> 0 
            OR r.OstatokBrak <> 0
            )
          
    ORDER BY 
          r.SortOrder 
        , r.name
        , r.tmcid
        , r.ProductionCardCustomizeID
        
END
GO