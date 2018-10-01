SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   02.07.2015$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   02.07.2015$*/
/*$Version:    1.00$   $Decription: Выборка данных из таблицы Контрольных карт дл печатной формы.$*/
CREATE PROCEDURE [shifts].[sp_ControlCards_PrintSelect]
    @ShiftID int = 0
AS
BEGIN    
    SET NOCOUNT ON;
    DECLARE @Columns int, @IncDate datetime, @CheckHrs int, @StartDate datetime, @FinishDate datetime, @Modulo int
        
    /*
    нужно получить таблицу вида
    РМ   оп1   8-10    ККчекдате  
    РМ   оп2   8-10    ККчекдате  
    РМ   оп1   10-12   ККчекдате  
    РМ   оп2   10-12   ККчекдате  
    РМ   оп2   12-14   ККчекдате  
    РМ2  оп3   8-10    ККчекдате  
    РМ2  оп3   10-12   ККчекдате  
    РМ2  оп3   12-14   ККчекдате  
    */
    DECLARE @Query varchar(2000)

    SELECT @Columns = DATEDIFF(hh, s.FactStartDate, ISNULL(s.FactEndDate, s.PlanEndDate)) / ISNULL(t.CheckHrs, 1),
        @Modulo = DATEDIFF(hh, s.FactStartDate, ISNULL(s.FactEndDate, s.PlanEndDate)) % ISNULL(t.CheckHrs, 1),
        @CheckHrs = ISNULL(t.CheckHrs, 1),
        @StartDate = s.FactStartDate,
        @FinishDate = ISNULL(s.FactEndDate, s.PlanEndDate)
    FROM shifts.Shifts s
    INNER JOIN shifts.ShiftsTypes t ON t.ID = s.ShiftTypeID
    WHERE s.ID = @ShiftID

        
    SELECT @Columns = @Columns + @Modulo
    
    CREATE TABLE #tmp(PeriodName Varchar(20), CalcDateS datetime, CalcDateF datetime)

    DECLARE @I int
    SET @I = 0
    SET @Query = NULL

    WHILE @i < @Columns*@CheckHrs
    BEGIN
        SELECT @Query = ISNULL(@Query + ' UNION ALL ', '') + ' SELECT  ''' + RIGHT('00' + CAST(DATEPART(hh, DATEADD(hh, @I, @StartDate)) AS Varchar), 2) + 
          ' - ' + RIGHT('00' + CAST(DATEPART(hh, DATEADD(hh, @I + @CheckHrs, @StartDate)) AS Varchar), 2) + ''', ' + 
          '''' + CAST(DATEPART(mm, DATEADD(hh, @I, @StartDate)) AS varchar) + '.' + 
                 CAST(DATEPART(dd, DATEADD(hh, @I, @StartDate)) AS varchar) + '.' + 
                 CAST(DATEPART(yy, DATEADD(hh, @I, @StartDate)) AS varchar) + ' ' + 
                 CAST(DATEPART(hh, DATEADD(hh, @I, @StartDate)) AS varchar) + ':00:00'',' +
          '''' + CAST(DATEPART(mm, DATEADD(hh, @I + @CheckHrs, @StartDate)) AS varchar) + '.' + 
                 CAST(DATEPART(dd, DATEADD(hh, @I + @CheckHrs, @StartDate)) AS varchar) + '.' + 
                 CAST(DATEPART(yy, DATEADD(hh, @I + @CheckHrs, @StartDate)) AS varchar) + ' ' + 
                 CAST(DATEPART(hh, DATEADD(hh, @I + @CheckHrs, @StartDate)) AS varchar) + ':00:00'''
        SET @I = @I + @CheckHrs
    END
    SET @Query = 'INSERT INTO #tmp(PeriodName, CalcDateS, CalcDateF) ' + @Query
    EXEC(@Query)

    SELECT
        f.WorkPlaceID, 
        s.[Name], 
        d.EmployeeID, 
        e.FullName, 
        t.PeriodName,       
        CAST(min(t.CalcDateS) as Datetime) as CalcDateS,
        MAX(cc.RegisterDate) AS RegisterDate,
        MAX(CAST(DATEPART(hh, cc.RegisterDate) AS varchar) + ':' + Replicate('0',2-LEN(CAST(DATEPART(mi, cc.RegisterDate) AS varchar))) +CAST(DATEPART(mi, cc.RegisterDate) AS varchar)) AS RegisterDateText,
        DENSE_RANK() OVER (ORDER BY f.WorkPlaceID, d.EmployeeID) as RNum
    FROM shifts.EmployeeGroupsFactDetais AS d
         FULL JOIN #tmp AS t ON t.PeriodName = t.PeriodName
         INNER JOIN shifts.EmployeeGroupsFact f ON f.ID = d.EmployeeGroupsFactID
         INNER JOIN manufacture.StorageStructure s ON s.ID = f.WorkPlaceID
         INNER JOIN vw_Employees e ON e.ID = d.EmployeeID
         LEFT JOIN shifts.ControlCards cc ON cc.WorkPlaceID = f.WorkPlaceID AND cc.RegisterDate >= t.CalcDateS AND cc.RegisterDate < t.CalcDateF
    WHERE f.ShiftID = @ShiftID
    GROUP BY f.WorkPlaceID, s.[Name], d.EmployeeID, e.FullName, t.PeriodName
    ORDER BY f.WorkPlaceID, s.[Name], d.EmployeeID, e.FullName, min(t.CalcDateS), t.PeriodName
 
    DROP TABLE #tmp
END
GO