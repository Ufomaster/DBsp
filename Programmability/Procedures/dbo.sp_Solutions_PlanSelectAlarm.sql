SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   01.04.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   12.04.2011$
--$Version:    1.00$   $Description: Выборка плана на текущий день, алярм$
CREATE PROCEDURE [dbo].[sp_Solutions_PlanSelectAlarm]
    @DepartmentID Int = 0
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @FutureDate Datetime, @StartDate Datetime, @DateTime Datetime
    SET @FutureDate = CAST(CONVERT(Varchar(8), GETDATE(), 112) AS Datetime)
    SET @StartDate = @FutureDate

    DECLARE @ID Int, @Days Int, @Name Varchar(2000), @Type Int, @DateDiff Float, @CloseDate Datetime
                               
    CREATE TABLE #Res(ID Int)

    DECLARE #Cur CURSOR FOR SELECT sp.ID, sp.Days, sp.[Name], sp.[Type], ISNULL(sp.CloseDate, @FutureDate)
                            FROM SolutionsPlanned sp
                            WHERE sp.[Date] <= @FutureDate
                                AND (sp.CloseDate IS NULL OR sp.CloseDate >= @StartDate) AND ((sp.[Date] > @StartDate AND sp.[Type] = 0 ) OR sp.[Type] <> 0)
                                AND (@DepartmentID = 0 OR sp.DepartmentID = @DepartmentID)
    OPEN #Cur
    FETCH FROM #Cur INTO @ID, @Days, @Name, @Type, @CloseDate
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @DateTime = a.[Date] FROM SolutionsPlanned a WHERE ID = @ID
        
        IF @Type = 1 --только для типа периодических работ, по дням
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

            SELECT @DateTime = DATEADD(mm, CEILING(@DateDiff/@Days)/*+1*/*@Days, @DateTime) --инкрементим на х месяцев 
        END
        
        IF DAY(@DateTime) = DAY(@FutureDate) AND MONTH(@DateTime) = MONTH(@FutureDate) AND @DateTime <= @CloseDate
            INSERT INTO #Res(ID)
            VALUES(@ID)

        FETCH NEXT FROM #Cur INTO @ID, @Days, @Name, @Type, @CloseDate
    END
    CLOSE #Cur
    DEALLOCATE #Cur
--                            LEFT JOIN Solutions s ON sp.ID = s.SolutionPlanID AND sp.[Date] = s.[Date]
-- where s.ID IS NULL
    SELECT
        sp.ID,
        sp.Days,
        @FutureDate AS [Date],
        sp.[Name]
    FROM #Res a
    INNER JOIN SolutionsPlanned sp ON a.ID = sp.ID
    LEFT JOIN Solutions s ON s.SolutionPlanID = sp.ID AND s.[Status] = 1 AND
        sp.[Type] = CASE
                       WHEN sp.[Type] = 1 AND s.[Date] > @FutureDate - sp.Days AND s.[Date] <= @FutureDate + sp.Days THEN 1
                       WHEN sp.[Type] = 2 AND s.[Date] > DATEADD(mm, - sp.Days, @FutureDate) AND s.[Date] <= DATEADD(mm, sp.Days, @FutureDate) THEN 2
                       WHEN sp.[Type] = 0 AND s.[Date] = @FutureDate THEN 0
                    ELSE 100
                    END
    WHERE s.ID IS NULL

    DROP TABLE #Res
END
GO