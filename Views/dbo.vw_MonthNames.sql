SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   14.07.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   14.07.2011$
--$Version:    1.00$   $Description: Вьюшка месяцами$
CREATE VIEW [dbo].[vw_MonthNames]
AS
    SELECT 1 AS ID, CAST('Январь' AS Varchar(15)) AS [Name], CAST(NULL AS Int) AS LangID
    UNION ALL
    SELECT 2, 'Февраль', NULL
    UNION ALL
    SELECT 3, 'Март', NULL
    UNION ALL
    SELECT 4, 'Апрель', NULL
    UNION ALL
    SELECT 5, 'Май', NULL
    UNION ALL
    SELECT 6, 'Июнь', NULL
    UNION ALL
    SELECT 7, 'Июль', NULL
    UNION ALL
    SELECT 8, 'Август', NULL
    UNION ALL
    SELECT 9, 'Сентябрь', NULL
    UNION ALL
    SELECT 10, 'Октябрь', NULL
    UNION ALL
    SELECT 11, 'Ноябрь', NULL
    UNION ALL
    SELECT 12, 'Декабрь', NULL
GO