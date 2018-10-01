SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   15.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   16.11.2013$*/
/*$Version:    1.00$   $Description: Вьюшка с данными соотношения перечислимого 
   типа ЕМС импорта ДБФ и значениями чарсета ДБФ файла.
Поле DBFCode это значение 29 байта заголовка файла дбф.
Эта вьюшка строит таблицу соответсвий ЕМС констант для кодировки дбф файла значениям 29-го байта заголовка.
Поле ID - значение константы EMS. Значение -1, "Авто": для обработки в ручном режиме, для поиска по этой вьюшке.
В интерфейс отбираются записи для явного указания только со значением поля IsHidden = 0
Соответсвтие заданных значений 29 байта взято с http://www.autopark.ru/ASBProgrammerGuide/DBFSTRUC.HTM#Table_9
*/
create VIEW [dod].[vw_DBF_EMS_CharSet]
AS
SELECT -1 AS ID, 'Auto' AS [Name], '|0|' AS DBFCode, 0 AS IsHidden
UNION ALL
SELECT 0, 'dcsNone',        '|0|', 0
UNION ALL
SELECT 1, 'dcsLatin1',      '|0|', 1
UNION ALL
SELECT 2, 'dcsArmscii8',    '|0|', 1
UNION ALL
SELECT 3, 'dcsAscii',       '|0|', 1
UNION ALL
SELECT 4, 'dcsCp850',       '|2|', 0
UNION ALL
SELECT 5, 'dcsCp852',       '|100|', 0
UNION ALL
SELECT 6, 'dcsCp866',       '|101|38|', 0
UNION ALL
SELECT 7, 'dcsCp1250',      '|200|', 0
UNION ALL
SELECT 8, 'dcsCp1251',      '|201|', 0
UNION ALL
SELECT 9, 'dcsCp1256',      '|0|', 1
UNION ALL
SELECT 10, 'dcsCp1257',     '|204|', 0
UNION ALL
SELECT 11, 'dcsDec8',       '|0|', 1
UNION ALL
SELECT 12, 'dcsGeostd8',    '|0|', 1
UNION ALL
SELECT 13, 'dcsGreek',      '|0|', 1
UNION ALL
SELECT 14, 'dcsHebrew',     '|0|', 1
UNION ALL
SELECT 15, 'dcsHp8',        '|0|', 1
UNION ALL
SELECT 16, 'dcsKeybcs2',    '|0|', 1
UNION ALL
SELECT 17, 'dcsKoi8r',      '|0|', 1
UNION ALL
SELECT 18, 'dcsKoi8u',      '|0|', 1
UNION ALL
SELECT 19, 'dcsLatin2',     '|0|', 1
UNION ALL
SELECT 20, 'dcsLatin5',     '|0|', 1
UNION ALL
SELECT 21, 'dcsLatin7',     '|0|', 1
UNION ALL
SELECT 22, 'dcsMacce',      '|0|', 1
UNION ALL
SELECT 23, 'dcsMacroman',   '|0|', 1
UNION ALL
SELECT 24, 'dcsSwe7',       '|0|', 1
UNION ALL
SELECT 25, 'dcsUtf8',       '|0|', 1
UNION ALL
SELECT 26, 'dcsLatin3',     '|0|', 1
UNION ALL
SELECT 27, 'dcsLatin4',     '|0|', 1
UNION ALL
SELECT 28, 'dcsLatin6',     '|0|', 1
UNION ALL
SELECT 29, 'dcsLatin8',     '|0|', 1
UNION ALL
SELECT 30, 'dcsIso8859_5',  '|0|', 1
UNION ALL
SELECT 31, 'dcsIso8859_6',  '|0|', 1
UNION ALL
SELECT 32, 'dcsCp1026',     '|0|', 1
UNION ALL
SELECT 33, 'dcsCp1254',     '|202|', 0
UNION ALL
SELECT 34, 'dcsCp1255',     '|0|', 1
UNION ALL
SELECT 35, 'dcsCp1258',     '|0|', 1
UNION ALL
SELECT 36, 'dcsCp437',      '|0|', 1
UNION ALL
SELECT 37, 'dcsCp500',      '|0|', 1
UNION ALL
SELECT 38, 'dcsCp737',      '|0|', 1
UNION ALL
SELECT 39, 'dcsCp855',      '|0|', 1
UNION ALL
SELECT 40, 'dcsCp856',      '|0|', 1
UNION ALL
SELECT 41, 'dcsCp857',      '|0|', 1
UNION ALL
SELECT 42, 'dcsCp860',      '|0|', 1
UNION ALL
SELECT 43, 'dcsCp862',      '|0|', 1
UNION ALL
SELECT 44, 'dcsCp863',      '|0|', 1
UNION ALL
SELECT 45, 'dcsCp864',      '|0|', 1
UNION ALL
SELECT 46, 'dcsCp865',      '|0|', 1
UNION ALL
SELECT 47, 'dcsCp869',      '|0|', 1
UNION ALL
SELECT 48, 'dcsCp874',      '|0|', 1
UNION ALL
SELECT 49, 'dcsCp875',      '|0|', 1
UNION ALL
SELECT 50, 'dcsIceland',    '|0|', 1
UNION ALL
SELECT 51, 'dcsBig5',       '|0|', 1
UNION ALL
SELECT 52, 'dcsKSC5601',    '|0|', 1
UNION ALL
SELECT 53, 'dcsEUC',        '|0|', 1
UNION ALL
SELECT 54, 'dcsGB2312',     '|0|', 1
UNION ALL
SELECT 55, 'dcsSJIS_0208',  '|0|', 1
UNION ALL
SELECT 56, 'dcsLatin9',     '|0|', 1
UNION ALL
SELECT 57, 'dcsLatin13',    '|0|', 1
UNION ALL
SELECT 58, 'dcsCp1252',     '|3|', 0
UNION ALL
SELECT 59, 'dcsCp1253',     '|0|', 1
UNION ALL
SELECT 60, 'dcsCp775',      '|0|', 1
UNION ALL
SELECT 61, 'dcsCp858',      '|0|', 1
GO