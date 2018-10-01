SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   02.06.2017$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   02.06.2017$*/
/*$Version:    1.00$   $Decription: $*/
create FUNCTION [manufacture].[fn_GetSectorID_SSID] (@StorageStructureID int)
RETURNS int
AS
BEGIN
   RETURN ( SELECT ssd.StorageStructureSectorID
            FROM manufacture.StorageStructureSectorsDetails ssd
            INNER JOIN manufacture.StorageStructureSectors ss ON ss.ID = ssd.StorageStructureSectorID
            WHERE ssd.StorageStructureID = @StorageStructureID)
END
GO