SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   01.10.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   01.10.2012$*/
/*$Version:    1.00$   $Description: выборка процесса прохождения ЗЛ$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardProcessMap_Select]
AS
BEGIN
    SELECT
        t.[Name] AS TypeName,
        s.[Name] AS StatusName,
        sGo.[Name] AS GoStatusName,
        ne.[Name] AS NotifyEventName,    
        pm.*
    FROM ProductionCardProcessMap pm
    LEFT JOIN NotifyEvents ne ON ne.ID = pm.NotifyEventID
    LEFT JOIN ProductionCardTypes t ON t.ID = pm.[Type]
    LEFT JOIN ProductionCardStatuses s ON s.ID = pm.StatusID
    LEFT JOIN ProductionCardStatuses sGo ON sGo.ID = pm.GoStatusID
    ORDER BY t.[Name], s.SortOrder,  sGo.SortOrder
END
GO