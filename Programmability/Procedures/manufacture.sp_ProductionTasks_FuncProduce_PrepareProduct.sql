SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    		$Create date:   07.04.2016$*/
/*$Modify:     Oleynik Yuriy$    		$Modify date:   14.07.2017$*/
/*$Version:    1.00$   $Description: Поиск готовой продукции для изготовления*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncProduce_PrepareProduct]
    @CurrentSectorID Int,
    @PCCID int,
    @StorageStructureID int,
    @OutProdClass int,
    @OutStatusID int,
    @ProductionTasksID int,
    @CurStatusID int
AS
BEGIN
    IF @OutProdClass = 0 --Входящая ГП с передающего участка
    BEGIN
        --ищем входящую ГП, переданную с другого участка.
        DELETE FROM #WPProduceProduct
        
        INSERT INTO #WPProduceProduct(TMCID, Name, Amount, AmountMax, isMajorTMC, StatusName, StatusID)
        SELECT
            ps.TMCID,
            t.[Name],
            0,
            ps.Amount,
            1,
            pts.[Name],
            ps.ProductionTasksStatusID
        FROM manufacture.vw_ProductionTasksAgregation_Select ps
            LEFT JOIN dbo.ProductionCardCustomize pcc ON pcc.ID = ps.ProductionCardCustomizeID
            LEFT JOIN Tmc t ON t.ID = ps.TMCID
            LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ps.ProductionTasksID                        
            LEFT JOIN manufacture.ProductionTasksStatuses pts ON pts.ID = ps.ProductionTasksStatusID
        WHERE pt.StorageStructureSectorID = @CurrentSectorID AND ps.ProductionTasksStatusID = @CurStatusID AND ps.ProductionTasksID = @ProductionTasksID
            AND ps.ProductionTasksStatusID NOT IN (2, 3, 5, @OutStatusID)
            AND ps.ProductionCardCustomizeID = @PCCID AND ps.ConfirmStatus = 1 AND ps.isMajorTMC = 1
        GROUP BY ps.TMCID, t.[Name], pts.[Name], ps.ProductionTasksStatusID, ps.Amount
    END
    ELSE
    IF @OutProdClass = 1 --Создание пакета ИЗ ПВХ
    BEGIN
        DELETE FROM #WPProduceProduct
        --Если есть изготовленные сурогаты уже на этом участке

        INSERT INTO #WPProduceProduct(TMCID, Name, Amount, AmountMax, isMajorTMC, StatusName, StatusID)
        SELECT ps.TMCID, t.[Name], 0, ps.Amount, 1, pts.[Name], ps.ProductionTasksStatusID
        FROM manufacture.vw_ProductionTasksAgregation_Select ps
            LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ps.ProductionTasksID
            INNER JOIN manufacture.ProductionTasksStatuses pts ON pts.ID = ps.ProductionTasksStatusID
            INNER JOIN TmcSurrogateDetails p ON p.MasterTmcID = ps.TMCID
            INNER JOIN Tmc t ON t.ID = ps.TMCID
            FULL JOIN #WPProduce stm ON stm.TMCID = p.TmcID AND IsDeleted = 0 --выбранные ТМЦ сурогата должны совпадать с другими ТМЦ
        WHERE ps.ProductionTasksStatusID = @OutStatusID AND pt.StorageStructureSectorID = @CurrentSectorID AND ps.ProductionCardCustomizeID = @PCCID
           AND ps.ProductionTasksID = @ProductionTasksID
           AND p.ID IS NOT NULL AND stm.ID IS NOT NULL AND stm.IsTL = 1--полное совпадение нужно
        GROUP BY ps.TMCID, t.[Name], ps.Amount, pts.[Name], ps.ProductionTasksStatusID
        HAVING ps.Amount > 0

        IF NOT EXISTS(SELECT * FROM #WPProduceProduct)
            INSERT INTO #WPProduceProduct(TMCID, Name, Amount, AmountMax, isMajorTMC, StatusName, StatusID)
            SELECT NULL, 'Полуфабрикат по ЗЛ ' + pc.Number, 0, 0, 1, 'Новый сурогат', 1
            FROM ProductionCardCustomize pc
            WHERE pc.ID = @PCCID
    END
    ELSE
    IF @OutProdClass = 2 --Автопоиск готовой продукции из ЗЛ
    BEGIN
        DELETE FROM #WPProduceProduct
        INSERT INTO #WPProduceProduct(TMCID, Name, Amount, AmountMax, isMajorTMC, StatusName, StatusID)
        SELECT pc.TmcID, t.[Name], 0, 0, 1, NULL, NULL
        FROM ProductionCardCustomize pc
        INNER JOIN Tmc t ON t.ID = pc.TmcID
/*        LEFT JOIN manufacture.vw_ProductionTasksAgregation_Select ps ON ps.TMCID = pc.TmcID 
           AND ps.ProductionCardCustomizeID = pc.ID 
           AND ps.ProductionTasksID = @ProductionTasksID*/
--           AND ps.StorageStructureSectorID = @CurrentSectorID
--           AND ps.ProductionTasksStatusID <> @OutStatusID
        WHERE pc.ID = @PCCID
        GROUP BY pc.TmcID, t.[Name]
    END
    ELSE    
    IF @OutProdClass = 3 --Создание полуфабриката из тиражных листов
    BEGIN
        DELETE FROM #WPProduceProduct

        INSERT INTO #WPProduceProduct(TMCID, AmountMax, Amount, Name, StatusName, isMajorTMC, StatusID)
        SELECT TOP 1 t.ID, NULL, NULL, t.Name, NULL, 0, NULL
        FROM TmcPCC b INNER JOIN Tmc t ON t.ID = b.TmcID 
        LEFT JOIN TmcAttributes tt ON tt.TmcID = b.TmcID AND tt.AttributeID = 20 
        WHERE b.ProductionCardCustomizeID = @PCCID AND tt.TmcID IS NULL GROUP BY t.ID, t.Name
     
    END
    ELSE
    IF @OutProdClass = 4 --вырубка
    BEGIN
        DELETE FROM #WPProduceProduct
    END    
END
GO