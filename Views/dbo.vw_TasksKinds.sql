SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   20.04.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   07.05.2015$*/
/*$Version:    1.00$   $Description: Вьюшка с видами задач$*/
CREATE VIEW [dbo].[vw_TasksKinds]
AS
    SELECT 0 AS ID, CAST('Предупреждающая' AS Varchar(50)) AS [Name]
    UNION ALL
    SELECT 1, 'Корректирующая'
    UNION ALL
    SELECT 2, 'Организационная'
GO