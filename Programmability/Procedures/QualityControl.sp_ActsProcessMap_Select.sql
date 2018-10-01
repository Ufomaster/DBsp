SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   06.12.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   06.04.2015$*/
/*$Version:    1.00$   $Decription: выборка карты статусов$*/
CREATE PROCEDURE [QualityControl].[sp_ActsProcessMap_Select]
    @StatusID Int
AS
BEGIN
    SELECT
        pm.ID,
        pm.StatusID,
        pm.GoStatusID,
        pm.NotifyEventID,
        pm.NotifyAuthor,
        pm.CreateTasks
    FROM QualityControl.ActTemplatesProcessMap pm
    INNER JOIN QualityControl.ActStatuses s ON s.ID = pm.GoStatusID
    WHERE pm.StatusID = @StatusID

    UNION ALL

    SELECT TOP 1
        pm.ID,
        @StatusID,
        @StatusID,
        NULL,
        0,
        0
    FROM QualityControl.ActTemplatesProcessMap pm
    WHERE pm.StatusID = @StatusID
END
GO