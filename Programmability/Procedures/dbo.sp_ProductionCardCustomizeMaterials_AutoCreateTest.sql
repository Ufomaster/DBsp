SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuiriy$    		$Create date:   14.06.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   06.10.2016$*/
/*$Version:    1.00$   $Description: Тест норм расхода$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeMaterials_AutoCreateTest]
    @CardCountInvoice Int,
    @TreeValuesArray Varchar(max)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Err Int, @ObjectTypesMaterialsID Int, @CardCustomCount Int, @CreateDate Datetime, @PVCPrintSide tinyint, @PVCFormat tinyint
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

        SET @CreateDate = GetDate()
        SELECT @PVCPrintSide = 2, @PVCFormat = 2
        
        CREATE TABLE #TreeValues(PropValueID Int)
        INSERT INTO #TreeValues(PropValueID)
        SELECT a.ID 
        FROM dbo.fn_StringToITable(@TreeValuesArray) a

        DECLARE @Query Varchar(MAX), @ConsumptionRatesID Int, @QueryParams varchar(MAX)
        
        SET @QueryParams = ''


        SELECT
           ' DECLARE ' + otDict.ParameterName + ' Decimal(38, 10) SET ' + otDict.ParameterName + '=' + ot.[Name] AS ParameterText,
           ' DECLARE ' + ot.ParameterName + ' Decimal(38, 10) SET ' + ot.ParameterName + '=' + ot.[Name] AS ParameterText2            
        INTO #Params
        FROM #TreeValues a
        INNER JOIN ProductionCardProperties Prop ON Prop.ID = a.PropValueID
        INNER JOIN ObjectTypes ot ON ot.ID = Prop.ObjectTypeID
        LEFT JOIN ObjectTypes otDict ON otDict.ID = ot.ParentID
        WHERE ISNULL(otDict.ParameterName, '') <> '' OR ISNULL(ot.ParameterName, '') <> ''
        GROUP BY ot.[Name], ot.ParameterName, otDict.ParameterName

        /*данные для поиска рейтов*/
        SELECT
            mat.ID AS ObjectTypesMaterialsID
        INTO #TMP
        FROM #TreeValues a
        INNER JOIN ProductionCardProperties Prop ON Prop.ID = a.PropValueID
        INNER JOIN ObjectTypes ot ON ot.ID = Prop.ObjectTypeID
        INNER JOIN (SELECT 
                      Normas.*,
                      otm.EndDate AS EDate,
                      otm.ID
                    FROM 
                      (SELECT 
                          MAX(ISNULL(BeginDate, @CreateDate)) AS BDate,
                          CASE WHEN MAX(ISNULL(BeginDate, @CreateDate)) = @CreateDate THEN 1 ELSE 0 END AS BDateType,
                          ObjectTypeID,
                          TmcID,
                          GroupName
                      FROM ObjectTypesMaterials /* берём все даже не опубликованные на тест BeginDate IS NOT NULL не проверяем*/
                      GROUP BY ObjectTypeID, TmcID, GroupName) AS Normas
                    LEFT JOIN ObjectTypesMaterials otm ON 
                         otm.TmcID = Normas.TmcID
                     AND otm.ObjectTypeID = Normas.ObjectTypeID
                     AND ISNULL(otm.GroupName,'') = ISNULL(Normas.GroupName,'')
                     AND (
                          (otm.BeginDate = Normas.BDate AND Normas.BDateType = 0) OR
                          (otm.BeginDate IS NULL AND Normas.BDateType = 1)
                         )
                      ) AS mat ON
             mat.ObjectTypeID = ot.ID 
             AND @CreateDate BETWEEN mat.BDate AND ISNULL(mat.EDate, @CreateDate)        

        SET @QueryParams = ''
        SELECT @QueryParams = @QueryParams + CHAR(13) + CHAR(10) + ISNULL(ParameterText, '') + 
                                           + CHAR(13) + CHAR(10) + ISNULL(ParameterText2, '')
        FROM #Params

        CREATE TABLE #Res(TmcID Int, Norma Decimal(38, 10), GroupName varchar(255))
        DECLARE @HasConditions Bit, @CanUseFormula Bit
        /*курсор по всем попавшимся нормам */
        DECLARE #Cur CURSOR FOR SELECT ObjectTypesMaterialsID FROM #TMP WHERE ObjectTypesMaterialsID IS NOT NULL
        OPEN #Cur
        FETCH NEXT FROM #Cur INTO @ObjectTypesMaterialsID
        WHILE @@FETCH_STATUS = 0
        BEGIN
            /*вложенный курсор беагем по самим формулам, ищем ту которая даст равенство по условиям срабатывания*/
            DECLARE #CurRates CURSOR FOR SELECT ID FROM ConsumptionRates WHERE ObjectTypesMaterialID = @ObjectTypesMaterialsID
            OPEN #CurRates
            FETCH NEXT FROM #CurRates INTO @ConsumptionRatesID
            WHILE @@FETCH_STATUS = 0
            BEGIN
                /*проверка - поиск совпадения условий, если есть записи, значит попались Рейт детали которых нет в заказном.*/
                /*Если деталей нет - значит что работает условие "для всех" случаев, когда в детялях формулы ничего не указали*/
                /*Если есть детали имеет смысл их проверить.*/
                /*если нет тупо берем формулу*/
                IF EXISTS(SELECT * FROM ConsumptionRatesDetails WHERE ConsumptionRateID = @ConsumptionRatesID)
                    SET @HasConditions = 1
                ELSE
                    SET @HasConditions = 0

                IF @HasConditions = 1
                    IF NOT EXISTS
                         (SELECT pccp.PropValueID, crd.ID
                          FROM #TreeValues pccp 
                               INNER JOIN ProductionCardProperties p ON p.ID = pccp.PropValueID
                               FULL JOIN ConsumptionRatesDetails crd ON crd.ObjectTypeID = p.ObjectTypeID
                          WHERE pccp.PropValueID IS NULL AND crd.ConsumptionRateID = @ConsumptionRatesID AND IsNull(crd.Negation,0) = 0
                          UNION ALL
                          /*Negation*/
                          SELECT pccp.PropValueID, crd.ID
                          FROM #TreeValues pccp 
                               INNER JOIN ProductionCardProperties p ON p.ID = pccp.PropValueID
                               FULL JOIN ConsumptionRatesDetails crd ON crd.ObjectTypeID = p.ObjectTypeID
                          WHERE pccp.PropValueID IS NOT NULL AND crd.ConsumptionRateID = @ConsumptionRatesID AND IsNull(crd.Negation,0) = 1
                          )
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
                BEGIN /*вызов расчета. Вложенный запрос мультипликатор * должен вернуть наибольшее количество встречающихся комбинаций*/
                    /*поидее должно быть всегда 1, но возможны варианты, так как не исследовано. Идеология:*/
                    /* по всем деталям @ConsumptionRatesID берется count GROUP BY ObjectTypeID. */
                    SELECT @Query = CAST('DECLARE @Count Decimal(38, 10), @C_Count decimal(38,10), @ID int, @PVCPrintSide tinyint, @PVCFormat tinyint ' AS Varchar(MAX)) +  Char(13) + Char(10) +
                               ' SET @PVCPrintSide = ' + CAST(@PVCPrintSide AS Varchar) + 
                               ' SET @PVCFormat = ' + CAST(@PVCFormat AS Varchar) + ' ' +  Char(13) + Char(10) +
                        @QueryParams + Char(13) + Char(10) +
                        ' SELECT @Count = ' + CAST(@CardCountInvoice AS Varchar) + ', @C_Count = ' + CAST(0 AS Varchar) + ', @ID = ' + CAST(-1 AS Varchar) + ' ' +  Char(13) + Char(10) +
                        ' INSERT INTO #Res(Norma, TmcID, GroupName) ' +
                        ' SELECT CAST(' + LTRIM(RTRIM(ISNULL(dbo.fn_ComposeFormula(cr.Script), 0))) + ' * ' + 
                        CAST( ISNULL(
                             (SELECT MAX(MaxCount.cnt)
                              FROM
                               (SELECT CASE WHEN COUNT(pccp.PropValueID) = 0 THEN 1 ELSE COUNT(pccp.PropValueID) END AS cnt
                               FROM #TreeValues pccp
                               INNER JOIN ProductionCardProperties hd ON hd.ID = pccp.PropValueID
                               INNER JOIN ConsumptionRatesDetails crd ON crd.ObjectTypeID = hd.ObjectTypeID AND crd.ConsumptionRateID = cr.ID
                               WHERE hd.ObjectTypeID = crd.ObjectTypeID
                                      AND IsNull(crd.Negation,0) = 0  
                               GROUP BY hd.ObjectTypeID) AS MaxCount), 1)
                         AS Varchar) +
                        ' AS Decimal(38, 10)), ' + CAST(otm.TmcID AS Varchar) + ', ' + ISNULL('''' + otm.GroupName + '''', 'NULL')
                    FROM ConsumptionRates cr                    
                    INNER JOIN ObjectTypesMaterials otm ON otm.ID = cr.ObjectTypesMaterialID
                    WHERE cr.ID = @ConsumptionRatesID
                    
                    /*SELECT @Query*/
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

        IF EXISTS(SELECT * FROM #Res)
            INSERT INTO #ProductionCardCustomizeMaterialsTest(TmcID, [Norma], NormaOnCount)
            SELECT TmcID, SUM(ISNULL(Norma,0)), SUM(ISNULL(Norma,0)) / @CardCountInvoice
            FROM #Res
            WHERE Norma <> 0
            GROUP BY TmcID, GroupName
            ORDER BY TmcID

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
        IF OBJECT_ID('tempdb..#Params') IS NOT NULL
            DROP TABLE #Params 
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO