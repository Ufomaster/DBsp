SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	$Create date:   16.02.2011$
--$Modify:     Oleynik Yuriy$	$Modify date:   07.07.2015$
--$Version:    1.00$   $Description: Вьюшка с важнcотями заявки$
CREATE VIEW [dbo].[vw_RequestSeverities]
AS
    SELECT 0 AS ID, CAST('Низкая' AS Varchar(50)) AS [Name], 15 AS ImageIndex, 0 AS CheckState
    UNION ALL
    SELECT 1, 'Нормальная', 14, 0
    UNION ALL
    SELECT 2, 'Высокая', 13, 0
GO