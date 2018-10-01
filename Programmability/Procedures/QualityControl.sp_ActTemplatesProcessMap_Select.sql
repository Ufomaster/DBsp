SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   04.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   04.12.2013$*/
/*$Version:    1.00$   $Description: выборка процесса прохождения акта*/
CREATE PROCEDURE [QualityControl].[sp_ActTemplatesProcessMap_Select]
AS
BEGIN
    SELECT
        s.[Name] AS StatusName,
        sGo.[Name] AS GoStatusName,
        ne.[Name] AS NotifyEventName,    
        pm.*
    FROM QualityControl.ActTemplatesProcessMap pm
    LEFT JOIN NotifyEvents ne ON ne.ID = pm.NotifyEventID
    LEFT JOIN QualityControl.ActStatuses s ON s.ID = pm.StatusID
    LEFT JOIN QualityControl.ActStatuses sGo ON sGo.ID = pm.GoStatusID
    ORDER BY s.SortOrder, sGo.SortOrder
END
GO