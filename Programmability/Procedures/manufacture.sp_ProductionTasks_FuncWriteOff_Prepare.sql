SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    		$Create date:   23.03.2016$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   27.12.2016$*/
/*$Version:    1.00$   $Description: Предзаполнение*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncWriteOff_Prepare]
    @ProductionTaskID Int,
    @PCCID int,
    @LocalTmcID int = 0
AS
BEGIN
--    INSERT INTO #WriteOffDetails(TMCID, TMCName, Amount, AmountMax, isMajorTMC)
    SELECT ps.TMCID, t.[Name], 0, ps.Amount, ps.ProductionTasksStatusID,  t.[Name] + ISNULL(' (' + u.[Name] +')', '') AS AdvName, 
        ps.ProductionCardCustomizeID AS PCCID
    FROM manufacture.vw_ProductionTasksAgregation_Select ps
         LEFT JOIN dbo.ProductionCardCustomize pcc ON pcc.ID = ps.ProductionCardCustomizeID
         INNER JOIN Tmc t ON t.ID = ps.TMCID
         LEFT JOIN Units u ON u.ID = t.UnitID
    WHERE ps.ProductionTasksID = @ProductionTaskID AND ps.ProductionTasksStatusID NOT IN (2,3,5)
        AND (ps.ProductionCardCustomizeID = @PCCID OR ps.ProductionCardCustomizeID IS NULL) --AND ps.TMCID = @LocalTmcID))
        AND ps.isMajorTMC = 0
END
GO