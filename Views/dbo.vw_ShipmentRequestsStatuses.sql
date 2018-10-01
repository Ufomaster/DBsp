SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   03.12.2015$*/
/*$Modify:     Oleynik Yuriy$   $Modify date:   10.12.2015$*/
/*$Version:    1.00$   $Description: Вьюшка со статусами заявок на поставоки$*/
create VIEW [dbo].[vw_ShipmentRequestsStatuses]
AS
    SELECT 0 AS ID, CAST('Черновик' AS Varchar(50)) AS [Name], 1 AS CheckStateMgr, 0 AS CheckStateLog
    UNION ALL
    SELECT 1, 'В работе', 0, 1
    UNION ALL
    SELECT 2, 'Выполнена', 0, 0
    UNION ALL
    SELECT 3, 'Отмена', 0, 0
GO