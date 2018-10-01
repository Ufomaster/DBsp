SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   11.11.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   28.04.2016$*/
/*$Version:    1.00$   $Decription: Процедура выборки настроек работы для компонентов для МДС $*/
CREATE PROCEDURE [manufacture].[sp_JobStageChecks_Select]
    @JobStageID int
AS
BEGIN
    SET NOCOUNT ON

    SELECT
        j.*,
        ic.GroupColumnName,
        (SELECT COUNT(a.ID) FROM manufacture.JobStageChecks a WHERE a.JobStageID = @JobStageID AND a.isDeleted = 0 AND a.CheckLink = 1) AS LinksCount,
        ej.SortOrder AS EqualityCheckSortOrder,
        bd.[Name] AS DeviceName,
        bt.[Name] AS BarCodeTypeName,
        bt.Code AS BarCode
    FROM manufacture.JobStageChecks j
    LEFT JOIN manufacture.PTmcImportTemplateColumns ic ON ic.ID = j.ImportTemplateColumnID
    LEFT JOIN manufacture.JobStageChecks ej ON ej.ID = j.EqualityCheckID AND ej.JobStageID = @JobStageID
    INNER JOIN manufacture.vw_BarCodeDevices bd ON bd.ID = j.BarCodeDeviceKind
    LEFT JOIN manufacture.BarCodeTypes bt ON bt.ID = j.BarCodeType    
    WHERE j.JobStageID = @JobStageID AND j.isDeleted = 0 ORDER BY j.SortOrder
END
GO