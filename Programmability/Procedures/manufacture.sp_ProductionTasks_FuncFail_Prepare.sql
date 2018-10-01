SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    		$Create date:   23.03.2016$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   27.12.2016$*/
/*$Version:    1.00$   $Description: Предзаполнение*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncFail_Prepare]
    @CurrentSectorID Int,
    @PCCID int,
    @ProductionTasksID int,
    @TMCID int,
    @JobStageID int = NULL
AS
BEGIN
    SELECT 
        ps.TMCID, 
        t.[Name],
        ps.ProductionTasksStatusID AS StatusID,
        ps.Amount, 
        ps.isMajorTMC, 
        ps.StatusName
    FROM manufacture.vw_ProductionTasksAgregation_Select ps
    LEFT JOIN dbo.ProductionCardCustomize pcc ON pcc.ID = ps.ProductionCardCustomizeID
    LEFT JOIN Tmc t ON t.ID = ps.TMCID
    LEFT JOIN Units u ON u.ID = t.UnitID
    LEFT JOIN manufacture.ProductionTasksStatuses pts ON pts.ID = ps.ProductionTasksStatusID
    WHERE ps.ProductionTasksStatusID NOT IN (2,3,5)
      AND ((ps.ProductionCardCustomizeID = @PCCID AND @PCCID <> -1) OR (ps.ProductionCardCustomizeID IS NULL AND @PCCID = -1) )
      AND ps.ProductionTasksID = @ProductionTasksID
      AND ps.Amount > 0
      AND ps.ConfirmStatus = 1
      AND ps.TMCID = @TMCID
END
GO