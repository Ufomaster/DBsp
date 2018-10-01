SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   09.08.2016$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   19.08.2016$*/
/*$Version:    1.00$   $Description: Выбор данных для отката брака*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncReturnFail_Prepare]
    @Type tinyint,
    @TmcID int,
    @PCCID int,
    @ProductionTasksID int   
AS
BEGIN
    SELECT    
        dd.TMCID,
        dd.ProductionCardCustomizeID AS PCCID,
--        t.Name + ' [' + s.[Name] + '] max=' + CAST(p.Amount AS varchar) AS Name,
        t.Name,
        CASE WHEN d.ProductionTasksOperTypeID = 6 THEN dd.StatusFromID ELSE dd.StatusID END AS StatusID,
        SUM(CASE WHEN d.ProductionTasksOperTypeID = 6 THEN dd.Amount ELSE -dd.Amount END) AS Amount,
        dd.isMajorTMC,
        p.Amount AS MaxAmount,
        s.Name AS StatusName
    INTO #tmp
    FROM manufacture.ProductionTasksDocDetails dd
    LEFT JOIN manufacture.ProductionTasksDocs d ON d.ID = dd.ProductionTasksDocsID
    LEFT JOIN manufacture.vw_ProductionTasksAgregation_Select p ON p.TMCID = dd.TMCID AND p.ProductionCardCustomizeID = dd.ProductionCardCustomizeID
       AND p.ProductionTasksStatusID = 3 AND p.ProductionTasksID = @ProductionTasksID
    LEFT JOIN Tmc t ON t.ID = dd.TMCID
    LEFT JOIN manufacture.ProductionTasksStatuses s ON (s.ID = dd.StatusFromID AND d.ProductionTasksOperTypeID = 6) OR (s.ID = dd.StatusID AND d.ProductionTasksOperTypeID = 8)
    WHERE dd.TMCID = @TmcID
         AND
         d.ProductionTasksOperTypeID in (6,8)
         AND dd.ProductionCardCustomizeID = @PCCID
    GROUP BY dd.TMCID, dd.ProductionCardCustomizeID, t.Name, --t.Name + ' [' + s.[Name] + '] max=' + CAST(p.Amount AS varchar),
      CASE WHEN d.ProductionTasksOperTypeID = 6 THEN dd.StatusFromID ELSE dd.StatusID END, dd.isMajorTMC, p.Amount, s.Name
    HAVING SUM(CASE WHEN d.ProductionTasksOperTypeID = 6 THEN dd.Amount ELSE -dd.Amount END) > 0
    
    IF @Type = 0 --TMC only select
        SELECT TMCID, PCCID, Name, Amount, isMajorTMC, MaxAmount
        FROM #tmp
        GROUP BY TMCID, PCCID, Name, Amount, isMajorTMC, MaxAmount
    ELSE
    IF @Type = 1 --StatusOnly Select
        SELECT StatusID AS ID, StatusName AS Name
        FROM #tmp
        GROUP BY StatusID, StatusName
        
   DROP TABLE #tmp
END
GO