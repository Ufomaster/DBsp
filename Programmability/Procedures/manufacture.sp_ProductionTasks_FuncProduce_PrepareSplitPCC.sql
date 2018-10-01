SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    		$Create date:   13.07.2016$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   18.05.2017$*/
/*$Version:    1.00$   $Description: Предзаполнение*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncProduce_PrepareSplitPCC]
    @OutProdClass int,
    @PCCID int = 0
AS
BEGIN
    DECLARE @TmcIDToSplit int    
    CREATE TABLE #Tmp(PCCID int, Name varchar(255), Number varchar(20), CardCount int, TmcID int, CardCountTotal int)

    SELECT TOP 1 @TmcIDToSplit = tp.TmcID
    FROM TmcPCC tp
    LEFT JOIN TmcSurrogateDetails s ON s.MasterTmcID = tp.TmcID 
    INNER JOIN (SELECT TmcID FROM #WPProduce p WHERE isDeleted = 0 AND (p.IsTL = 1 OR p.isMajorTMC = 1)) ts
        ON (ts.TmcID = tp.TmcID) OR (ts.TmcID = s.TmcID)
        
    INSERT INTO #Tmp(PCCID, Name, Number, CardCount, TmcID, CardCountTotal)     
    SELECT tp.ProductionCardCustomizeID, pcc.[Name], pcc.Number, tp.CardCount, tp.TmcID, ts.CardCountTotal
    FROM TmcPCC tp
    INNER JOIN (SELECT TmcID, SUM(t.CardCount) as CardCountTotal FROM TmcPCC t GROUP BY TmcID) ts on ts.TmcID = tp.TmcID
    INNER JOIN ProductionCardCustomize pcc ON pcc.ID = tp.ProductionCardCustomizeID     
    WHERE tp.TmcID = @TmcIDToSplit
 
    IF NOT EXISTS(SELECT * FROM #Tmp) AND EXISTS(SELECT * FROM #WPProduce WHERE isDeleted = 0)
        INSERT INTO #Tmp(PCCID, Name, Number, CardCount, TmcID, CardCountTotal)
        SELECT @PCCID, Name, Number, 0, TmcID, 0
        FROM ProductionCardCustomize 
        WHERE ID = @PCCID
        
    SELECT * FROM #Tmp
    DROP TABLE #Tmp
END
GO