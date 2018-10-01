SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


--$Create:     Oleynik Yuriy$	$Create date:   24.02.2011$
--$Modify:     Oleynik Yuriy$	$Modify date:   24.02.2011$
--$Version:    1.00$   $Description: Вьюшка с состояниями группы объектов или (типа объекта)$
CREATE VIEW [dbo].[vw_ObjectTypeStatuses]
AS
    SELECT 0 AS ID, CAST('В разработке' AS VARCHAR(50)) AS [Name], 0 AS ImageIndex
    UNION ALL
    SELECT 1, 'Включена', 0
    UNION ALL
    SELECT 2, 'Отключена',0
GO