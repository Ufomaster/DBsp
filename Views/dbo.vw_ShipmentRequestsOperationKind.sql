SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   02.12.2015$*/
/*$Modify:     Oleynik Yuriy$   $Modify date:   02.12.2015$*/
/*$Version:    1.00$   $Description: Вьюшка с видами поставок$*/
create VIEW [dbo].[vw_ShipmentRequestsOperationKind]
AS
    SELECT 0 AS ID, CAST('внутренняя' AS Varchar(50)) AS [Name]
    UNION ALL
    SELECT 1, 'импорт'
    UNION ALL
    SELECT 2, 'экспорт'
GO