SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$	$Create date:   02.12.2015$*/
/*$Modify:     Yuriy Oleynik$	$Modify date:   10.12.2015$*/
/*$Version:    1.00$   $Description: Вьюшка со строками дней$*/
create VIEW [dbo].[vw_DateStringsCompareNow]
AS
    SELECT 10 AS ID, CAST('Давно' AS Varchar(50)) AS [Name], 0 AS CheckStateMgr, 0 AS CheckStateLog
    UNION ALL
    SELECT 11, 'Позавчера', 0, 0
    UNION ALL
    SELECT 12, 'Вчера', 0, 1
    UNION ALL
    SELECT 13, 'Сегодня', 0, 1
    UNION ALL
    SELECT 14, 'Завтра', 0, 1
    UNION ALL
    SELECT 15, 'Послезавтра', 0, 0
    UNION ALL
    SELECT 16, 'Через 3 дня', 0, 0
    UNION ALL
    SELECT 17, 'Через 4 дня', 0, 0
    UNION ALL
    SELECT 18, 'Cкоро', 0, 0
GO