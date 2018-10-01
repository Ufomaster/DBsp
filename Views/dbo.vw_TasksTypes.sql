SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   31.03.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   24.06.2015$*/
/*$Version:    1.00$   $Description: Вьюшка с типами задач$*/
CREATE VIEW [dbo].[vw_TasksTypes]
AS
    SELECT 1 AS ID, 'Задача по Акту НС' AS Name
    UNION ALL
    SELECT 2, 'Задача по Протоколу'
    UNION ALL
    SELECT 3, 'Задача по приказу'
    UNION ALL
    SELECT 4, 'Задача по ТЗ'
    UNION ALL
    SELECT 5, 'Задача по Акту Отклонения'
    UNION ALL
    SELECT 6, 'Задача по совещанию'
GO