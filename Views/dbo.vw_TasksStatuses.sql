SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   31.03.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   25.06.2015$*/
/*$Version:    1.00$   $Description: Вьюшка со статусами задач$*/
CREATE VIEW [dbo].[vw_TasksStatuses]
AS
    SELECT 0 AS ID, CAST('Черновик' AS Varchar(50)) AS [Name], 63 AS ImageIndex, 0 AS RowColorIndex
    UNION ALL
    SELECT 1, 'В работе', 52, -1
    UNION ALL
    SELECT 2, 'На контроле', 53, -1
    UNION ALL
    SELECT 3, 'Выполнена', 64, 2
    UNION ALL
    SELECT 4, 'Отменена', 111, 1
GO