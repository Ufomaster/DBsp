SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   26.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   26.11.2013$*/
/*$Version:    1.00$   $Description:$*/
create VIEW [QualityControl].[vw_PropertyKind]
AS
    SELECT 0 AS ID, 'Не редактируемое информационное значение' AS Name
    UNION ALL
    SELECT 1, 'Редактируемое значение'
    UNION ALL
    SELECT 2, 'Значение, которое влияет на вывод по протоколу'
    UNION ALL
    SELECT 3, 'Значение, которое не влияет на вывод по протоколу'
GO