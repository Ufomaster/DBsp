SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   11.05.2016$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   18.05.2016$*/
/*$Version:    1.00$   $Description: Предзаполнение*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncProduce_PreparePCC]
    @PCCID int,
    @OutProdClass int
AS
BEGIN
    DELETE FROM #WPProducePCC
    /*PCC заполняем всегда, независимо от вида ГП.*/
    IF @OutProdClass = 4 --вырубка
    BEGIN
        INSERT INTO #WPProducePCC(PCCID, Name, Number, CardCount, TmcID)
        SELECT b.ProductionCardCustomizeID, pc.[Name], pc.Number, MAX(b.CardCount), pc.TmcID
        FROM TmcPCC b
        INNER JOIN TmcSurrogateDetails s ON s.TmcID = b.TmcID AND s.MasterTmcID IN (SELECT TmcID FROM #WPProduce WHERE IsDeleted = 0 
                                                                                    UNION 
                                                                                    SELECT TmcID FROM #WPProduceProduct)
        INNER JOIN ProductionCardCustomize pc ON pc.ID = b.ProductionCardCustomizeID
        GROUP BY b.ProductionCardCustomizeID, pc.[Name], pc.Number, pc.TmcID
        ORDER BY pc.Number
        
        IF NOT EXISTS(SELECT * FROM #WPProducePCC)
            INSERT INTO #WPProducePCC(PCCID, Name, Number, CardCount, TmcID)
            SELECT b.ProductionCardCustomizeID, pc.[Name], pc.Number, MAX(b.CardCount), pc.TmcID
            FROM TmcPCC b
            INNER JOIN #WPProduce pp ON  pp.TmcID = b.TmcID AND pp.IsTL = 1 AND pp.IsDeleted = 0
            INNER JOIN ProductionCardCustomize pc ON pc.ID = b.ProductionCardCustomizeID
            GROUP BY b.ProductionCardCustomizeID, pc.[Name], pc.Number, pc.TmcID
            ORDER BY pc.Number
    END
    ELSE
    BEGIN
        INSERT INTO #WPProducePCC(PCCID, Name, Number, CardCount, TmcID)    
        SELECT a.ID, a.[Name], a.Number, 0, a.TmcID
        FROM ProductionCardCustomize a 
        WHERE a.ID = @PCCID
    END
END
GO