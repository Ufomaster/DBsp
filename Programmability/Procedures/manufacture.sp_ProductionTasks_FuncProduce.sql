SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   21.03.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   18.05.2017$*/
/*$Version:    1.00$   $Decription: Запуск функции изготовить$*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncProduce]
    @PCCID int,  
    @SectorID int,
    @ProdTaskID int,
    @EmployeeToID int,
    @StatusID int,
    @OutProdClass int,
    @RangeFrom varchar(36),
    @RangeTo varchar(36),
    @FailAmount decimal(38,10)
AS
BEGIN
    DECLARE @Err Int, @TMCID int, @Amount decimal(38, 10), @AmountMinus decimal(38, 10), 
        @WOFStatusID int, @OldStatusID int, @ProductionCardCustomizeID int
    DECLARE @t TABLE(ID int)

    --для 4-го класса эти переменные неактуальны.
    IF @OutProdClass <> 4 
    BEGIN
        SELECT @TMCID = TMCID, @OldStatusID = StatusID
        FROM #WPProduceProduct

        SELECT @Amount = Sum(Amount), @AmountMinus = -Sum(Amount)
        FROM #ProductOutEmployees
    END
    ELSE
    IF @OutProdClass = 4
    BEGIN
        SELECT @TMCID = NULL, @OldStatusID = 2
    END

    SET XACT_ABORT ON;
    BEGIN TRAN
    BEGIN TRY
        DECLARE @DocID int, @Name varchar(255)

        INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeToID],
            StorageStructureSectorID, [ProductionTasksOperTypeID])
        OUTPUT INSERTED.ID INTO @t
        SELECT @ProdTaskID, @EmployeeToID, @SectorID, 2/*производство*/
        
        SELECT @DocID = ID FROM @t
        DELETE FROM @t

        /*Next Step - Создание сурогатов*/        
        --Если все НУЛ, значит нужно найти или создать сурогат,но в 4-м классе все нул потому что там мульти. поэтому игнорим
        IF @TMCID IS NULL AND @OutProdClass <> 4
        BEGIN            
            -- ЕСли существуют несовпадение - значит это новый сурогат.
            IF EXISTS(SELECT t.ID
                      FROM dbo.TmcSurrogateDetails t
                      FULL JOIN #WPProduce a ON a.TMCID = t.TmcID AND a.IsDeleted = 0
                      WHERE (a.TMCID IS NULL OR t.TmcID IS NULL) AND a.IsTL = 1)
            BEGIN
                SELECT @Name = ISNULL(@Name + '/', '') + Number
                FROM #ProductTMCSplit
                GROUP BY Number
        
                INSERT INTO Tmc (Name, ObjectTypeID)
                OUTPUT INSERTED.ID INTO @t
                SELECT 'Полуфабрикат по ЗЛ ' + @Name, 12
                FROM #WPProduceProduct

                SELECT @TMCID = ID FROM @t
                INSERT INTO TMCAttributes(TMCID, AttributeID)
                SELECT @TMCID, 20
                
                INSERT INTO TmcSurrogateDetails (MasterTmcID, TMCID)
                SELECT @TMCID, TMCID
                FROM #WPProduce
                WHERE IsTL = 1 AND IsDeleted = 0
                --создаем связку Сурогата с Заказными
                INSERT INTO TmcPCC (TMCID, ProductionCardCustomizeID, CardCount)
                SELECT @TMCID, tp.ProductionCardCustomizeID, tp.CardCount
                FROM #WPProduce a
                INNER JOIN TmcPCC tp ON tp.TmcID = a.TmcID
                WHERE a.IsTL = 1 AND a.IsDeleted = 0
                GROUP BY tp.ProductionCardCustomizeID, tp.CardCount
            END
            ELSE
            BEGIN
                --ищем сурогат по совпадению начинки из тмц или сурогатов. Причем нужно полное совпадение.
                SELECT @TMCID = t.MasterTmcID 
                FROM dbo.TmcSurrogateDetails t
                FULL JOIN #WPProduce a ON a.TMCID = t.TmcID AND a.IsDeleted = 0
                WHERE (a.TMCID IS NOT NULL AND t.TmcID IS NOT NULL) AND a.IsTL = 1
            END
        END

        --Если нул только сурогат, то мы рабоатем с ТМЦ и наоборот, если нул ТМЦ то мы рабоатем с сурогатом.
--      IF @TMCSurrogateID IS NOT NULL OR @TMCID IS NOT NULL
            --ничего не нужно делать.
        
        
/*ID tinyint IDENTITY(1,1), TMCID int, AmountMax decimal(38, 10), Amount decimal(38, 10), '+
  '  Name varchar(255), StatusName varchar(255), TMCSurrogateID int, isMajorTMC bit*/

        /*Next Step - Готовая продукция*/        
        --для разных классов разные методы добычи данных.
        IF @OutProdClass = 4
        BEGIN --для вырубки у нас куча ТМЦ и куча ЗЛ
            INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
                isMajorTMC, StatusID, ProductionTasksDocsID, EmployeeID, RangeFrom, RangeTo, StatusFromID, ProductionCardCustomizeFromID)
            OUTPUT INSERTED.ID INTO @t
            SELECT 
                e.TmcID, 
                e.PCCID,
                e.Amount,
                t.[Name],
                1,
                1,
                @StatusID,
                @DocID,
                e.EID,
                @RangeFrom,
                @RangeTo,
                @OldStatusID,
                e.PCCID
            FROM #ProductOutEmployees e
            INNER JOIN Tmc t ON t.ID = e.TmcID -- контролёр ID
        END
        ELSE
        IF @OutProdClass = 3  --создание тиражных листов. Нет из мейжор продукции      
        BEGIN
            INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
                isMajorTMC, StatusID, ProductionTasksDocsID, EmployeeID, RangeFrom, RangeTo, StatusFromID, ProductionCardCustomizeFromID)
            OUTPUT INSERTED.ID INTO @t
            SELECT 
                @TMCID, 
                @PCCID, 
                e.Amount, 
                t.[Name],
                1,
                0,
                @StatusID,
                @DocID,
                e.EID,
                @RangeFrom,
                @RangeTo,
                @OldStatusID,
                @PCCID
            FROM #ProductOutEmployees e
            LEFT JOIN Tmc t ON t.ID = @TMCID        
        END
        ELSE
        BEGIN
            INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
                isMajorTMC, StatusID, ProductionTasksDocsID, EmployeeID, RangeFrom, RangeTo, StatusFromID, ProductionCardCustomizeFromID)
            OUTPUT INSERTED.ID INTO @t
            SELECT 
                @TMCID, 
                @PCCID, 
                e.Amount, 
                t.[Name],
                1,
                1,
                @StatusID,
                @DocID,
                e.EID,
                @RangeFrom,
                @RangeTo,
                @OldStatusID,
                @PCCID
            FROM #ProductOutEmployees e
            LEFT JOIN Tmc t ON t.ID = @TMCID
        END

        /*Next Step - Списание материалов*/
        INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
            StatusID, ProductionTasksDocsID, isMajorTMC, StatusFromID, ProductionCardCustomizeFromID)
        SELECT a.TMCID, a.PCCID, a.Amount, a.Name, 1,
            2, @DocID, isMajorTMC, StatusID, a.PCCFromID
        FROM #ProductTMCSplit a
        UNION ALL
        SELECT a.TMCID, NULL, a.Amount, a.Name, 1,
            2, @DocID, 0, StatusID, NULL
        FROM #WPProduce a
        WHERE a.SkipZlSplit = 1 AND a.IsDeleted = 0

        --Бракуем материалы.
        IF EXISTS(SELECT ID FROM #WPProduce WHERE FailAmount > 0 AND IsDeleted = 0) OR (@FailAmount > 0)
        BEGIN
            DELETE FROM @t
                   
            INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeFromID], StorageStructureSectorID, ProductionTasksOperTypeID)
            OUTPUT INSERTED.ID INTO @t
            SELECT @ProdTaskID, @EmployeeToID, @SectorID, 6/*Брак*/
            SELECT @DocID = ID FROM @t

            /*Next Step - Insert Position*/

            INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
                StatusID, ProductionTasksDocsID, isMajorTMC, StatusFromID, ProductionCardCustomizeFromID)
            --OUTPUT INSERTED.ID INTO @t
            SELECT a.TMCID, a.PCCID, a.FailAmount, a.[Name], 1,
                3, @DocID, a.isMajorTMC, StatusID, a.PCCID
            FROM #WPProduce a
            WHERE a.FailAmount > 0 AND a.isMajorTMC = 0 AND a.IsDeleted = 0
            
            UNION
            
            SELECT @TMCID, @PCCID, @FailAmount, Name, 1, 3, @DocID, 1, @StatusID, @PCCID
            FROM TMC 
            WHERE ID = @TMCID AND @FailAmount > 0 AND @OutProdClass <> 3
           
            UNION
            
            SELECT TOP 1 e.TmcID, @PCCID, @FailAmount, t.Name, 1, 3, @DocID, 1, @StatusID, @PCCID
            FROM #ProductOutEmployees e
            INNER JOIN Tmc t ON t.ID = e.TmcID
            WHERE @OutProdClass = 4 AND @FailAmount > 0
            
            UNION
            
            SELECT @TMCID, @PCCID, @FailAmount, t.Name, 1, 3, @DocID, 0, @StatusID, @PCCID
            FROM Tmc t 
            WHERE ID = @TMCID AND @OutProdClass = 3 AND @FailAmount > 0                      
        END
        
        SELECT @DocID
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO