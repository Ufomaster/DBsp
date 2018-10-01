SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$	$Create date:   21.04.2017$
--$Modify:     Yuriy Oleynik$	$Modify date:   09.06.2017$
--$Version:    1.00$   $Decription: выбор Списка ТМЦ согласно привязке к участкам$
CREATE FUNCTION [dbo].[fn_TMCLinkedToSectors_Select] (@SectorID tinyInt, @TMCID int, @SSID int = NULL)
RETURNS @T TABLE(ID Int)
AS
BEGIN
    IF @SSID IS NOT NULL
        SELECT @SectorID = sd.StorageStructureSectorID
        FROM manufacture.StorageStructureSectorsDetails sd
        INNER JOIN manufacture.StorageStructureSectors ss ON ss.ID = sd.StorageStructureSectorID
        WHERE sd.StorageStructureID = @SSID
        
    IF EXISTS(SELECT TMCID FROM TMCSectors WHERE TmcID = @TMCID) --приоритет у настройки ТМЦ. если по ТМЦ настроено что-то не по @SectorID то группу уже не берем
        INSERT INTO @T(ID)
        SELECT TMCID
        FROM TMCSectors
        WHERE SectorID = @SectorID AND TmcID = @TMCID -- а тут уже если ничего не настроено на этот участок, то список вернет несоответствие и все гуд.
    ELSE 
        INSERT INTO @T(ID)
        SELECT ID
        FROM Tmc t
        WHERE t.ObjectTypeID IN (SELECT o.ObjectTypeID 
                                 FROM ObjectTypesSectors o
                                 INNER JOIN TMC t ON t.ObjectTypeID = o.ObjectTypeID AND t.ID = @TMCID
                                 WHERE SectorID = @SectorID)
    RETURN        
END
GO