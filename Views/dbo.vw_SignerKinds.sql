SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   18.06.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   20.06.2013$*/
/*$Version:    1.00$   $Description: Вьюшка c видами заголовков подписантов спецификации*/
CREATE VIEW [dbo].[vw_SignerKinds]
AS
    SELECT 0 AS ID, CAST('Покупець' AS Varchar(15)) AS [Name], CAST(0 AS tinyint) AS [Type], CAST(0 AS bit) AS IsDefault
    UNION ALL
    SELECT 1, 'Постачальник', 0, 0
    UNION ALL
    SELECT 2, 'Виконавець', 0, 1
    UNION ALL
    SELECT 3, 'Замовник', 1, 1
    UNION ALL
    SELECT 4, '__________', 0, 0
    UNION ALL
    SELECT 5, 'Компанія', 0, 0
GO