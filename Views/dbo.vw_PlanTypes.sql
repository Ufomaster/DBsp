SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


--$Create:     Oleynik Yuriy$    $Create date:   23.03.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   23.03.2011$
--$Version:    1.00$   $Description: Вьюшка типами плановых работ$
CREATE VIEW [dbo].[vw_PlanTypes]
AS
    SELECT 0 AS ID, CAST('Одноразовая' AS VARCHAR(50)) AS [Name]
    UNION ALL
    SELECT 1, 'Периодическая (дни)'
    UNION ALL
    SELECT 2, 'Периодическая (месяцы)'
GO