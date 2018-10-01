SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   11.06.2015$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   24.06.2015$*/
/*$Version:    1.00$   $Decription: Выборка данных из таблицы Контрольных карт.$*/
CREATE PROCEDURE [shifts].[sp_ControlCards_Select]
    @ShiftID int
AS
BEGIN
DECLARE @LOG_StartDate datetime SELECT @LOG_StartDate = GetDate()    
    SET NOCOUNT ON;
    DECLARE @Columns int, @IncDate datetime, @CheckHrs int, @StartDate datetime, @FinishDate datetime, @Modulo int
    
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

    CREATE TABLE #tmp(WorkPlaceID int, WorkPlaceName varchar(100), EmployeeID int, 
      EmployeeName Varchar(255))

    DECLARE @I int
    SET @I = 0
    SET @Query = NULL

    WHILE @i < @Columns*@CheckHrs
    BEGIN
        SELECT @Query = ISNULL(@Query + ',', '') + '[' + RIGHT('00' + CAST(DATEPART(hh, DATEADD(hh, @I, @StartDate)) AS Varchar), 2) + 
          ' - ' + RIGHT('00' + CAST(DATEPART(hh, DATEADD(hh, @I + @CheckHrs, @StartDate)) AS Varchar), 2) + '] varchar(5) '
        SET @I = @I + @CheckHrs
    END
    SET @Query = 'ALTER TABLE #tmp ADD ' + @Query
    EXEC(@Query)

    INSERT INTO #tmp(WorkPlaceID, WorkPlaceName, EmployeeID, EmployeeName)
    SELECT f.WorkPlaceID, s.[Name], d.EmployeeID, e.FullName /*f.StartDate, f.EndDate, f.IP*/
    FROM shifts.EmployeeGroupsFactDetais d
    INNER JOIN shifts.EmployeeGroupsFact f ON f.ID = d.EmployeeGroupsFactID
    INNER JOIN manufacture.StorageStructure s ON s.ID = f.WorkPlaceID
    INNER JOIN vw_Employees e ON e.ID = d.EmployeeID
    WHERE f.ShiftID = @ShiftID
    GROUP BY f.WorkPlaceID, s.[Name], d.EmployeeID, e.FullName
    
    /*курсор по записям #tmp*/
    /*по WorkPlaceID, EmployeeID, @ShiftID берем даты из EmployeeGroupsFact и */
    /*динамическим скриптом через DateAdd проверяем входит ли эта дата*/
    /*в период что чел работал. Если входит апдейт 1, иначе ничего    */
    DECLARE @ID int, @EmployeeID int, @WorkPlaceID int 
    
    DECLARE Cur CURSOR STATIC LOCAL FOR SELECT WorkPlaceID, EmployeeID FROM #tmp
    OPEN Cur
    FETCH NEXT FROM Cur INTO @WorkPlaceID, @EmployeeID
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        SELECT @I = 0, @IncDate = @StartDate
        
        WHILE @i < @Columns*@CheckHrs
        BEGIN            
            SELECT @Query = '              
              UPDATE #tmp SET [' + RIGHT('00' + CAST(DATEPART(hh, DATEADD(hh, @I, @StartDate)) AS Varchar), 2) + 
                          ' - '  + RIGHT('00' + CAST(DATEPART(hh, DATEADD(hh, @I + @CheckHrs, @StartDate)) AS Varchar), 2) + '] = '' '' 
              WHERE WorkPlaceID = ' + CAST(@WorkPlaceID AS Varchar) + ' AND EmployeeID = ' + CAST(@EmployeeID AS Varchar) + '

              
              UPDATE a SET a.[' + RIGHT('00' + CAST(DATEPART(hh, DATEADD(hh, @I, @StartDate)) AS Varchar), 2) + 
                          ' - '  + RIGHT('00' + CAST(DATEPART(hh, DATEADD(hh, @I + @CheckHrs, @StartDate)) AS Varchar), 2) + '] = 
                          '''' + CAST(DATEPART(hh, cc.RegisterDate) AS varchar) + '':'' + RIGHT(''00'' + CAST(DATEPART(mi, cc.RegisterDate) AS varchar), 2) + ''''
              FROM #tmp a
              INNER JOIN shifts.ControlCards cc ON cc.WorkPlaceID = a.WorkPlaceID 
                     AND cc.RegisterDate BETWEEN ''' + CAST(@StartDate AS varchar) + ''' AND ''' + CAST(@FinishDate AS varchar) + '''
              WHERE cc.RegisterDate >= ''' + CAST(DATEPART(mm, @IncDate) AS varchar) + '.' + 
           CAST(DATEPART(dd, @IncDate) AS varchar) + '.' + 
                                           CAST(DATEPART(yy, @IncDate) AS varchar) + ' ' + 
                                           CAST(DATEPART(hh, @IncDate) AS varchar) + ':00:00''' + ' 
                  AND cc.RegisterDate < ''' + CAST(DATEPART(mm, DATEADD(hh, @CheckHrs, @IncDate)) AS varchar) + '.' + 
                                              CAST(DATEPART(dd, DATEADD(hh, @CheckHrs, @IncDate)) AS varchar) + '.' + 
                                              CAST(DATEPART(yy, DATEADD(hh, @CheckHrs, @IncDate)) AS varchar) + ' ' + 
                                              CAST(DATEPART(hh, DATEADD(hh, @CheckHrs, @IncDate)) AS varchar) + ':00:00''                   
                  AND cc.WorkPlaceID = ' + CAST(@WorkPlaceID AS Varchar) 
                
            SET @I = @I + @CheckHrs
            EXEC (@Query)
            SELECT @IncDate = DATEADD(hh, @CheckHrs, @IncDate)
        END

        FETCH NEXT FROM Cur INTO @WorkPlaceID, @EmployeeID
    END    
    CLOSE Cur
    DEALLOCATE Cur

    SELECT ROW_NUMBER() OVER (ORDER BY WorkPlaceID, EmployeeID) AS ID, *
    FROM #tmp

    DROP TABLE #tmp

EXEC shifts.sp_LogProcedureExecDuration_Insert 'shifts.sp_ControlCards_Select', @LOG_StartDate
END
GO