SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuiriy$    $Create date:   06.01.2017$
--$Modify:     Oleynik Yuiriy$    $Modify date:   02.11.2017$
--$Version:    1.00$   $Description: выборка по срабатыванию формул технологических операций$
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeTechOps_AutoCreate]
    @ID Int, -- идентификатор заказного листа
    @EmployeeID int,
    @RecreateType int = 0
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int, @CardCountInvoice Int, @TechOperationID int
    DECLARE @T TABLE(ID Int)

    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
        IF @RecreateType = 1 --cmrOk: 0 - leave materials;  cmrNo: 1 - recreate;
            DELETE FROM ProductionCardCustomizeTechOp
            WHERE ProductionCardCustomizeID = @ID

        DECLARE @Query varchar(MAX), @ConsumptionRatesID Int
        SELECT
            @CardCountInvoice = pc.CardCountInvoice
        FROM ProductionCardCustomize pc
        WHERE pc.ID = @ID

        --данные для поиска рейтов
        SELECT
            cr.ID
        INTO #TMP
        FROM ConsumptionRates cr
        INNER JOIN ConsumptionRatesDetails cd ON cd.ConsumptionRateID = cr.ID
        LEFT JOIN ProductionCardPropertiesHistoryDetails hd ON hd.ObjectTypeID = cd.ObjectTypeID 
           AND hd.ID IN (SELECT pccp.PropHistoryValueID
                         FROM ProductionCardCustomizeProperties pccp
                         LEFT JOIN vw_ProductionPropertiesSourceType ppst ON ppst.ID = pccp.SourceType -- фильтруем НЕ спекловские элементы дерева в WHERE  
                         WHERE pccp.ProductionCardCustomizeID = @ID AND ppst.IsDefault = 1) -- соб-но сам фильтр. выбираем только СПЕКЛ тех параметры
        WHERE cr.TechOperationID IS NOT NULL          
        GROUP BY cr.ID
        UNION
        SELECT
            cr.ID
        FROM ConsumptionRates cr
        LEFT JOIN ConsumptionRatesDetails cd ON cd.ConsumptionRateID = cr.ID
        WHERE cd.ID IS NULL AND cr.TechOperationID IS NOT NULL

        CREATE TABLE #Res(TechOperationID Int, Amount Decimal(38, 10))

        DECLARE @HasConditions bit, @CanUseFormula bit

        DECLARE #Cur CURSOR FOR SELECT ID FROM #TMP
        OPEN #Cur
        FETCH NEXT FROM #Cur INTO @ConsumptionRatesID
        WHILE @@FETCH_STATUS = 0
        BEGIN
            IF EXISTS(SELECT * FROM ConsumptionRatesDetails WHERE ConsumptionRateID = @ConsumptionRatesID)
                SET @HasConditions = 1
            ELSE
                SET @HasConditions = 0

            IF @HasConditions = 1
                IF NOT EXISTS(SELECT * FROM (            
                                SELECT hd.ObjectTypeID AS L_ObjectTypeID, cd.ObjectTypeID AS R_ObjectTypeID, cd.Negation
                                FROM ConsumptionRates cr
                                INNER JOIN ConsumptionRatesDetails cd ON cd.ConsumptionRateID = cr.ID
                                LEFT JOIN ProductionCardPropertiesHistoryDetails hd ON hd.ObjectTypeID = cd.ObjectTypeID 
                                   AND hd.ID IN (SELECT pccp.PropHistoryValueID 
                                                 FROM ProductionCardCustomizeProperties pccp
                                                 LEFT JOIN vw_ProductionPropertiesSourceType ppst ON ppst.ID = pccp.SourceType -- фильтруем НЕ спекловские элементы дерева в WHERE  
                                                 WHERE pccp.ProductionCardCustomizeID = @ID AND ppst.IsDefault = 1) -- соб-но сам фильтр. выбираем только СПЕКЛ тех параметры
                                WHERE cr.TechOperationID IS NOT NULL AND cr.ID = @ConsumptionRatesID
                                   ) res
                              WHERE (res.L_ObjectTypeID IS NOT NULL AND res.Negation = 1) OR (res.L_ObjectTypeID IS NULL AND res.Negation = 0)
                              )
                    SET @CanUseFormula = 1
                ELSE
                    SET @CanUseFormula = 0
            ELSE
                SET @CanUseFormula = 1

            IF @CanUseFormula = 1 
            BEGIN --вызов расчета.  
                SELECT @Query = CAST('DECLARE @Count Decimal(38, 10), @ID int ' AS Varchar(MAX)) + Char(13) + Char(10) +
                        ' SELECT @Count = ' + CAST(@CardCountInvoice AS Varchar) + 
                               ', @ID = ' + CAST(@ID AS Varchar) +
                        ' INSERT INTO #Res(Amount, TechOperationID) ' +
                        ' SELECT CAST(' + LTRIM(RTRIM(cr.Script)) + ' AS Decimal(38, 10)), ' 
                          + CAST(cr.TechOperationID AS Varchar)
                    FROM ConsumptionRates cr
                    WHERE cr.ID = @ConsumptionRatesID
                    --SELECT @Query
                    EXEC(@Query)
            END
            FETCH NEXT FROM #Cur INTO @ConsumptionRatesID
        END
        CLOSE #Cur
        DEALLOCATE #Cur

