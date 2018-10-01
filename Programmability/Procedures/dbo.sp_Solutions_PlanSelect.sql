SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   23.03.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   14.08.2015$
--$Version:    1.00$   $Description: Выборка плана$
CREATE PROCEDURE [dbo].[sp_Solutions_PlanSelect]
    @TargetID Int = 0,
    @DisplacementValue Int = 0
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @FutureDate Datetime, @StartDate Datetime, @DateTime Datetime, @inc Int, 
        @Style Int, @TotalDays Int, @DateDiff Float, @CloseDate Datetime
    
    SET @TotalDays = 31
    
    SELECT @FutureDate = dbo.fn_DateCropTime(GETDATE() + 15 + @DisplacementValue)
    SET @StartDate = @FutureDate - @TotalDays + 1

--    SELECT @StartDate, @FutureDate, DATEDIFF(dd, @FutureDate, @StartDate)  return

    DECLARE @i Int, @ID Int, @Days Int, @Name Varchar(2000), @Type Int, @Query Varchar(5000), @SelectQuery Varchar(MAX)

    --конструируем резалт таблицу
    CREATE TABLE #Res(ID Int, NAME Varchar(2000) NULL)
    SET @i = 1
    WHILE @i <= @TotalDays
    BEGIN
        EXEC('ALTER TABLE #Res ADD D' +@i+' DateTime NULL, Style' + @i + ' int NULL')
        SET @i = @i + 1
    END

    DECLARE #Cur CURSOR FOR SELECT ID, Days, [Name], [Type], ISNULL(CloseDate, @FutureDate)
                            FROM SolutionsPlanned
                            WHERE ([Date] <= @FutureDate) 
                                AND ( --чтобы включить концы @StartDate-1, и взять дату попадающую то +1(), так ак FLOOR - это без остатка
                                      ([Type] = 1 AND [Date] + FLOOR(DATEDIFF(dd, [Date], @StartDate-1)/Days+1)*Days >= @StartDate)
                                    OR --для месячного периода отталкиваемся от конца. проверяем день чтобы новая дата не выпрыгнула из периода вперед
                                      ([Type] = 2 AND DATEADD(mm, FLOOR(DATEDIFF(mm, [Date], @FutureDate)/Days)*Days + 
                                                              CASE 
                                                                  WHEN DAY([Date]) >= DAY(@StartDate) OR MONTH([Date]) > MONTH(@StartDate) OR DAY([Date]) <= DAY(@FutureDate) THEN 0
                                                              ELSE Days
                                                              END, [Date]) BETWEEN @StartDate AND @FutureDate)
                                    OR
                                      ([Type] = 0 AND [Date] > @StartDate)
                                    )                                    
                                AND (CloseDate IS NULL OR CloseDate >= @StartDate) 
                                AND (@TargetID = 0 OR TargetID = @TargetID)
    OPEN #Cur
    FETCH FROM #Cur INTO @ID, @Days, @Name, @Type, @CloseDate
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO #Res(ID, NAME)
        VALUES(@ID, @Name)

        SELECT @DateTime = a.[Date] FROM SolutionsPlanned a WHERE ID = @ID

        SET @i = 1
        SET @inc = 1
        
        IF (@DateTime < @StartDate)
        BEGIN
            --нужно посчитать первую дату периодического выполнения которая попадает в наш промежуток.
            --алгоритм простой, берём разницу в днях между датой создания и стартовой датой периода, делим на периодичность, 
            --получаем сколько раз уже сработала задача, целым числом. DATEDIFF(dd, @DateTime, @StartDate)/@Days)
            --далее нужно увеличить на 1 период, чтобы дата влезла в период 
            --(тут нуно проверить налииче остатка и плюсовнуть еденицу, если он есть, это по сути делает нам CEILING)
            --и инкрементнуть дату на х дней, х равнен кол-ву периодов умноженному на периодичность @Days
            IF @Type = 1 -- только для типа периодических работ, по дням
            BEGIN
                SELECT @DateDiff = DATEDIFF(dd, @DateTime, @StartDate)
                SELECT @DateTime = DATEADD(dd, CEILING(@DateDiff/@Days)/*+1*/*@Days, @DateTime)
            END
            ELSE
            IF @Type = 2 -- только для типа периодических работ, по месяцам
            BEGIN
                -- тут CEILING проблемы не решает, поэтому в ручном режиме.
                SELECT @DateDiff = DATEDIFF(mm, @DateTime, @StartDate) -- разница в месяцах, минимум 1 будет наврено
                IF DAY(@StartDate) > DAY(@DateTime) --если день стартовой даты больше дня нашего, тогда это фактически 1 с кусочком месяц. То есть надо взять 2.
                    SELECT @DateDiff = @DateDiff + 1
