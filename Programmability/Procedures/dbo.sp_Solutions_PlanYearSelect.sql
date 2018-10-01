SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   14.07.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   14.08.2015$
--$Version:    1.00$   $Description: Выборка плана$
CREATE PROCEDURE [dbo].[sp_Solutions_PlanYearSelect]
    @TargetID Int = 0,
    @DisplacementValue Int = 0
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @FutureDate Datetime, @StartDate Datetime, @DateTime Datetime, @inc Int, 
        @Style Int, @TotalMonth Int, @DateDiff Float, @CloseDate Datetime
    
    SET @TotalMonth = 12
    
    --возьмем дату на 5 месяцев + 1 мес вперед. И сделаем дату на 1-е число последнего шестого месяца
    SELECT @FutureDate = DATEADD(m, 6 + @DisplacementValue, CAST(CAST(MONTH(GETDATE()) AS Varchar) + '.01.' + CAST(YEAR(GETDATE()) AS Varchar) AS Datetime))        
    --Отнимем 1 день получим дату конца 5-го месяца    
    SELECT @FutureDate = DATEADD(d, -1, @FutureDate)
    --отнимем 12 месяцев и + 1 день - получим год разницы между датами.
    
    SET @StartDate = DATEADD(m, -@TotalMonth, DATEADD(d, 1, @FutureDate))

--    SELECT @StartDate, @FutureDate, DATEDIFF(dd, @FutureDate, @StartDate)  return

    DECLARE @i Int, @ID Int, @Days Int, @Name Varchar(2000), @Type Int, @Query Varchar(5000), @SelectQuery Varchar(MAX)

    --конструируем резалт таблицу
    CREATE TABLE #Res(ID Int, NAME Varchar(2000) NULL)
    SET @i = 1
    WHILE @i <= @TotalMonth
    BEGIN
        EXEC('ALTER TABLE #Res ADD M' +@i+' int NULL, Style' + @i + ' int NULL')
        SET @i = @i + 1
    END
    
CREATE TABLE #aaa(num Int, Style Int, Date_Time Datetime, StartDate Datetime, ID Int)

    --выберем все плановые работы которые попадают в этот период.
    DECLARE #Cur CURSOR FOR SELECT ID, Days, [Name], [Type], ISNULL(CloseDate, @FutureDate)
                            FROM SolutionsPlanned
                            WHERE ([Date] <= @FutureDate) 
                                AND ( --чтобы включить концы @StartDate-1, и взять дату попадающую то +1(), так ак FLOOR - это минимум без остатка
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
        INSERT INTO #Res(ID, [Name])
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
            --(тут нуно проверить начлииче остатка и плюсовнуть еденицу, если он есть, это по сути делает нам CEILING)
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
                SET @i = 12 --вне периода - выход просто
            --Далее нужно найти нашу дату в таблице. И начать постить даныне с приодичностью, до конца приода.
        END
    --    ELSE
            --иначе старт попадает в наш период и ничего считать не нужно
            --SELECT @DateTime = @DateTime

        WHILE @i <= @TotalMonth
        BEGIN
            --бежим в цикле по месяцам, смотрим, если наша дата совпала  с расчетной, апдейтим иначе далее.
            --бег начинаем с инкремента 1, а после первого нахождения даты, следует уже прыгать со скоростью @Days               
                
/*                INSERT INTO #aaa(num, Style , Date_Time, StartDate , ID)
                SELECT MONTH(@DateTime), @i, @DateTime, @StartDate, MONTH(DATEADD(mm, @i-1, @StartDate))*/
                                 
            IF MONTH(@DateTime) = MONTH(DATEADD(mm, @i-1, @StartDate)) AND @DateTime <= @CloseDate
            BEGIN
                --если покрыто работой, стиль 2 - зелёный
                SELECT 
                    @Style = CASE WHEN MIN(s.[Status]) = 0 THEN 3 WHEN MIN(s.[Status]) = 1 THEN 2 END --0-выполняется, 1-выполнена
                FROM dbo.Solutions s
                WHERE s.SolutionPlanID = @ID AND s.[Date] = @DateTime
                GROUP BY s.SolutionPlanID

                -- если работой не покрыто смотрим, если до текущей даты - то профукано, если после - запланировано
                IF @Style IS NULL
                    IF @DateTime <= GETDATE()
                        SET @Style = 1 --желтый - профукано
                    ELSE
                        SET @Style = 0 --синий - в будущем

                -- нашли дату, увеличиваем икрементор, постим данные, и обновляем нашу расчетную дату
                --для одноразовой работы и подневной, икрементор = @Days. а для помесячной,
                -- нужно фактически выпрыгнуть за рамки периода
                IF @Type = 2
                    SELECT @inc = DATEDIFF(dd, @DateTime, DATEADD(mm, @Days, @DateTime))
                ELSE
                    SET @inc = @Days
                
                SELECT @Query = 'UPDATE #Res SET Style' + CAST(@I AS Varchar) + ' = ' + CAST(@Style AS Varchar) + ' WHERE ID = ' + CAST(@ID AS Varchar)
                EXEC(@Query)
                -- но, если тип - подневный. следующую дату нужно взять из следующего месяца, 
                -- для этого нкрементим дату до перехода в след месяц.
                
                IF @Type = 1
                BEGIN
                    --тут инкрементор всегда содержит кол-во дней для всех типов.
                    WHILE MONTH(@DateTime) = MONTH(DATEADD(dd, @inc, @DateTime))
                    BEGIN
                        SELECT @DateTime = DATEADD(dd, @inc, @DateTime)
                    END
                    SELECT @DateTime = DATEADD(dd, @inc, @DateTime)
                END
                ELSE
                    --тут инкрементор всегда содержит кол-во дней для всех типов.
                    SELECT @DateTime = DATEADD(dd, @inc, @DateTime)

                SET @Style = NULL
                IF @Type = 0 --если одноразовая работа, выходим из цикла
                    SET @I = @TotalMonth + 1
            END
            SET @i = @i + 1
        END

        FETCH NEXT FROM #Cur INTO @ID, @Days, @Name, @Type, @CloseDate
    END
    CLOSE #Cur
    DEALLOCATE #Cur

    SET @SelectQuery = ''

    SET @i = 1
    WHILE @i <= 12
    BEGIN
    --    SELECT @Query = 'UPDATE #Res SET D' + CAST(@I AS VARCHAR) + ' = ''' + CONVERT(varchar, @StartDate + @i-1, 101) + '''  '
        SELECT @SelectQuery = @SelectQuery + ', r.Style' + CAST(@I AS Varchar) + ' AS [' + mn.[Name] + ' ' + CAST(Year(@StartDate) AS Varchar) + ']'
        FROM vw_MonthNames mn
        WHERE mn.ID = MONTH(@StartDate)
        
    --    EXEC(@Query)
        SET @StartDate = DATEADD(m, 1, @StartDate)
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
    --SELECT * FROM #aaa
    DROP TABLE #aaa
    DROP TABLE #Res
END
GO