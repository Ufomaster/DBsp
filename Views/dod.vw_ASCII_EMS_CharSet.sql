SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   17.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   17.11.2013$*/
/*$Version:    1.00$   $Description: Вьюшка с данными перечислимого типа ЕМС импорта ASCII.*/
create VIEW [dod].[vw_ASCII_EMS_CharSet]
AS
    SELECT 0 AS ID, 'ctWinDefined' AS Name, 0 AS IsHidden
    UNION ALL
    SELECT 1 AS ID, 'ctLatin1', 0
    UNION ALL
    SELECT 2 AS ID, 'ctArmscii8', 0
    UNION ALL
    SELECT 3 AS ID, 'ctAscii', 0
    UNION ALL
    SELECT 4 AS ID, 'ctCp850', 0
    UNION ALL
    SELECT 5 AS ID, 'ctCp852', 0
    UNION ALL
    SELECT 6 AS ID, 'ctCp866', 0
    UNION ALL
    SELECT 7 AS ID, 'ctCp1250', 0
    UNION ALL
    SELECT 8 AS ID, 'ctCp1251', 0
    UNION ALL
    SELECT 9 AS ID, 'ctCp1256', 0
    UNION ALL
    SELECT 10 AS ID, 'ctCp1257', 0
    UNION ALL
    SELECT 11 AS ID, 'ctDec8', 0
    UNION ALL
    SELECT 12 AS ID, 'ctGeostd8', 0
    UNION ALL
    SELECT 13 AS ID, 'ctGreek', 0
    UNION ALL
    SELECT 14 AS ID, 'ctHebrew', 0
    UNION ALL
    SELECT 15 AS ID, 'ctHp8', 0
    UNION ALL
    SELECT 16 AS ID, 'ctKeybcs2', 0
    UNION ALL
    SELECT 17 AS ID, 'ctKoi8r', 0
    UNION ALL
    SELECT 18 AS ID, 'ctKoi8u', 0
    UNION ALL
    SELECT 19 AS ID, 'ctLatin2', 0
    UNION ALL
    SELECT 20 AS ID, 'ctLatin5', 0
    UNION ALL
    SELECT 21 AS ID, 'ctLatin7', 0
    UNION ALL
    SELECT 22 AS ID, 'ctMacce', 0
    UNION ALL
    SELECT 23 AS ID, 'ctMacroman', 0
    UNION ALL
    SELECT 24 AS ID, 'ctSwe7', 0
    UNION ALL
    SELECT 25 AS ID, 'ctUtf8', 0
    UNION ALL
    SELECT 26 AS ID, 'ctUtf16', 0
    UNION ALL
    SELECT 27 AS ID, 'ctUtf32', 0
    UNION ALL
    SELECT 28 AS ID, 'ctLatin3', 0
    UNION ALL
    SELECT 29 AS ID, 'ctLatin4', 0
    UNION ALL
    SELECT 30 AS ID, 'ctLatin6', 0
    UNION ALL
    SELECT 31 AS ID, 'ctLatin8', 0
    UNION ALL
    SELECT 32 AS ID, 'ctIso8859_5', 0
    UNION ALL
    SELECT 33 AS ID, 'ctIso8859_6', 0
    UNION ALL
    SELECT 34 AS ID, 'ctCp1026', 0
    UNION ALL
    SELECT 35 AS ID, 'ctCp1254', 0
    UNION ALL
    SELECT 36 AS ID, 'ctCp1255', 0
    UNION ALL
    SELECT 37 AS ID, 'ctCp1258', 0
    UNION ALL
    SELECT 38 AS ID, 'ctCp437', 0
    UNION ALL
    SELECT 39 AS ID, 'ctCp500', 0
    UNION ALL
    SELECT 40 AS ID, 'ctCp737', 0
    UNION ALL
    SELECT 41 AS ID, 'ctCp855', 0
    UNION ALL
    SELECT 42 AS ID, 'ctCp856', 0
    UNION ALL
    SELECT 43 AS ID, 'ctCp857', 0
    UNION ALL
    SELECT 44 AS ID, 'ctCp860', 0
    UNION ALL
    SELECT 45 AS ID, 'ctCp862', 0
    UNION ALL
    SELECT 46 AS ID, 'ctCp863', 0
    UNION ALL
    SELECT 47 AS ID, 'ctCp864', 0
    UNION ALL
    SELECT 48 AS ID, 'ctCp865', 0
    UNION ALL
    SELECT 49 AS ID, 'ctCp869', 0
    UNION ALL
    SELECT 50 AS ID, 'ctCp874', 0
    UNION ALL
    SELECT 51 AS ID, 'ctCp875', 0
    UNION ALL
    SELECT 52 AS ID, 'ctIceland', 0
    UNION ALL
    SELECT 53 AS ID, 'ctBig5', 0
    UNION ALL
    SELECT 54 AS ID, 'ctKSC5601', 0
    UNION ALL
    SELECT 55 AS ID, 'ctEUC', 0
    UNION ALL
    SELECT 56 AS ID, 'ctGB2312', 0
    UNION ALL
    SELECT 57 AS ID, 'ctSJIS_0208', 0
    UNION ALL
    SELECT 58 AS ID, 'ctLatin9', 0
    UNION ALL
    SELECT 59 AS ID, 'ctLatin13', 0
    UNION ALL
    SELECT 60 AS ID, 'ctCp1252', 0
    UNION ALL
    SELECT 61 AS ID, 'ctCp1253', 0
    UNION ALL
    SELECT 62 AS ID, 'ctCp775', 0
    UNION ALL
    SELECT 63 AS ID, 'ctCp858', 0
GO