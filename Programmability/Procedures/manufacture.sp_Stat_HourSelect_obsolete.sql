SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   05.05.2013$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   19.09.2015$*/
/*$Version:    1.00$   $Decription: Get statistic for shift group by hours and storage structure $*/
create PROCEDURE [manufacture].[sp_Stat_HourSelect_obsolete]
    @JobStageID int,
    @ShiftID int
AS
BEGIN
    SET NOCOUNT ON;   
    DECLARE/* @CurDate datetime, @StartDate datetime,*/ @Query varchar(8000), @SomeTmcID int
    DECLARE @ColumnsName as varchar(MAX), @ColumnsTitle as varchar(MAX), @SomeColumnName varchar(10), @ColCount int
                

/*    IF NOT EXISTS(
          SELECT * FROM information_schema.tables t
          WHERE t.TABLE_SCHEMA = 'StorageData'
                AND t.TABLE_NAME = 'G_' + CAST(@JobStageID AS Varchar(13)))
    BEGIN            
        SELECT ''
        RAISERROR ('Невозможно расчитать статистику. Отсутствует группирующая таблица', 16, 1)        
    END   */ 
        
    CREATE TABLE #TextTemp(ColumnsName varchar(MAX), ColumnsTitle varchar(MAX), ColCount int)
        
    /*----------------------------------------*/
    /*Get initial values*/
    /*----------------------------------------    */

/*    SELECT @MinQuatity = IsNull(a.MinQuantity, 0)
    FROM manufacture.JobStages a
    WHERE a.ID = @JobStageID*/

    SELECT TOP 1 @SomeTmcID = a.TmcID
    FROM manufacture.JobStageChecks a
    WHERE a.JobStageID = @JobStageID AND a.TypeID = 2 AND a.isDeleted = 0/* AND a.[CheckDB] = 1*/
    ORDER BY a.SortOrder DESC

    SELECT @SomeColumnName = itc.GroupColumnName
    FROM manufacture.PTmcImportTemplates it
         LEFT JOIN manufacture.JobStages js on js.ID = it.JobStageID 
         LEFT JOIN manufacture.PTmcImportTemplateColumns itc on itc.TemplateImportID = it.ID
    WHERE js.ID = @JobStageID
          AND itc.TmcID = @SomeTmcID

/*    SELECT @StartDate = s.FactStartDate, @CurDate = IsNull(s.FactEndDate, GetDate())
    FROM shifts.Shifts s
    WHERE s.ID = @ShiftID */ 

    /*----------------------------------------*/
    /*Generate Columns name for hours in shift*/
    /*----------------------------------------*/

