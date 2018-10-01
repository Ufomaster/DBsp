SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   22.09.2016$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   30.11.2016$*/
/*$Version:    1.00$   $Decription: $*/
create FUNCTION [manufacture].[fn_GetActiveShiftID] (@StorageStructureID int)
RETURNS int
AS
BEGIN
   DECLARE @ShiftID int
   
    SELECT @ShiftID = s.ID
    FROM shifts.Shifts s
    INNER JOIN shifts.ShiftsTypes st ON st.ID = s.ShiftTypeID
    INNER JOIN manufacture.StorageStructureSectors se ON se.ShiftsGroupsID = st.ShiftsGroupsID
    INNER JOIN manufacture.StorageStructureSectorsDetails sm ON sm.StorageStructureID = @StorageStructureID AND se.ID = sm.StorageStructureSectorID
    WHERE s.FactStartDate IS NOT NULL AND s.FactEndDate IS NULL AND ISNULL(s.IsDeleted, 0) = 0
    ORDER BY s.FactStartDate DESC


/*    SELECT @ShiftID = s.ID --ищем смену по настройкам участка.
            FROM shifts.Shifts s 
            INNER JOIN shifts.ShiftsTypes st ON st.ID = s.ShiftTypeID
            INNER JOIN shifts.ShiftsGroups sg ON sg.ID = st.ShiftsGroupsID
            INNER JOIN manufacture.StorageStructureSectors sec ON sec.ShiftsGroupsID = sg.ID AND sec.ID = @SectorID
            INNER JOIN dbo.ProductionCardTypes ptypes ON ptypes.ManufactureID = sg.ManufactureStructureID
            INNER JOIN dbo.ProductionCardCustomize pc ON ptypes.ProductionCardPropertiesID = pc.TypeID            
            INNER JOIN manufacture.Jobs j ON pc.ID = j.ProductionCardCustomizeID            
            INNER JOIN manufacture.JobStages js ON j.ID = js.JobID AND js.ID = @JobStageID AND ISNULL(js.isDeleted, 0) = 0
            WHERE ISNULL(s.IsDeleted, 0) = 0 AND s.FactEndDate IS NULL AND s.FactStartDate IS NOT NULL
    IF @ShiftID IS NULL --Если смена не найдена из-за несовпадения ЦЕХА в типе зл и Цеха смены - ищем по типу смены
        SELECT @ShiftID = s.ID
                FROM shifts.Shifts s 
                INNER JOIN shifts.ShiftsTypes st ON st.ID = s.ShiftTypeID
                INNER JOIN dbo.ProductionCardTypes ptypes ON ptypes.ManufactureID = st.ManufactureStructureID  --sg.ManufactureStructureID
                INNER JOIN dbo.ProductionCardCustomize pc ON ptypes.ProductionCardPropertiesID = pc.TypeID            
                INNER JOIN manufacture.Jobs j ON pc.ID = j.ProductionCardCustomizeID            
                INNER JOIN manufacture.JobStages js ON j.ID = js.JobID AND js.ID = @JobStageID AND ISNULL(js.isDeleted, 0) = 0
                WHERE ISNULL(s.IsDeleted, 0) = 0 AND s.FactEndDate IS NULL AND s.FactStartDate IS NOT NULL  */  
   RETURN (@ShiftID)
END
GO