SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   22.09.2016$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   22.11.2016$*/
/*$Version:    1.00$   $Decription: $*/
CREATE FUNCTION [manufacture].[fn_GetSectorID_JobStageID_SSID] (@JobStageID int, @StorageStructureID int)
RETURNS int
AS
BEGIN
   RETURN ( SELECT ssd.StorageStructureSectorID
            FROM manufacture.StorageStructureSectorsDetails ssd
            INNER JOIN manufacture.StorageStructureSectors ss ON ss.ID = ssd.StorageStructureSectorID/*
            INNER JOIN shifts.ShiftsGroups sg ON sg.ID = ss.ShiftsGroupsID            
            INNER JOIN ProductionCardTypes ptypes ON ptypes.ManufactureID = sg.ManufactureStructureID
            INNER JOIN ProductionCardCustomize pc ON ptypes.ProductionCardPropertiesID = pc.TypeID            
            INNER JOIN manufacture.Jobs j ON pc.ID = j.ProductionCardCustomizeID            
            INNER JOIN manufacture.JobStages js ON j.ID = js.JobID AND js.ID = @JobStageID AND ISNULL(js.isDeleted, 0) = 0*/
            WHERE ssd.StorageStructureID = @StorageStructureID)
END
GO