--          AND p.PackedDate BETWEEN CONVERT(datetime, ''' + CONVERT(varchar(50),@StartDate, 109) +''') 
--                                   AND  CONVERT(datetime,''' + CONVERT(varchar(50),@CurDate, 109) + ''')
--          AND p.StorageStructureID in (SELECT StorageStructureID FROM shifts.WorkPlaces WHERE ShiftID = ' + CAST(@ShiftID AS Varchar(13)) + ')           
    SET @Query = 
    '
    DECLARE @hour as varchar(2), @ColumnsName as varchar(MAX), @ColumnsTitle as varchar(MAX), @i int 

    DECLARE CRS CURSOR STATIC LOCAL FOR
    SELECT DATEPART(hour,PackedDate) as dhour
    FROM StorageData.pTMC_'  + CAST(@SomeTmcID AS Varchar(13)) +  ' as p
    INNER JOIN shifts.EmployeeGroupsFact f ON f.ID = p.EmployeeGroupsFactID AND f.ShiftID = ' + CAST(@ShiftID AS Varchar(13)) + '   
    WHERE p.StatusID = 3                         
    GROUP BY DATEPART(Month,PackedDate), DATEPART(day,PackedDate), DATEPART(hour,PackedDate)
    ORDER BY DATEPART(Month,PackedDate), DATEPART(day,PackedDate), DATEPART(hour,PackedDate)

    OPEN CRS
                                    
    SET @ColumnsName = '''' 
    SET @ColumnsTitle = '''' 
    SET @i = 0
                                        
    FETCH NEXT FROM CRS INTO @hour
                                    
    WHILE @@FETCH_STATUS=0
    BEGIN
                                           
      SET @ColumnsName = @ColumnsName +''SUM(case when DATEPART(hour,PackedDate) = '' + @hour + '' then 1*emp.coeff else 0 end) as ['' + @hour + ''], ''
      SET @ColumnsTitle = @ColumnsTitle +''SUM(['' +@hour + '']) AS ['' + @hour + ''], '' 
      SET @i = @i + 1
          
      FETCH NEXT FROM CRS INTO @hour     
    END  

    IF @ColumnsTitle <> ''''
    BEGIN
        SET @ColumnsName = Substring(@ColumnsName,1,len(@ColumnsName)-1)
        SET @ColumnsTitle = Substring(@ColumnsTitle,1,len(@ColumnsTitle)-1)   
            
        INSERT INTO #TextTemp (ColumnsName, ColumnsTitle, ColCount)
        SELECT @ColumnsName, @ColumnsTitle, @i
    END
    '

    EXEC (@Query)

    SELECT TOP 1 @ColumnsName = ColumnsName + ', ', @ColumnsTitle = ColumnsTitle + ', ', @ColCount = ColCount
    FROM #TextTemp

    create table #EMP (EmployeeGroupsFactID INT, coeff float)

    INSERT INTO #EMP (EmployeeGroupsFactID, coeff)
    SELECT egf.EmployeeGroupsFactID,
           1/CAST(COUNT(egf.EmployeeID) as float)
    FROM shifts.EmployeeGroupsFactDetais egf
    INNER JOIN shifts.EmployeeGroupsFact f ON f.ID = egf.EmployeeGroupsFactID AND f.ShiftID = @ShiftID    
    GROUP BY egf.EmployeeGroupsFactID   


    CREATE TABLE #StructureLeft(StorageStructureID int, PackLeft int)

    SET @Query = 
    'INSERT INTO #StructureLeft(StorageStructureID, PackLeft)
    SELECT p.StorageStructureID, 
    Count(g.ID) as PackLeft 
    FROM StorageData.G_' + CAST(@JobStageID AS Varchar(13)) + ' as g 
    INNER JOIN StorageData.pTMC_' + CAST(@SomeTmcID AS Varchar(13)) + ' as p on p.ID = g.' + @SomeColumnName + ' AND p.StatusID = 2
    GROUP BY p.StorageStructureID'

    EXEC (@Query)
    

    SET @Query = 
    '
    SELECT 0 AS [ReservedColumn],
           dbo.fn_DateToString(MAX(JIR.SignDate), ''hh:nn'') AS [Подпись инструкции],
           em.FullName AS [Оператор],
           ' + IsNull(@ColumnsTitle,'') + '
           SUM(IsNull(tab.Pack,0)) as [Упаковано],           
           SUM(IsNull(sl.PackLeft,0)) as [Осталось],
           SUM(IsNull(tab.Pack,0)) + SUM(IsNull(sl.PackLeft,0)) AS [Всего]--,
          -- ss.Name AS [РМ]
    FROM
        (SELECT p.StorageStructureID, p.EmployeeGroupsFactID, 
                ' +  IsNull(@ColumnsName,'') + '
                Count(*)*emp.coeff as Pack
            FROM StorageData.pTMC_'  + CAST(@SomeTmcID AS Varchar(13)) +  ' as p
            INNER JOIN shifts.EmployeeGroupsFact f ON f.ID = p.EmployeeGroupsFactID AND f.ShiftID = ' + CAST(@ShiftID AS Varchar(13)) + '
                 LEFT JOIN #EMP emp ON emp.EmployeeGroupsFactID = p.EmployeeGroupsFactID              
            WHERE p.StatusID = 3
            GROUP BY p.StorageStructureID, p.EmployeeGroupsFactID, emp.coeff 
        ) tab
        LEFT JOIN shifts.EmployeeGroupsFactDetais eg ON eg.EmployeeGroupsFactID = tab.EmployeeGroupsFactID
        LEFT JOIN Employees em ON em.ID = eg.EmployeeID
        FULL JOIN #StructureLeft sl on sl.StorageStructureID = tab.StorageStructureID
        LEFT JOIN manufacture.JobInstructionReads JIR ON jir.ShiftID = ' + CAST(@ShiftID AS Varchar(13)) + ' AND jir.EmployeeID = eg.EmployeeID
                                                         AND jir.JobStageID = ' + CAST(@JobStageID AS Varchar(13)) + '
        LEFT JOIN manufacture.StorageStructure ss ON ss.ID = tab.StorageStructureID
    WHERE tab.StorageStructureID in (SELECT StorageStructureID FROM shifts.WorkPlaces WHERE ShiftID = ' + CAST(@ShiftID AS Varchar(13)) + ')
    GROUP BY em.FullName, ss.Name 
    '      
    EXEC (@Query)
/*                  AND p.PackedDate BETWEEN CONVERT(datetime, ''' + CONVERT(varchar(50),@StartDate, 109) +''') 
                                      AND  CONVERT(datetime, ''' + CONVERT(varchar(50),@CurDate, 109) + ''')*/
    DROP TABLE #TextTemp
    DROP TABLE #EMP
    DROP TABLE #StructureLeft

END
GO