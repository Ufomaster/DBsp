SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	$Create date:   21.03.2011$
--$Modify:     Oleynik Yuriy$   $Modify date:   22.12.2011$
--$Version:    1.00$   $Description: Вьюшка с видами работ$
CREATE VIEW [dbo].[vw_SolutionKinds]
AS
    SELECT 0 AS ID, CAST('Диагностика' AS Varchar(50)) AS [Name]
    UNION ALL
    SELECT 1, 'Ремонт'
    UNION ALL
    SELECT 2, 'Обслуживание'
GO