SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   21.02.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   08.02.2018$*/
/*$Version:    1.00$   $Decription: $*/
CREATE PROCEDURE [manufacture].[sp_OperatorPack]
    @ArrayOfID varchar(2000),
    @ArrayOfTMCID varchar(2000),
    @ArrayOfTypeID varchar(2000),
    @ArrayOfValues varchar(2000),
    @JobStageID int,
    @StorageStructureID smallint,
    @EmployeeGroupsFactID int,
    @tPackDate varchar(50) = null,
    @tLastPackDate varchar(50) = null
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PackDate datetime, @LastPackDate datetime
    SELECT 
       @PackDate = CAST(@tPackDate as datetime), 
       @LastPackDate = CAST(@tLastPackDate as datetime)
    DECLARE @N TABLE(ID tinyint identity(1,1), DynamicID varchar(30), [Rank] tinyint)
    DECLARE @Tmc TABLE(ID tinyint identity(1,1), TMCID varchar(30))
    DECLARE @Type TABLE(ID tinyint identity(1,1), TypeID varchar(20))
    DECLARE @Vals TABLE(ID tinyint identity(1,1), Val varchar(255)) 
    /*transform array*/
    INSERT INTO @N(DynamicID)
    SELECT ID FROM dbo.fn_StringToSTable(@ArrayOfID)
    ORDER BY AutoincID
    
    INSERT INTO @Tmc(TMCID)
    SELECT ID FROM dbo.fn_StringToSTable(@ArrayOfTMCID)
    ORDER BY AutoincID
    --TMCID = 0 это сверка Статического значения в маске со сканированием Инсерт игнорируем.
    /*Нумеруем все ненулевые ТМЦID, так как Статические значение нужно проигнорировать*/
    
    UPDATE a
    SET a.[Rank] = Ranking.[Rank]
    FROM @N a
    INNER JOIN     
        (SELECT n.ID, CASE WHEN t.TMCID > 0 THEN ROW_NUMBER() OVER (ORDER BY n.ID) ELSE NULL END AS [Rank]
         FROM @N AS n
         INNER JOIN @Tmc t ON t.ID = n.ID AND t.TMCID > 0
        ) AS Ranking ON Ranking.ID = a.ID
        
        
    INSERT INTO @Type(TypeID)
    SELECT ID FROM dbo.fn_StringToSTable(@ArrayOfTypeID)
    ORDER BY AutoincID

    INSERT INTO @Vals(Val)
    SELECT ID FROM dbo.fn_StringToSTable(@ArrayOfValues)
    ORDER BY AutoincID

    DECLARE @Value varchar(255),    @Query varchar(MAX),
            @QueryG varchar(MAX),   @QueryGroupID varchar(MAX),
            @SomeTMCID int,         @SomeColName varchar(255),
            @SomeID int,            @SomeSortOrder int,                
            @CR varchar(5),         @QueryUpdateG varchar(max),
            @QueryProduct varchar(max),
            @ChallangeTime int

    --подсчет времени выполнения упаковки - разница между прошлой датой и настоящей.
    --записываем секунды умноженные на 10. пример: 4,5 секунды будут записаны как 45.
    -- задержки более 10 минут отфильтровываем. 
    SELECT @ChallangeTime = ROUND(CASE 
                                    WHEN DATEDIFF(ms, ISNULL(@LastPackDate, @PackDate), @PackDate)/100 > 6000 THEN 6000 
                                 ELSE DATEDIFF(ms, ISNULL(@LastPackDate, @PackDate), @PackDate)/100
                                 END, 0) 

    SET @CR = CHAR(13) + CHAR(10)
    
    SELECT @QueryGroupID = CAST('---Начало работы по инсерту и выборке идентификатора групповой таблицы G_' + @CR AS Varchar(max))
    
    --Если нет Линковіх комплектов - значит в любому случае идет инсерт в Груп тайбл.
    --Нужно это сделать 1 раз.
    IF NOT EXISTS(SELECT ID FROM manufacture.JobStageChecks a
                  WHERE a.CheckLink = 1 AND a.TypeID = 2 AND a.JobStageID = @JobStageID AND a.isDeleted = 0)
    BEGIN
        SELECT @Query = ISNULL(@Query + ', ', '') + 'Column_' + CAST(a.[Rank] AS Varchar),
              @QueryG = ISNULL(@QueryG + ', ', '') + CASE WHEN a.DynamicID = 0 THEN 'NULL' ELSE CAST(a.DynamicID AS Varchar) END
        FROM @N a
        --WHERE a.DynamicID <> 0 убираем условие, инсертим все. НО там где 0 ставим НУЛЛ
        WHERE a.[Rank] IS NOT NULL
        ORDER BY a.ID
        SELECT @QueryGroupID = 'INSERT INTO StorageData.G_' + CAST(@JobStageID AS varchar) + '(' + @Query + ')' + @CR + 'OUTPUT INSERTED.ID INTO #GroupID ' + @CR +  'SELECT ' + @QueryG + @CR +
        'SELECT @GroupID = ID' + @CR + 
        'FROM #GroupID '
    END
    ELSE
    BEGIN
        --нужно из @ArrayOfID выбрать с конца ненулевой ID, тара будет вначале.
        SELECT TOP 1 @SomeID = a.DynamicID, @SomeTMCID = t.TMCID, @SomeSortOrder = a.ID
        FROM @N a
        INNER JOIN @Tmc t ON t.ID = a.ID
        WHERE a.DynamicID <> 0 AND a.[Rank] IS NOT NULL
        ORDER BY a.ID DESC
        --отберем имя колонки для этой @SomeTMCID
        SELECT @SomeColName = itc.GroupColumnName
        FROM manufacture.JobStageChecks m
        INNER JOIN manufacture.PTmcImportTemplateColumns itc ON itc.ID = m.ImportTemplateColumnID
        WHERE m.TmcID = @SomeTMCID AND m.JobStageID = @JobStageID AND m.SortOrder = @SomeSortOrder AND m.isDeleted = 0

        --рисуем условие отбора записи ID групповой таблицы по выбранным данным
        SELECT @QueryGroupID = 'SELECT TOP 1 @GroupID = a.ID FROM StorageData.G_' + CAST(@JobStageID AS Varchar) + ' AS a ' +
                               'WHERE a.' + @SomeColName + ' = ' + CAST(@SomeID AS varchar)

    END

    SELECT @Query = CAST('---Начало работы с pTmc' + @CR AS Varchar(max)), @QueryG = ''    
    SELECT @QueryUpdateG = NULL
                           
    --Формируем запрос для вставочных и апдейтных Птмц, для тары и для комплектов.                       
    SELECT @Query = @Query + @CR + @CR + 'DELETE FROM #LastDynamicID' + @CR + @CR + 
    CASE WHEN c.TypeID = 1 THEN ' --если тара и Инсерт, то производим предварительный поиск ' + @CR +
                               '--возможен вариант когда номер инсертится несколько раз, так как может существовать не импортированная в DB тара,' + @CR +
                               '--тогда при упаковке этой тары всегда передается @DynamicID = 0, так как на клиенте не будет её айди(поиск не пройдет, ' + @CR +
                               '--так как мы "продолжаем поковать" и CodeValidate для этой тары не вызовется), но сам номер уже мог быть заисерчен.' + @CR +
                               '--поэтому проверка.' + @CR +
                               'INSERT INTO #LastDynamicID(ID) ' + @CR +  
                               'SELECT ID FROM [StorageData].pTMC_' + CAST(b.TmcID AS Varchar) + ' AS a ' + @CR + 
                               'WHERE [Value] = ''' + v.Val + '''  AND StorageStructureID = ' + CAST(@StorageStructureID AS Varchar) + @CR + @CR
    ELSE ''
    END +
    CASE 
    WHEN a.DynamicID = 0 THEN 
    '-- если поиск нашел что-то, то не нужно инсертить, иначе нужно' + @CR +
    '--будет несколько упрощенный запрос, без инсерта.' + @CR +
    '--иначе с инсертом' + @CR +
    '--если это тара то PackedDate не ставим. в инсерте PackedDate не будет "Запаковано", так как это только первая запись.' + @CR +
    '--для ручной упаковки ставим PackedDate так как проверки упакованности не идут на такую тару, поэтому проверим дополнительно @LastDynamicID' + @CR + 
    'IF NOT EXISTS(SELECT * FROM #LastDynamicID) ' + @CR + 
    'BEGIN ' + @CR + 
    '     INSERT INTO StorageData.pTMC_' + CAST(b.TmcID AS Varchar) + @CR + 
    '     ([Value], StatusID, TMCID, StorageStructureID, ParentTMCID, ParentPTMCID, OperationID, EmployeeGroupsFactID, PackedDate) ' + @CR + 
    '     OUTPUT INSERTED.ID INTO #LastDynamicID ' + @CR + 
    '     SELECT ''' + v.Val + ''', ' + CASE c.TypeID WHEN 1 THEN '2' WHEN 2 THEN '3' END + @CR + 
    '     , ' + CAST(b.TmcID AS Varchar) + @CR + 
    '     , ' + CAST(@StorageStructureID AS Varchar) + @CR + 
    '     , CASE WHEN @LastDynamicID <> 0 AND ' + CAST(c.TypeID AS Varchar) + ' = 1 THEN CAST(@LastTMCID     AS Varchar) ELSE NULL END ' + @CR + 
    '     , CASE WHEN @LastDynamicID <> 0 AND ' + CAST(c.TypeID AS Varchar) + ' = 1 THEN CAST(@LastDynamicID AS Varchar) ELSE NULL END ' + @CR + 
    '     , NULL,  ' + CAST(@EmployeeGroupsFactID AS Varchar) + ', CASE WHEN ' + CAST(c.TypeID AS Varchar) + ' = 1 AND @LastDynamicID <> 0 THEN NULL ELSE @ExecDate END' + @CR + @CR + 
    
    '     INSERT INTO #DynamicIDs(ValID, ID)' + @CR +
    '     SELECT ID, ' + CAST(a.ID AS Varchar) + ' FROM #LastDynamicID' + @CR +
    'END ' + @CR +
    'ELSE' + @CR +
    '    INSERT INTO #DynamicIDs(ValID, ID)' + @CR +
    '    SELECT ID, ' + CAST(a.ID AS Varchar) + ' FROM #LastDynamicID' + @CR + @CR +
    
    '--если текущий - тара, то заполним @LastDynamicID' + @CR +
    'IF ' + CAST(c.TypeID AS Varchar) + ' = 1 ' + @CR +
    '    IF EXISTS(SELECT * FROM #LastDynamicID) ' + @CR +
    '        SELECT @LastDynamicID = ID, @LastTMCID = ' + CAST(b.TmcID AS Varchar) + @CR +
    '        FROM #LastDynamicID' + @CR + @CR + 
    
    'IF @NameDynamicID IS NULL' + @CR +
    '    IF @OutputNameFromTmcID = ' + CAST(b.TmcID AS Varchar) + ' AND @OutputSortOrder = ' + CAST(a.ID AS Varchar) + @CR +
    '        IF EXISTS(SELECT * FROM #LastDynamicID) ' + @CR +
    '            SELECT @NameDynamicID = ID' + @CR +
    '            FROM #LastDynamicID'
    WHEN a.DynamicID <> 0 THEN 
    'UPDATE StorageData.pTMC_' + CAST(b.TmcID AS Varchar) + @CR +
    'SET [StatusID] = ' + CASE c.TypeID WHEN 1 THEN '2' WHEN 2 THEN '3' END + @CR +
    ', ParentTMCID =  CASE WHEN @LastDynamicID <> 0 AND ' + CAST(c.TypeID AS Varchar) + ' = 1 THEN CAST(@LastTMCID     AS Varchar) ELSE NULL END ' + @CR +
    ', ParentPTMCID = CASE WHEN @LastDynamicID <> 0 AND ' + CAST(c.TypeID AS Varchar) + ' = 1 THEN CAST(@LastDynamicID AS Varchar) ELSE NULL END ' + @CR +
    ', EmployeeGroupsFactID = ' + CAST(@EmployeeGroupsFactID AS Varchar) + @CR +
    ', PackedDate = CASE WHEN ' + CAST(c.TypeID AS Varchar) + ' = 1 THEN NULL ELSE @ExecDate END ' + @CR +
    'WHERE ID = ' +  CAST(a.DynamicID AS Varchar) + @CR + @CR + 
    
    'INSERT INTO #DynamicIDs(ValID, ID)' + @CR +
    'SELECT ' +  CAST(a.DynamicID AS Varchar) +', ' + CAST(a.ID AS Varchar) + @CR + @CR + 
    
    '--если текущий - тара, то заполним @LastDynamicID' + @CR +
    'IF ' + CAST(c.TypeID AS Varchar) + ' = 1 ' + @CR +
    '    IF EXISTS(SELECT * FROM #LastDynamicID) ' + @CR +
    '        SELECT @LastDynamicID = ID, @LastTMCID = ' + CAST(b.TmcID AS Varchar) + @CR +
    '        FROM #LastDynamicID' + @CR +
    '    ELSE' + @CR +
    '        SELECT @LastDynamicID = ' +  CAST(a.DynamicID AS Varchar) + ', @LastTMCID = ' + CAST(b.TmcID AS Varchar) + @CR + @CR + 

    'IF @NameDynamicID IS NULL' + @CR +
    '    IF @OutputNameFromTmcID = ' + CAST(b.TmcID AS Varchar) + ' AND @OutputSortOrder = ' + CAST(a.ID AS Varchar) + @CR +
    '        IF EXISTS(SELECT * FROM #LastDynamicID) ' + @CR +
    '            SELECT @NameDynamicID = ID' + @CR +
    '            FROM #LastDynamicID' + @CR + 
    '        ELSE'  + @CR + 
    '            SELECT @NameDynamicID = ' +  CAST(a.DynamicID AS Varchar)
    END,
    @QueryUpdateG = ISNULL(@QueryUpdateG + ',', '') + so.GroupColumnName + ' = (SELECT ValID FROM #DynamicIDs WHERE ID = ' + CAST(a.ID AS Varchar) + ')'         
    FROM @N a
    INNER JOIN @Tmc  b ON a.ID = b.ID AND b.TmcID <> 0
    INNER JOIN @Type c ON a.ID = c.ID
    INNER JOIN @Vals v ON a.ID = v.ID
    INNER JOIN (SELECT itc.GroupColumnName, m.SortOrder
                FROM manufacture.JobStageChecks m
                INNER JOIN manufacture.PTmcImportTemplateColumns itc ON itc.ID = m.ImportTemplateColumnID
                WHERE m.JobStageID = @JobStageID AND m.isDeleted = 0 AND m.UseMaskAsStaticValue = 0) AS so ON so.SortOrder = a.ID
    WHERE a.[Rank] IS NOT NULL
    ORDER BY a.ID                                         

    SELECT @QueryUpdateG = CAST('---Начало работы с G_' + @CR AS Varchar(max)) +
    'UPDATE StorageData.G_' + CAST(@JobStageID AS Varchar) + @CR + 
    'SET ' + @QueryUpdateG + @CR +  
    'WHERE ID = @GroupID' + @CR
       
    --Формируем запрос для готовой продукции
    SELECT @QueryProduct = 
       '--Начало работы с готовой продукцией' + @CR +
       'INSERT INTO StorageData.pTMC_' + CAST(js.OutputTmcID AS Varchar) + @CR +
       ' ([Value], StatusID, TMCID, StorageStructureID, ParentTMCID, ParentPTMCID, OperationID, Batch, ChallengeTime) ' + @CR +
       ' SELECT [Value], 2 '+ @CR +
       ', @OutputTmcID' + @CR +
       ', ' + CAST(@StorageStructureID AS Varchar) + @CR +
       ', CASE WHEN @LastDynamicID <> 0 THEN CAST(@LastTMCID     AS Varchar) ELSE NULL END ' + @CR +
       ', CASE WHEN @LastDynamicID <> 0 THEN CAST(@LastDynamicID AS Varchar) ELSE NULL END ' + @CR +
       ', NULL ' + @CR +
       ', Batch ' + @CR +
       ', ' + CAST(@ChallangeTime AS varchar) + @CR +
       'FROM StorageData.pTMC_' + CAST(s.TmcID  AS Varchar) + ' WHERE ID = @NameDynamicID'
       FROM manufacture.JobStages js
       INNER JOIN manufacture.JobStageChecks s ON s.ID = js.OutputNameFromCheckID AND s.isDeleted = 0
       WHERE js.ID = @JobStageID
    
    --формируем общий запрос из кусочков
    SELECT @Query =    
    'DECLARE @Err Int' + @CR +
    'SET XACT_ABORT ON' + @CR +
    'BEGIN TRAN' + @CR +
    'BEGIN TRY' + @CR + @CR + @CR +
    
    
    'CREATE TABLE #LastDynamicID(ID int) ' + @CR +
    'CREATE TABLE #GroupID(ID int) ' + @CR +
    'CREATE TABLE #DynamicIDs(ValID int, ID int) ' + @CR + @CR +
    'DECLARE @GroupID int, @LastDynamicID int, @LastTMCID int, @NameDynamicID int, @OutputTmcID int, @OutputNameFromTmcID int, @OutputSortOrder int ' + @CR + @CR + 
    'SELECT @OutputTmcID = js.OutputTmcID, @OutputNameFromTmcID = s.TmcID, @OutputSortOrder = s.SortOrder' + @CR +
    'FROM manufacture.JobStages js' + @CR +
    'INNER JOIN manufacture.JobStageChecks s ON s.ID = js.OutputNameFromCheckID AND s.isDeleted = 0' + @CR +
    'WHERE js.ID = ' + CAST(@JobStageID AS Varchar) + @CR + @CR + 
    'DECLARE @ExecDate datetime SET @ExecDate = ''' +@tPackDate + '''' + @CR + @CR + 
    @QueryGroupID + @CR + 
    @Query + @CR +
    @QueryUpdateG  + @CR + 
    @QueryProduct + @CR +
    'DROP TABLE #LastDynamicID' + @CR +
    'DROP TABLE #GroupID' + @CR +
    'DROP TABLE #DynamicIDs' + @CR + @CR + @CR +
    
    
    'COMMIT' + @CR +
    'END TRY' + @CR +
    'BEGIN CATCH' + @CR +
    '    SET @Err = @@ERROR;' + @CR +
    '    IF @@TRANCOUNT > 0 ROLLBACK TRAN' + @CR +
    '    EXEC sp_RaiseError @ID = @Err;' + @CR +
    'END CATCH' + @CR

--    INSERT INTO manufacture.StressTestAssmQueryLog(Q,  StorageStructureID,  ExecDate,  ArrayOfID,  ArrayOfValues,  JobStageID,  EmployeeGroupsFactID)
--    VALUES(@Query, @StorageStructureID, GETDATE(), @ArrayOfID, @ArrayOfValues, @JobStageID, @EmployeeGroupsFactID)

    --выполняем запрос            
/*    SELECT @Query */                      
     IF @Query IS NULL
         RAISERROR('Null Execute', 16, 1)
     ELSE
         EXEC(@Query)
END
GO