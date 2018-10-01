SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$	$Create date:   16.02.2011$
--$Modify:     Oleynik Yuriy$	$Modify date:   07.07.2015$
--$Version:    1.00$   $Description: Вьюшка с состояниями заявки$
CREATE VIEW [dbo].[vw_RequestStatuses]
AS
    SELECT 0 AS ID, CAST('Новая' AS Varchar(50)) AS [Name], NULL AS TextMarkupColor, NULL AS BackMarkupColor, 16 AS ImageIndex, 1 AS CheckState
    UNION ALL
    SELECT 1, 'Прочтена', NULL, NULL, 17, 1
    UNION ALL
    SELECT 2, 'Выполняется', NULL, NULL, 18, 1
    UNION ALL
    SELECT 3, 'Отменена', NULL, NULL, 19, 0
    UNION ALL
    SELECT 4, 'Выполнена', NULL, NULL, 20, 0
    --UNION ALL
    --SELECT 5, 'Заново открыта', NULL, NULL, 21
    UNION ALL
    SELECT 6, 'Отложена', NULL, NULL, 22, 0
GO