SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    		$Create date:   21.02.2017$*/
/*$Modify:     Oleynik Yuriy$    		$Modify date:   21.02.2017$*/
/*$Version:    1.00$   $Description: Предзаполнение списка тиражных листов*/
create PROCEDURE [manufacture].[sp_ProductionTasks_FuncProduce_TLLoad]
    @CurrentSectorID Int,
    @PCCID int,
    @StorageStructureID int,
    @OutProdClass int,
    @OutStatusID int,
    @ProductionTasksID int,
    @CurStatusID int
AS
BEGIN
    DELETE FROM #TLList
    IF @OutProdClass = 1
    BEGIN
        INSERT INTO #TLList(TMCID, Name, StatusName, StatusID)
        SELECT
            ps.TMCID,
            t.[Name],
            pts.[Name],
            ps.ProductionTasksStatusID
        FROM manufacture.vw_ProductionTasksAgregation_Select ps
            LEFT JOIN dbo.ProductionCardCustomize pcc ON pcc.ID = ps.ProductionCardCustomizeID
            LEFT JOIN dbo.ProductionCardCustomize pccM ON pccM.ID = @PCCID
            LEFT JOIN (SELECT mat.* 
                      FROM dbo.ProductionCardCustomizeMaterials mat
                          --Exclude materials with two and more Norms
                          INNER JOIN (SELECT min(m.ID) as ID FROM dbo.ProductionCardCustomizeMaterials m
                                    WHERE m.ProductionCardCustomizeID = @PCCID
                                    GROUP BY m.ProductionCardCustomizeID, m.TmcID
                                    HAVING count(*) = 1) as mToUse on mToUse.ID = mat.ID) 
			            mat ON mat.ProductionCardCustomizeID = ISNULL(ps.ProductionCardCustomizeID, @PCCID) AND mat.TmcID = ps.TMCID
            LEFT JOIN Tmc t ON t.ID = ps.TMCID
            LEFT JOIN Units u ON u.ID = t.UnitID
            LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ps.ProductionTasksID
            LEFT JOIN manufacture.StorageStructureSectors sss ON sss.ID = pt.StorageStructureSectorID
            LEFT JOIN manufacture.ProductionTasksStatuses pts ON pts.ID = ps.ProductionTasksStatusID
            INNER JOIN TmcPCC p ON p.TmcID = ps.TMCID AND p.ProductionCardCustomizeID = @PCCID
        WHERE ps.ProductionTasksStatusID NOT IN (2, 3, 5, @OutStatusID)
            AND (ps.ProductionCardCustomizeID = @PCCID OR ps.ProductionCardCustomizeID IS NULL) AND ps.ConfirmStatus = 1
            AND ps.ProductionTasksID = @ProductionTasksID
            AND ps.Amount > 0
    END
END
GO