SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create: Zapadinskiy Anatoliy$	$Create date: 05.05.2013$*/
/*$Modify: Yuriy Oleynik$	$Modify date: 03.09.2015$*/
/*$Version: 1.00$ $Decription: Get report for shift group by hours and storage structure $*/
create PROCEDURE [manufacture].[sp_Stat_HourSelectWP_obsolete]
    @JobStageID int,
    @ShiftID int
AS
BEGIN 
    SET NOCOUNT ON
    DECLARE @OutputTmcID int, @CurDate datetime, @StartDate datetime, @Query varchar(8000), @SomeTmcID int
    DECLARE @ColumnsName AS varchar(MAX), @ColumnsTitle AS varchar(MAX), @SomeColumnName varchar(10), @MinQuatity int, @ColCount int,
    @ColVisible varchar(500), @ColFooter varchar(500), @i int

    IF NOT EXISTS(
    SELECT * FROM information_schema.tables t
    WHERE t.TABLE_SCHEMA = 'StorageData'
    AND t.TABLE_NAME = 'G_' + CAST(@JobStageID AS Varchar(13)))
    BEGIN 
        SELECT ''
        RAISERROR ('Невозможно расчитать статистику. Отсутствует группирующая таблица', 16, 1) 
    END 

    /*SELECT @CurDate = GetDate()*/

    CREATE TABLE #TextTemp(ColumnsName varchar(MAX), ColumnsTitle varchar(MAX), ColCount int)

    /*----------------------------------------*/
    /*Get initial values*/
    /*---------------------------------------- */

    SELECT @OutputTmcID = a.OutputTmcID, @MinQuatity = IsNull(a.MinQuantity, 0)
    FROM manufacture.JobStages a
    WHERE a.ID = @JobStageID

    SELECT TOP 1 @SomeTmcID = a.TmcID
    FROM manufacture.JobStageChecks a
    WHERE a.JobStageID = @JobStageID AND a.TypeID = 2 AND a.isDeleted = 0
    ORDER BY a.SortOrder DESC

    SELECT @SomeColumnName = itc.GroupColumnName
    FROM manufacture.PTmcImportTemplates it
        LEFT JOIN manufacture.JobStages js on js.ID = it.JobStageID 
        LEFT JOIN manufacture.PTmcImportTemplateColumns itc on itc.TemplateImportID = it.ID
    WHERE js.ID = @JobStageID
    AND itc.TmcID = @SomeTmcID

    SELECT @StartDate = s.FactStartDate, @CurDate = IsNull(s.FactEndDate, GetDate())
    FROM shifts.Shifts s
    WHERE s.ID = @ShiftID 

    /*----------------------------------------*/
    /*Generate Columns name for hours in shift*/
    /*----------------------------------------*/

    SET @Query = 
    '
    DECLARE @hour as varchar(2), @ColumnsName as varchar(MAX), @ColumnsTitle as varchar(MAX), @i int 

    DECLARE CRS CURSOR STATIC LOCAL FOR
    SELECT DATEPART(hour,PackedDate) as dhour
    FROM StorageData.pTMC_' + CAST(@SomeTmcID AS Varchar(13)) + ' as p 
    WHERE p.StatusID = 3
    AND p.PackedDate BETWEEN CONVERT(datetime, ''' + CONVERT(varchar(50),@StartDate, 109) +''') 
    AND CONVERT(datetime,''' + CONVERT(varchar(50),@CurDate, 109) + ''')
    AND p.StorageStructureID in (SELECT StorageStructureID FROM shifts.WorkPlaces WHERE ShiftID = ' + CAST(@ShiftID AS Varchar(13)) + ') 
    GROUP BY DATEPART(hour,PackedDate)

    OPEN CRS

    SET @ColumnsName = '''' 
    SET @ColumnsTitle = '''' 
    SET @i = 0

    FETCH NEXT FROM CRS INTO @hour

    WHILE @@FETCH_STATUS=0
    BEGIN

    SET @ColumnsName = @ColumnsName +''SUM(case when DATEPART(hour,PackedDate) = '' + @hour + '' then 1 else 0 end) as ['' + @hour + ''], ''
    SET @ColumnsTitle = @ColumnsTitle +''['' +@hour + ''], '' 
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

    /*----------------------------------------*/
    /*Get unpacked card number */
    /*----------------------------------------*/

    CREATE TABLE #StructureLeft(StorageStructureID int, PackLeft int)

    SET @Query = 
    'INSERT INTO #StructureLeft(StorageStructureID, PackLeft)
    SELECT p.StorageStructureID, 
    Count(g.ID) as PackLeft 
    FROM StorageData.G_' + CAST(@JobStageID AS Varchar(13)) + ' as g 
    LEFT JOIN StorageData.pTMC_' + CAST(@SomeTmcID AS Varchar(13)) + ' as p on p.ID = g.' + @SomeColumnName + '
    WHERE p.StatusID = 2
    GROUP BY p.StorageStructureID'

    EXEC (@Query)

    SET @ColFooter = ''
    SET @ColVisible = '' 
    SET @i = 0
    WHILE @i <= IsNull(@ColCount,0) + 7
    BEGIN
    SET @ColVisible = @ColVisible + CAST(@i as varchar(13)) + CASE WHEN (@i <> IsNull(@ColCount,0) + 7) THEN ',' ELSE '' END
    IF @i <> 0 
    SET @ColFooter = @ColFooter + CAST(@i as varchar(13)) + CASE WHEN (@i <> IsNull(@ColCount,0) + 7) THEN ',' ELSE '' END

    SET @i = @i + 1 
    END

    /*SET @ColFooter = Substring(@ColFooter, 1, Len(@ColFooter)-1)*/
    /*SET @ColVisible = Substring(@ColVisible, 1, Len(@ColVisible)-1) */

    /*-------------------------------------------------------------*/
    /*Get count of packed card group by hours and storage structure*/
    /*-------------------------------------------------------------*/

    /* SELECT 'Нет данных за выбранную смену' as 'Ошибка'*/

    SET @Query = 
    '
    SELECT 
        CASE WHEN IsNull(sl.PackLeft,0) = 0 THEN 2 
        WHEN (IsNull(sl.PackLeft,0) < ' + CAST(@MinQuatity AS Varchar(13)) + ') THEN 1
        ELSE 0
        END as [sys_color],
/*        ''' + @ColVisible + ''' as [sys_visible],
        ''' + @ColFooter + ''' as [sys_footer],*/
        ss.Name as [Рабочее место],
        ' + IsNull(@ColumnsTitle,'') + '
        IsNull(tab.Pack,0) as [Упаковано],
        IsNull(sl.PackLeft,0) as [Осталось],
        IsNull(sl.PackLeft,0) + IsNull(tab.Pack,0) as [Всего]
        
    FROM
        (SELECT p.StorageStructureID,
         ' + IsNull(@ColumnsName,'') + '
         Count(p.ID) as Pack
         FROM StorageData.pTMC_' + CAST(@SomeTmcID AS Varchar(13)) + ' as p 
         WHERE p.StatusID = 3
             AND p.PackedDate BETWEEN CONVERT(datetime, ''' + CONVERT(varchar(50),@StartDate, 109) +''') 
             AND CONVERT(datetime, ''' + CONVERT(varchar(50),@CurDate, 109) + ''')
    GROUP BY p.StorageStructureID) tab
    FULL JOIN #StructureLeft sl on sl.StorageStructureID = tab.StorageStructureID
    LEFT JOIN manufacture.StorageStructure ss on ss.ID = tab.StorageStructureID
    WHERE sl.StorageStructureID in (SELECT StorageStructureID FROM shifts.WorkPlaces WHERE ShiftID = ' + CAST(@ShiftID AS Varchar(13)) + ') 
    OR tab.StorageStructureID in (SELECT StorageStructureID FROM shifts.WorkPlaces WHERE ShiftID = ' + CAST(@ShiftID AS Varchar(13)) + ') 
    ORDER BY ss.Name'

    /*SELECT @Query*/

    EXEC (@Query)

    DROP TABLE #TextTemp
    DROP TABLE #StructureLeft
END
GO