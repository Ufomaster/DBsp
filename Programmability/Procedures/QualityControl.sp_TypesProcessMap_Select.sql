SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   07.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   07.11.2013$*/
/*$Version:    1.00$   $Description: выборка процесса прохождения протокола*/
create PROCEDURE [QualityControl].[sp_TypesProcessMap_Select]
AS
BEGIN
    SELECT
        s.[Name] AS StatusName,
        sGo.[Name] AS GoStatusName,
        ne.[Name] AS NotifyEventName,    
        pm.*
    FROM QualityControl.TypesProcessMap pm
    LEFT JOIN NotifyEvents ne ON ne.ID = pm.NotifyEventID
    LEFT JOIN QualityControl.TypesStatuses s ON s.ID = pm.StatusID
    LEFT JOIN QualityControl.TypesStatuses sGo ON sGo.ID = pm.GoStatusID
    ORDER BY s.SortOrder, sGo.SortOrder
END
GO