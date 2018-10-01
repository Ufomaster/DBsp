SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	$Create date:   21.03.2011$
--$Modify:     Oleynik Yuriy$   $Modify date:   21.12.2011$
--$Version:    1.00$   $Description: Вьюшка с состояниями работ$
CREATE VIEW [dbo].[vw_SolutionStatuses]
AS
    SELECT 0 AS ID, CAST('Выполняется' AS Varchar(50)) AS [Name]--, NULL AS TextMarkupColor, NULL AS BackMarkupColor, 16 AS ImageIndex
    UNION ALL
    SELECT 1, 'Завершена'--, NULL, NULL, 17
    UNION ALL
    SELECT 2, 'Ожидание'--, NULL, NULL, 17
GO