--              ELSE
--                  SELECT @DateDiff = @DateDiff
                SELECT @DateTime = DATEADD(mm, CEILING(@DateDiff/@Days)/*+1*/*@Days, @DateTime) --инкрементим на х месяцев 
            END            
            ELSE
                SET @i = 31 --вне периода - выход просто
            --Далее нужно найти нашу дату в таблице. И начать постить даныне с приодичностью, до конца приода.
        END
    --    ELSE
            --иначе старт попадает в наш период и ничего считать не нужно
            --SELECT @DateTime = @DateTime


        WHILE @i <= @TotalDays
        BEGIN
            --бежим в цикле по дням, смотрим, если наша дата совпала  с расчетвной, апдейтим иначе далее.
            --бег начинаем с инкремента 1, а после первого нахождения даты, следует уже прыгать со скоростью @Days
            IF DAY(@DateTime) = DAY(@StartDate + @i-1) AND MONTH(@DateTime) = MONTH(@StartDate + @i-1) AND @DateTime <= @CloseDate
            BEGIN
                --если покрыто работой, стиль 2 - зелёный, работа в статусе Ожидание - 4-красный
                SELECT 
                    @Style = CASE
                                 WHEN s.[Status] = 2 THEN 4
                                 WHEN s.[Status] = 1 THEN 2
                                 WHEN s.[Status] = 0 THEN 3
                             END 
                FROM dbo.Solutions s                                                           
                WHERE s.SolutionPlanID = @ID AND (
                   --для типа "Одноразованя работа". даём 3 дня.
                  (@Type = 0 AND s.[Date] BETWEEN @DateTime AND @DateTime + 3 - 1)
                  OR -- тут икрементимся по дням.
                  (@Type = 1 AND s.[Date] BETWEEN @DateTime AND @DateTime + @Days - 1)
                  OR -- а тут по месяцам. -1 нужно проверить как-то.
                  (@Type = 2 AND s.[Date] BETWEEN @DateTime AND DATEADD(mm, @Days, @DateTime - 1))
                                                 )
                -- если работой не покрыто смотрим, если до текущей даты - то профукано, если после - запланировано
                IF @Style IS NULL
                    IF @DateTime < GETDATE()
                        SET @Style = 1 --желтый - профукано
                    ELSE
                        SET @Style = 0 --синий - в будущем
                
                -- нашли дату, увеличиваем икрементор, постим данные, и обновляем нашу расчетную дату
                --для одноразовой работы и подневной, икрементор = @Days. а для помесячной,
                -- нужно фактически выпрыгнуть за рамки периода, поэтому смело добавим 40 дней, чтобы вылететь из цикла
                IF @Type = 2
                    SELECT @inc = DATEDIFF(dd, @DateTime, DATEADD(mm, @Days, @DateTime))
                ELSE
                    SET @inc = @Days
                    
                SELECT @Query = 'UPDATE #Res SET Style' + CAST(@I AS Varchar) + ' = ' + CAST(@Style AS Varchar) + ' WHERE ID = ' + CAST(@ID AS Varchar)
                EXEC(@Query)
                --тут @inc содежрит кол-во дней для всех типов.
                SELECT @DateTime = DATEADD(dd, @inc, @DateTime)
                                   
/*                SELECT @DateTime = CASE 
                                       WHEN @Type = 2 THEN DATEADD(mm, @Days, @DateTime) 
                                   ELSE DATEADD(dd, @Days, @DateTime) 
                                   END*/
                SET @Style = NULL
                IF @Type = 0 --если одноразовая работа, выходим из цикла
                    SET @I = @TotalDays + 1
            END

            SET @i = @i + @inc
        END

        FETCH NEXT FROM #Cur INTO @ID, @Days, @Name, @Type, @CloseDate
    END
    CLOSE #Cur
    DEALLOCATE #Cur

    SET @SelectQuery = ''

    SET @i = 1
    WHILE @i <= @TotalDays
    BEGIN
    --    SELECT @Query = 'UPDATE #Res SET D' + CAST(@I AS VARCHAR) + ' = ''' + CONVERT(varchar, @StartDate + @i-1, 101) + '''  '
        SELECT @SelectQuery = @SelectQuery + ', r.Style' + CAST(@I AS Varchar) + ' AS [' + CONVERT(Varchar, @StartDate + @i-1, 104) + ']'
    --    EXEC(@Query)
        SET @i = @i + 1
    END
      
    SELECT @SelectQuery = '
SELECT 
    r.ID, 
    r.Name AS [Описание работы],
    ot.Name + '' - '' + t.Name + '' (инв № '' + e.InventoryNum + '')'' AS [Оборудование]' + @SelectQuery + '
FROM #Res r 
LEFT JOIN SolutionsPlanned sp ON sp.ID = r.ID
LEFT JOIN Equipment e ON sp.EquipmentID = e.ID 
LEFT JOIN Tmc t ON t.ID = e.TmcID
LEFT JOIN ObjectTypes ot ON ot.ID = t.ObjectTypeID'
    EXEC(@SelectQuery)
    --select @SelectQuery
    --SELECT * FROM #Res

    DROP TABLE #Res
END
GO