-------------------------------
        --смотрим крыжик
        --если все чистить, значит просто делаем чвсе что было ранее.
        --если апдейтить, то нужно добавить новые, потом проапдейтить старые.
        IF @RecreateType = 1
        BEGIN
            INSERT INTO ProductionCardCustomizeTechOp(ProductionCardCustomizeID, TechOperationID, Amount, EmployeeID, TechnologicalOperationID, StorageStructureSectorID)
            SELECT @ID, t.TechOperationID, SUM(ISNULL(t.Amount, 0)), @EmployeeID, ts.TechnologicalOperationID, ts.StorageStructureSectorID
            FROM #Res AS t
            INNER JOIN TechOperations ts ON ts.ID = t.TechOperationID
            WHERE t.Amount <> 0
            GROUP BY t.TechOperationID, ts.TechnologicalOperationID, ts.StorageStructureSectorID
        END
        ELSE
        IF @RecreateType = 0
        BEGIN
            --обнуляем удаленные
            UPDATE m
            SET m.Amount = 0
            FROM ProductionCardCustomizeTechOp m
            LEFT JOIN #Res a ON m.TechOperationID = a.TechOperationID
            WHERE a.TechOperationID IS NULL AND m.ProductionCardCustomizeID = @ID
            
            --вставляем новые
            INSERT INTO ProductionCardCustomizeTechOp(ProductionCardCustomizeID, TechOperationID, Amount, EmployeeID, TechnologicalOperationID, StorageStructureSectorID)
            SELECT @ID, a.TechOperationID, SUM(ISNULL(a.Amount, 0)), @EmployeeID, ts.TechnologicalOperationID, ts.StorageStructureSectorID
            FROM #Res a
            INNER JOIN TechOperations ts ON ts.ID = a.TechOperationID
            LEFT JOIN ProductionCardCustomizeTechOp m ON m.ProductionCardCustomizeID = @ID AND m.TechOperationID = a.TechOperationID
            WHERE a.Amount <> 0 AND m.ID IS NULL
            GROUP BY a.TechOperationID, ts.TechnologicalOperationID, ts.StorageStructureSectorID

            --апдейтим 
/*            UPDATE m
            SET m.Amount = upd.Amount
            FROM ProductionCardCustomizeTechOp m
            INNER JOIN (SELECT SUM(ISNULL(a.Amount,0)) AS Amount, a.TechOperationID
                        FROM ProductionCardCustomizeTechOp m
                        INNER JOIN #Res a ON m.TechOperationID = a.TechOperationID
                        WHERE a.Amount <> 0 AND m.ProductionCardCustomizeID = @ID
                        GROUP BY a.TechOperationID) upd ON upd.TechOperationID = m.TechOperationID
            WHERE m.ProductionCardCustomizeID = @ID*/
        END
------------------------
        DROP TABLE #Res
        DROP TABLE #TMP

        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF OBJECT_ID('tempdb..#CurRates') IS NOT NULL
            DEALLOCATE #CurRates
        IF OBJECT_ID('tempdb..#Cur') IS NOT NULL
            DEALLOCATE #Cur
        IF OBJECT_ID('tempdb..#Res') IS NOT NULL
            DROP TABLE #Res
        IF OBJECT_ID('tempdb..#TMP') IS NOT NULL
            DROP TABLE #TMP
        IF OBJECT_ID('tempdb..#TreeValues') IS NOT NULL
            DROP TABLE #TreeValues
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO