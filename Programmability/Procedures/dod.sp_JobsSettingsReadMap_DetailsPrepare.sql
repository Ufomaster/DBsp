SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   07.09.2018$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   07.09.2018$*/
/*$Version:    1.00$   $Decription: Готовим данные на изменение$*/
create PROCEDURE [dod].[sp_JobsSettingsReadMap_DetailsPrepare]
    @JobsSettingsID Int
AS
BEGIN
    INSERT INTO #JobsSettingsReadMap(_ID, Sector, B0, B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, B11, B12, B13, B14, B15)
    SELECT ID, Sector, B0, B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, B11, B12, B13, B14, B15
    FROM dod.JobsSettingsReadMap
    WHERE JobsSettingsID = @JobsSettingsID
END
GO