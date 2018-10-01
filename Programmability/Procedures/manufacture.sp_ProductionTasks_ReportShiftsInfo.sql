SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleksii Poliatykin$    $Create date:   26.10.2017$*/
/*$Modify:     Oleksii Poliatykin$    $Modify date:   03.11.2017$*/
/*$Version:    1.00$   $Decription: Выборка для отчета по производству за смены - ИНФО ДЛЯ ШАПКИ$*/

CREATE PROCEDURE [manufacture].[sp_ProductionTasks_ReportShiftsInfo]
@ShiftDate DATETIME,
@ManufactureStructureID int, 
@ShiftsTypesNamesID int

AS
BEGIN
   DECLARE @s varchar(4000), 
            @ShiftsTypesNames varchar(50) 

    IF object_id('tempdb..#Shifts') IS NOT NULL DROP TABLE #Shifts

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

    SELECT @ShiftsTypesNames = name FROM shifts.shiftstypesnames WHERE id = @ShiftsTypesNamesID

    SELECT 
          @s= isnull(@s+ '; ','') + cast(s.ID as varchar(255)) +' - '+ isnull(st.Name,'') +' (' +isnull(sss.name,'') + ') ' + case when ss.old=1 then ' (залишки)' else '' end        
   FROM #shifts ss
   join  shifts.Shifts s on s.id = ss.id
             JOIN shifts.ShiftsTypes st on st.ID = s.ShiftTypeID 
             JOIN  manufacture.ProductionTasks pt on pt.ShiftID = s.id
             JOIN manufacture.StorageStructureSectors sss on sss.id = pt.StorageStructureSectorID and sss.id = ss.StorageStructureSectorID
             JOIN shifts.ShiftsGroups sg on sg.ID = sss.ShiftsGroupsID
             JOIN manufacture.ManufactureStructure ms on ms.id = sg.ManufactureStructureID
              
    SELECT @s as ShiftInfo , LOWER(ms.Name) ShiftName, @ShiftDate as ShiftData, @ShiftsTypesNames as ShiftsTypesName 
    FROM manufacture.ManufactureStructure ms 
    WHERE ms.ID = @ManufactureStructureID
END
GO