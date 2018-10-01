SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuiriy$    $Create date:   06.01.2017$
--$Modify:     Oleynik Yuiriy$    $Modify date:   06.01.2017$
--$Version:    1.00$   $Description: выборка по срабатыванию формул технологических операций$
CREATE PROCEDURE [dbo].[sp_TechOperations_AutoCreate]
    @ID Int, -- идентификатор заказного листа
    @RecreateType bit = 0
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int, @CardCountInvoice Int, @ObjectTypesMaterialsID Int, @CardCustomCount Int, @PVCPrintSide tinyint, @PVCFormat tinyint
    DECLARE @T TABLE(ID Int)

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
    IF OBJECT_ID('tempdb..#Params') IS NOT NULL
        DROP TABLE #Params

    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY
--        IF @RecreateType = 1 --cmrOk: 0 - leave materials;  cmrNo: 1 - recreate;
        DELETE FROM ProductionCardCustomizeMaterials
        WHERE ProductionCardCustomizeID = @ID
        
        --нужно пройтись по всем пропертис заказного листа, взять все материалы которые привязаны к этим значениям в дереве объектов.
        --далее для каждого материала вызвать динамический расчет нормы. Нормы в пределах одного материала сплюсовать
        --все сгенеренное вставить в таблицу деталей под айдишкой заказного листа.
        --DECLARE @ID int
        -- SET @ID = 10

        DECLARE @Query varchar(MAX), @ConsumptionRatesID Int, @TmcID int, @QueryParams varchar(MAX)
        SELECT 
            @CardCountInvoice = pc.CardCountInvoice, 
            @CardCustomCount = 0, 
            @TmcID = pc.TmcID,
            @QueryParams = '',
            @PVCPrintSide = ISNULL(pc.PVHPrintSide, 2),
            @PVCFormat = ISNULL(pc.PVHFormat, 2)
        FROM ProductionCardCustomize pc 
        WHERE pc.ID = @ID
        
        
        SELECT
           ' DECLARE ' + otDict.ParameterName + ' Decimal(38, 10) SET ' + otDict.ParameterName + '=' + ot.[Name] AS ParameterText,
           ' DECLARE ' + ot.ParameterName + ' Decimal(38, 10) SET ' + ot.ParameterName + '=' + ot.[Name] AS ParameterText2            
        INTO #Params
        FROM ProductionCardCustomizeProperties pccp
             LEFT JOIN ProductionCardCustomize pc ON pc.ID = pccp.ProductionCardCustomizeID
             LEFT JOIN vw_ProductionPropertiesSourceType ppst ON ppst.ID = pccp.SourceType -- фильтруем НЕ спекловские элементы дерева в WHERE.
             LEFT JOIN ProductionCardPropertiesHistoryDetails hd ON hd.ID = pccp.PropHistoryValueID
             INNER JOIN ObjectTypes ot ON ot.ID = hd.ObjectTypeID
             LEFT JOIN ObjectTypes otDict ON otDict.ID = ot.ParentID
        WHERE pccp.ProductionCardCustomizeID = @ID AND (ISNULL(otDict.ParameterName, '') <> '' OR ISNULL(ot.ParameterName, '') <> '')
            AND ppst.IsDefault = 1
        GROUP BY ot.[Name], ot.ParameterName, otDict.ParameterName            
        
        --данные для поиска рейтов
        SELECT 
            /*pccp.PropHistoryValueID,
            ot.[Name],
            pc.CreateDate,
            mat.BDate,
            mat.EDate,
            m.[Name] AS MaterialName,*/
            otDict.ParameterName,
            ' DECLARE ' + otDict.ParameterName + ' decimal(38,10) SET ' + otDict.ParameterName + ' = ' + ot.[Name] AS ParameterText,            
            NormaData.ID AS ObjectTypesMaterialsID/*,
            pc.CardCountInvoice*/
        INTO #TMP
        FROM ProductionCardCustomizeProperties pccp
        LEFT JOIN ProductionCardCustomize pc ON pc.ID = pccp.ProductionCardCustomizeID
        LEFT JOIN vw_ProductionPropertiesSourceType ppst ON ppst.ID = pccp.SourceType -- фильтруем НЕ спекловские элементы дерева в WHERE.
        LEFT JOIN ProductionCardPropertiesHistoryDetails hd ON hd.ID = pccp.PropHistoryValueID
        LEFT JOIN ObjectTypes ot ON ot.ID = hd.ObjectTypeID
        LEFT JOIN ObjectTypes otDict ON otDict.ID = ot.ParentID        
        LEFT JOIN (SELECT 
                      Normas.*,
                      otm.EndDate AS EDate
                  FROM 
                      (SELECT 
                          MAX(BeginDate) AS BDate,
                          ObjectTypeID,
                          TmcID,
                          GroupName
                      FROM ObjectTypesMaterials
                      WHERE BeginDate IS NOT NULL
                      GROUP BY ObjectTypeID, TmcID, GroupName) AS Normas
                  LEFT JOIN ObjectTypesMaterials otm ON otm.TmcID = Normas.TmcID
                     AND otm.ObjectTypeID = Normas.ObjectTypeID
                     AND otm.BeginDate = Normas.BDate
                     AND ISNULL(otm.GroupName,'') = ISNULL(Normas.GroupName,'')) AS mat ON
             mat.ObjectTypeID = ot.ID 
             AND pc.CreateDate BETWEEN mat.BDate AND ISNULL(mat.EDate, GetDate())
        LEFT JOIN Tmc t ON t.ID = mat.TmcID
        LEFT JOIN ObjectTypesMaterials AS NormaData ON NormaData.BeginDate = mat.BDate AND NormaData.TmcID = mat.TmcID AND NormaData.ObjectTypeID = ot.ID AND ISNULL(NormaData.GroupName, '') = ISNULL(mat.GroupName, '')
        WHERE pccp.ProductionCardCustomizeID = @ID AND ppst.IsDefault = 1 -- соб-но сам фильтр. выбираем только СПЕКЛ тех параметры
        
        SET @QueryParams = ''
        SELECT @QueryParams = @QueryParams + CHAR(13) + CHAR(10) + ISNULL(ParameterText, '') + 
                                           + CHAR(13) + CHAR(10) + ISNULL(ParameterText2, '')
        FROM #Params

        CREATE TABLE #Res(TmcID Int, Norma Decimal(38, 10), GroupName varchar(255))
        DECLARE @HasConditions bit, @CanUseFormula bit
        --курсор по всем попавшимся нормам в установленных пропертях в заказном листе.
        DECLARE #Cur CURSOR FOR SELECT ObjectTypesMaterialsID FROM #TMP WHERE ObjectTypesMaterialsID IS NOT NULL
        OPEN #Cur
        FETCH NEXT FROM #Cur INTO @ObjectTypesMaterialsID
        WHILE @@FETCH_STATUS = 0
        BEGIN
            --вложенный курсор беагем по самим формулам, ищем ту оторая даст равенство по условиям срабатывания
            DECLARE #CurRates CURSOR FOR SELECT ID FROM ConsumptionRates WHERE ObjectTypesMaterialID = @ObjectTypesMaterialsID
            OPEN #CurRates
            FETCH NEXT FROM #CurRates INTO @ConsumptionRatesID
            WHILE @@FETCH_STATUS = 0
            BEGIN
                --проверка - поиск совпадения условий, если есть записи, значит попались Рейт детали которых нет в заказном.
                --Если деталей нет - значит что работает условие "для всех" случаев, когда в детялях формулы ничего не указали
                --Если есть детали имеет смысл их проверить.
                --если нет тубо берем формулу    
                IF EXISTS(SELECT * FROM ConsumptionRatesDetails WHERE ConsumptionRateID = @ConsumptionRatesID)
                    SET @HasConditions = 1
                ELSE
                    SET @HasConditions = 0
                
                IF @HasConditions = 1
                    IF NOT EXISTS
                         (SELECT 
                              pccp.ID,
                              crd.ID
                          FROM (SELECT ID, PropHistoryValueID 
                                FROM ProductionCardCustomizeProperties
                                WHERE ProductionCardCustomizeID = @ID) pccp
                               INNER JOIN ProductionCardPropertiesHistoryDetails hd ON hd.ID = pccp.PropHistoryValueID
                               FULL JOIN ConsumptionRatesDetails crd ON crd.ObjectTypeID = hd.ObjectTypeID
                          WHERE pccp.ID IS NULL AND crd.ConsumptionRateID = @ConsumptionRatesID AND IsNull(crd.Negation,0) = 0
                          UNION ALL
                          /*Negation*/                          
						  SELECT pccp.ID, crd.ID
                          FROM (SELECT ID, PropHistoryValueID 
                                FROM ProductionCardCustomizeProperties
                                WHERE ProductionCardCustomizeID = @ID) pccp 
                               INNER JOIN ProductionCardPropertiesHistoryDetails hd ON hd.ID = pccp.PropHistoryValueID
                               FULL JOIN ConsumptionRatesDetails crd ON crd.ObjectTypeID = hd.ObjectTypeID
                          WHERE pccp.PropHistoryValueID IS NOT NULL AND crd.ConsumptionRateID = @ConsumptionRatesID AND IsNull(crd.Negation,0) = 1)
                    BEGIN
                        SET @CanUseFormula = 1
                    END
                    ELSE
                    BEGIN
                        SET @CanUseFormula = 0
                    END
                ELSE
                     SET @CanUseFormula = 1
                        
                        
                IF @CanUseFormula = 1 
                BEGIN --вызов расчета. Вложенный запрос мультипликатор * должен вернуть наибольшее количество встречающихся комбинаций
                    --поидее должно быть всегда 1, но возможны варианты, так как не исследовано. Идеология:
                    -- по всем детаям @ConsumptionRatesID берется каунт GROUP BY ObjectTypeID. 
                    SELECT @Query = CAST('DECLARE @Count Decimal(38, 10), @C_Count decimal(38,10), @ID int, @PVCPrintSide tinyint, @PVCFormat tinyint ' AS Varchar(MAX)) + Char(13) + Char(10) +
                        @QueryParams + Char(13) + Char(10) +
                        ' SELECT @Count = ' + CAST(@CardCountInvoice AS Varchar) + 
                               ', @C_Count = ' + CAST(@CardCustomCount AS Varchar) + 
                               ', @ID = ' + CAST(@ID AS Varchar) +
                               ', @PVCPrintSide = ' + CAST(@PVCPrintSide AS Varchar) + 
                               ', @PVCFormat = ' + CAST(@PVCFormat AS Varchar) + ' ' +  Char(13) + Char(10) +
                        ' INSERT INTO #Res(Norma, TmcID, GroupName) ' +
                        ' SELECT CAST(' + LTRIM(RTRIM(ISNULL(dbo.fn_ComposeFormula(cr.Script), 0))) + ' * ' + 
                        CAST( ISNULL(
                             (SELECT MAX(MaxCount.cnt)
                              FROM
                               (SELECT CASE WHEN COUNT(pccp.ID) = 0 THEN 1 ELSE COUNT(pccp.ID) END AS cnt
                               FROM ProductionCardCustomizeProperties pccp
                               INNER JOIN ProductionCardPropertiesHistoryDetails hd ON hd.ID = pccp.PropHistoryValueID
                               INNER JOIN ProductionCardCustomize pc ON pc.ID = pccp.ProductionCardCustomizeID
                               INNER JOIN ConsumptionRatesDetails crd ON crd.ObjectTypeID = hd.ObjectTypeID AND crd.ConsumptionRateID = cr.ID
                               WHERE pc.ID = @ID AND hd.ObjectTypeID = crd.ObjectTypeID
                                     AND IsNull(crd.Negation,0) = 0                                 
                               GROUP BY hd.ObjectTypeID) AS MaxCount), 1)
                         AS Varchar) +
                        ' AS Decimal(38, 10)), ' + CAST(otm.TmcID AS Varchar) + ', ' + ISNULL('''' + otm.GroupName + '''', 'NULL')
                    FROM ConsumptionRates cr                    
                    INNER JOIN ObjectTypesMaterials otm ON otm.ID = cr.ObjectTypesMaterialID
                    WHERE cr.ID = @ConsumptionRatesID
                    
                    --SELECT @Query
                    EXEC(@Query)
                END

                FETCH NEXT FROM #CurRates INTO @ConsumptionRatesID
            END
            CLOSE #CurRates
            DEALLOCATE #CurRates
              
            FETCH NEXT FROM #Cur INTO @ObjectTypesMaterialsID
        END
        CLOSE #Cur
        DEALLOCATE #Cur

        --смотрим крыжик
        --если все чистить, значит просто делаем чвсе что было ранее.
        --если апдейтить, то нужно добавить новые, потом проапдейтить старые.
        IF @RecreateType = 1
        BEGIN
            INSERT INTO ProductionCardCustomizeMaterials(ProductionCardCustomizeID, TmcID, [Norma], OriginalNorma)
            SELECT @ID, TmcID, SUM(ISNULL(Norma,0)), SUM(ISNULL(Norma,0))
            FROM #Res
            WHERE Norma <> 0
            GROUP BY TmcID, GroupName
            
            /*вставка давальческого, закупочного сырья, а так же комплектов сборки*/
            INSERT INTO ProductionCardCustomizeMaterials(ProductionCardCustomizeID, TmcID, [Norma], OriginalNorma)
            SELECT @ID, pccd.TmcID, SUM(ISNULL(pccd.Norma*@CardCountInvoice,0)), SUM(ISNULL(pccd.Norma*@CardCountInvoice,0))
            FROM ProductionCardCustomizeDetails pccd
            WHERE pccd.ProductionCardCustomizeID = @ID AND pccd.TmcID IS NOT NULL
            GROUP BY pccd.TmcID
        END
        ELSE
        IF @RecreateType = 0
        BEGIN
            --обнуляем удаленные, это обнулит и комплекты.
            UPDATE m
            SET m.OriginalNorma = 0
            FROM ProductionCardCustomizeMaterials m
            LEFT JOIN #Res a ON m.TmcID = a.TmcID
            WHERE a.TmcID IS NULL AND m.ProductionCardCustomizeID = @ID
            
            --вставляем новые
            INSERT INTO ProductionCardCustomizeMaterials(ProductionCardCustomizeID, TmcID, [Norma], OriginalNorma)
            SELECT @ID, a.TmcID, SUM(ISNULL(a.Norma,0)), SUM(ISNULL(a.Norma,0))
            FROM #Res a
            LEFT JOIN ProductionCardCustomizeMaterials m ON m.ProductionCardCustomizeID = @ID AND m.TmcID = a.TmcID
            WHERE a.Norma <> 0 AND m.ID IS NULL
            GROUP BY a.TmcID
            --апдейтим 
            UPDATE m
            SET m.OriginalNorma = upd.Summa
            FROM ProductionCardCustomizeMaterials m
            INNER JOIN (SELECT SUM(ISNULL(a.Norma,0)) AS Summa, a.TmcID
                        FROM ProductionCardCustomizeMaterials m
                        INNER JOIN #Res a ON m.TmcID = a.TmcID AND a.Norma <> 0
                        WHERE a.Norma <> 0 AND m.ID IS NULL
                        GROUP BY a.TmcID) upd ON upd.TmcID = m.TmcID

            /*апдейт давальческого, закупочного сырья, а так же комплектов сборки*/
            UPDATE m
            SET m.OriginalNorma = ISNULL(pccd.Norma*@CardCountInvoice,0)
            FROM ProductionCardCustomizeMaterials m
            INNER JOIN ProductionCardCustomizeDetails pccd ON pccd.TmcID = m.TmcID
            WHERE pccd.ProductionCardCustomizeID = @ID AND pccd.TmcID IS NOT NULL

            /*вставка давальческого, закупочного сырья, а так же комплектов сборки*/
            INSERT INTO ProductionCardCustomizeMaterials(ProductionCardCustomizeID, TmcID, [Norma], OriginalNorma)
            SELECT @ID, pccd.TmcID, SUM(ISNULL(pccd.Norma*@CardCountInvoice,0)), SUM(ISNULL(pccd.Norma*@CardCountInvoice,0))
            FROM ProductionCardCustomizeDetails pccd
            LEFT JOIN ProductionCardCustomizeMaterials mat ON mat.ProductionCardCustomizeID = @ID AND mat.TmcID = pccd.TmcID
            WHERE pccd.ProductionCardCustomizeID = @ID AND pccd.TmcID IS NOT NULL AND mat.ID IS NULL
            GROUP BY pccd.TmcID
        END

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
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO