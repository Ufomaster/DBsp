SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   05.05.2013$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   11.11.2016$*/
/*$Version:    1.00$   $Decription: Get statistic for shift group by hours and storage structure $*/
CREATE PROCEDURE [manufacture].[sp_Stat_HourSelect2]
    @JobStageID int,
    @ShiftID int
AS
BEGIN
DECLARE @LOG_StartDate datetime SELECT @LOG_StartDate = GetDate()
    SET NOCOUNT ON;   
    DECLARE/* @CurDate datetime, @StartDate datetime,*/ @Query varchar(8000), @SomeTmcID int
    DECLARE @ColumnsName as varchar(MAX), @ColumnsTitle as varchar(MAX), @SomeColumnName varchar(10), @ColCount int
        
    CREATE TABLE #TextTemp(ColumnsName varchar(MAX), ColumnsTitle varchar(MAX), ColCount int)
        
    /*Get initial values*/

/*    SELECT @MinQuatity = IsNull(a.MinQuantity, 0) FROM manufacture.JobStages a WHERE a.ID = @JobStageID*/

    SELECT TOP 1 @SomeTmcID = a.TmcID
    FROM manufacture.JobStageChecks a
    WHERE a.JobStageID = @JobStageID AND a.TypeID = 2 AND a.isDeleted = 0 AND a.TmcID is not null/* AND a.[CheckDB] = 1*/
    ORDER BY a.SortOrder DESC

    SELECT @SomeColumnName = itc.GroupColumnName
    FROM manufacture.PTmcImportTemplates it
         LEFT JOIN manufacture.JobStages js on js.ID = it.JobStageID 
         LEFT JOIN manufacture.PTmcImportTemplateColumns itc on itc.TemplateImportID = it.ID
    WHERE js.ID = @JobStageID
          AND itc.TmcID = @SomeTmcID

    /*Generate Columns name for hours in shift*/

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

    CREATE TABLE #EMP (EmployeeGroupsFactID INT, coeff float)

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
           MAx(abc.Date) AS [Подпись инструкции],
           ss.Name AS [РМ],
           em.FullName AS [Оператор],
           ' + IsNull(@ColumnsTitle,'') + '           
           SUM(IsNull(tab.Pack,0)) as [Упаковано],        
           IsNull(sl.PackLeft,0) as [Осталось],
           SUM(IsNull(tab.Pack,0)) + IsNull(sl.PackLeft,0) AS [Всего]
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
        INNER JOIN shifts.EmployeeGroupsFactDetais eg ON eg.EmployeeGroupsFactID = tab.EmployeeGroupsFactID
        INNER JOIN Employees em ON em.ID = eg.EmployeeID
        INNER JOIN manufacture.StorageStructure ss ON ss.ID = tab.StorageStructureID
        LEFT JOIN #StructureLeft sl on sl.StorageStructureID = tab.StorageStructureID
        LEFT JOIN (SELECT dbo.fn_DateToString(MAX(JIR.SignDate), ''hh:nn'') AS Date, EmployeeID, ShiftID, JobStageID
                   FROM manufacture.JobInstructionReads JIR
                   WHERE jir.ShiftID = ' + CAST(@ShiftID AS Varchar(13)) + '
                         AND jir.JobStageID = ' + CAST(@JobStageID AS Varchar(13)) + '
                   GROUP BY jir.ShiftID, jir.JobStageID, jir.EmployeeID) abc ON abc.EmployeeID = eg.EmployeeID
    GROUP BY em.FullName, ss.Name, sl.PackLeft
    ORDER BY ss.Name'

--    WHERE tab.StorageStructureID in (SELECT StorageStructureID FROM shifts.WorkPlaces WHERE ShiftID = ' + CAST(@ShiftID AS Varchar(13)) + ')             

    EXEC (@Query)

    DROP TABLE #TextTemp
    DROP TABLE #EMP
    DROP TABLE #StructureLeft

EXEC shifts.sp_LogProcedureExecDuration_Insert 'manufacture.sp_Stat_HourSelect2', @LOG_StartDate
END
GO