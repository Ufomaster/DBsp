SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$        $Create date:   26.05.2017$*/
/*$Modify:     Oleynik Yuriy$        $Modify date:   17.07.2017$*/
/*$Version:    1.00$   $Description: Предзаполнение материалов отбраковки для ЦС*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncFailMDS_Prepare]
    @JobStageID Int,
    @PCCID int,
    @SectorID int
AS
BEGIN
    SELECT t.ID , t.[Name], u.Name AS UnitName
    FROM Tmc t
    LEFT JOIN manufacture.JobStageChecks js ON js.JobStageID = @JobStageID AND js.TmcID = t.ID AND ISNULL(js.isDeleted, 0) = 0
    LEFT JOIN Units u ON u.ID = t.UnitID
    INNER JOIN ProductionCardCustomizeMaterials d ON d.TmcID = t.ID
    INNER JOIN ProductionCardCustomize PC ON PC.ID = d.ProductionCardCustomizeID
    --INNER JOIN ObjectTypes ot ON ot.ID = t.ObjectTypeID AND ISNULL(ot.isStandart, 0) = 1
    WHERE d.ProductionCardCustomizeID = @PCCID AND js.ID IS NULL
        AND t.ID IN (SELECT ID FROM dbo.fn_TMCLinkedToSectors_Select(@SectorID, d.TmcID, NULL))
        AND ISNULL(t.IsHidden, 0) = 0 AND t.Code1C IS NOT NULL
    ORDER BY t.Name
END
GO