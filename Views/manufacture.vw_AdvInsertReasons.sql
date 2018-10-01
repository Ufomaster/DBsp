SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   21.07.2016$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   21.07.2016$*/
/*$Version:    1.00$   $Description: Классификатор причин правок сменных заданий$*/
create VIEW [manufacture].[vw_AdvInsertReasons]
AS
    SELECT 0 AS ID, 'Возврат из брака' AS Name
/*    UNION ALL
    SELECT 1, 'Бесконтактный считыватель'
    UNION ALL
    SELECT 2, 'Smart-card считыватель'
    UNION ALL
    SELECT 3, 'Сканер штрихкодов/считыватель магнитной полосы'*/
GO