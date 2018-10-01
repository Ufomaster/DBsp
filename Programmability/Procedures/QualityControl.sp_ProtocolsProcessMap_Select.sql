SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   20.11.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   13.03.2015$*/
/*$Version:    1.00$   $Decription: выборка карты статусов$*/
CREATE PROCEDURE [QualityControl].[sp_ProtocolsProcessMap_Select]
    @StatusID Int
AS
BEGIN
    SELECT
        pm.ID,
        pm.StatusID,
        pm.GoStatusID,
        pm.NotifyEventID,
        pm.AutoCreateAct,
        pm.EnableResultCalc,
        pm.SetAuthSignedDate,
        pm.SetAuthSignedDateClear,        
        pm.SetQCSpecSignedDate,
        pm.SetQCSpecSignedDateClear,
        pm.NotifyManager,
        pm.CheckPropsForTest,
        pm.CheckActPropsForTest
    FROM QualityControl.TypesProcessMap pm
    INNER JOIN QualityControl.TypesStatuses s ON s.ID = pm.GoStatusID
    WHERE pm.StatusID = @StatusID

    UNION ALL

    SELECT TOP 1
        pm.ID,
        @StatusID,
        @StatusID,
        NULL,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0
    FROM QualityControl.TypesProcessMap pm
    WHERE pm.StatusID = @StatusID
END
GO