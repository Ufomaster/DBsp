SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   07.09.2018$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   07.09.2018$*/
/*$Version:    1.00$   $Description: Возвращает текст создания темповой таблицы $*/
create PROCEDURE [dod].[sp_JobsSettingsReadMap_GetCreateTableText]
AS
BEGIN
    SELECT 'IF OBJECT_ID(''tempdb..#JobsSettingsReadMap'') IS NOT NULL ' +
         '    TRUNCATE TABLE #JobsSettingsReadMap ELSE ' +
         '    CREATE TABLE #JobsSettingsReadMap(ID int IDENTITY(1, 1) NOT NULL, _ID int, ' +
         '    Sector tinyint, B0 bit, B1 bit, B2 bit, B3 bit, B4 bit, B5 bit, B6 bit, B7 bit, '+
         '    B8 bit, B9 bit, B10 bit, B11 bit, B12 bit, B13 bit, B14 bit, B15 bit)'
END
GO