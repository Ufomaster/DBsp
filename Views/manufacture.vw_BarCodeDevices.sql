SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   25.04.2016$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   25.04.2016$*/
/*$Version:    1.00$   $Description:$*/
create VIEW [manufacture].[vw_BarCodeDevices]
AS
    SELECT 0 AS ID, 'Не указан' AS Name
    UNION ALL
    SELECT 1, 'Бесконтактный считыватель'
    UNION ALL
    SELECT 2, 'Smart-card считыватель'
    UNION ALL
    SELECT 3, 'Сканер штрихкодов/считыватель магнитной полосы'
GO