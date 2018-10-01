SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   20.04.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   25.06.2015$*/
/*$Version:    1.00$   $Description: Вьюшка с важностью задач$*/
CREATE VIEW [dbo].[vw_TasksSeverity]
AS
    SELECT 0 AS ID, CAST('Низкий' AS Varchar(50)) AS [Name], 15 AS ImageIndex
    UNION ALL
    SELECT 1, 'Средний', 14
    UNION ALL
    SELECT 2, 'Высокий', 13
GO