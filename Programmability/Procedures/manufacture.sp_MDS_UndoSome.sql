SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   09.10.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   06.08.2015$*/
/*$Version:    1.00$   $Decription: Выбор комплектующих Готовой Продукции(включая ГП) по заданному коду
для функции УНДО. @InfoOnly=1 выбирает информацию для выполения операций,
                  @InfoOnly=0 выдает читабельный вид для пользователя$*/
CREATE PROCEDURE [manufacture].[sp_MDS_UndoSome] (@JobStageID int, @SearchValue varchar(8000), @InfoOnly bit)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Counter int, @Query varchar(8000), @SomeColName varchar(8000), @NoLinks bit, @MaxSortOrder int, @ID int

    CREATE TABLE #Res (G_ID int, ID int, [Value] varchar(255), [Name] varchar(255), SortOrder int, TypeID int, 
         JobStageChecksID int, OutputNameFromTmcID int, OutputTmcID int, TmcID int, isCheckDB bit, ColumnName varchar(255), NoLinks bit)
    CREATE TABLE #Tmp (G_ID int, ID int, TmcID int, CheckID int, GroupColumnName varchar(255))
             
    SELECT @Query = ISNULL(@Query + ' UNION ALL ', '') + 
      ' SELECT g.ID AS G_ID, p.ID, ' + CAST(jc.TmcID AS Varchar(36)) + ' AS TmcID, ' + 
        CAST(jc.ID AS varchar(32)) + ' AS CheckID, ''' +
        itc.GroupColumnName + ''' AS GroupColumnName
        FROM StorageData.pTMC_' + CAST(jc.TmcID AS Varchar(36)) + ' AS p ' +
      ' INNER JOIN StorageData.G_' + CAST(@JobStageID AS Varchar) + ' g ON g.' + itc.GroupColumnName + ' = p.ID ' +
      ' WHERE p.Value = ''' + @SearchValue + ''' AND StatusID = 3 '
    FROM manufacture.JobStageChecks jc
    INNER JOIN manufacture.PTmcImportTemplateColumns itc ON itc.ID = jc.ImportTemplateColumnID
    WHERE jc.JobStageID = @JobStageID AND jc.isDeleted = 0 AND jc.TypeID = 2 AND jc.UseMaskAsStaticValue = 0

    SELECT @Query = ISNULL('INSERT INTO #Tmp (G_ID, ID, TmcID, CheckID, GroupColumnName) ' + @Query, '')
    EXEC (@Query)

    --ошибка в следующем запросе. для разных номеров возвращает такой запрос 2 строки-
    IF (SELECT COUNT(a.G_ID)
        FROM (SELECT COUNT(G_ID) AS G_ID FROM #tmp GROUP BY (G_ID)) a
        ) > 1
    BEGIN
        RAISERROR ('Найдено более 1-го ТМЦ. Для отката упаковки воспользуйтесь интерфейсом оператора ', 16, 1)  
    END
    ELSE    
    BEGIN
        SELECT TOP 1 @ID = ID, @SomeColName = GroupColumnName
        FROM #Tmp

        INSERT INTO #Res (G_ID, ID, [Value], [Name] , SortOrder, TypeID , 
          JobStageChecksID, OutputNameFromTmcID , OutputTmcID, TmcID)
        EXEC manufacture.sp_MDSChainValue_Select @ID, @SomeColName, @JobStageID, 1

        IF EXISTS(SELECT ID 
                  FROM manufacture.JobStageChecks a 
                  WHERE a.CheckLink = 1 AND a.JobStageID = @JobStageID AND a.isDeleted = 0)
            SET @NoLinks = 0
        ELSE
            SET @NoLinks = 1
              
        UPDATE a
        SET a.isCheckDB = jj.[CheckDB], a.ColumnName = ic.GroupColumnName, 
            a.NoLinks = @NoLinks
        FROM #Res a 
        INNER JOIN manufacture.JobStageChecks jj ON jj.ID = a.JobStageChecksID
        INNER JOIn manufacture.PTmcImportTemplateColumns ic ON ic.ID = jj.ImportTemplateColumnID
        
        IF @InfoOnly = 1    
            SELECT * FROM #Res
            ORDER BY G_ID ASC, SortOrder

        IF @InfoOnly = 0
        BEGIN
            /*усложняем запрос для визуализации данных. 1-ая часть запроса выбирает данные которыми можно оперировать.*/
            /*здесь по сути Пивот резултатов.*/
            SELECT @MaxSortOrder = MAX(SortOrder) FROM #Res

            SET @Counter = 1

            WHILE @MaxSortOrder >= @Counter
            BEGIN
                SELECT TOP 1 @Query = ISNULL(@Query + ', ', '') + '[' + a.Name + '] varchar(255)'
                FROM #Res a
                WHERE a.SortOrder = @Counter
                SET @Counter = @Counter + 1     
            END

            /*заготовка результируюбщей таблицы*/
            CREATE TABLE #Out(G_ID int )

            SELECT @Query = 'ALTER TABLE #Out ADD ' + @Query

            EXEC(@Query)

            DECLARE @G_ID int, @Value varchar(255), @Name varchar(255), @SortOrder int

            DECLARE #Cur1 CURSOR LOCAL FOR SELECT G_ID, ID, [Value], [Name], SortOrder FROM #Res
                                           ORDER BY G_ID ASC, SortOrder
            OPEN #Cur1
            FETCH NEXT FROM #Cur1 INTO @G_ID, @ID, @Value, @Name, @SortOrder
            WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @Query = ''
                IF @SortOrder = 1
                BEGIN
                    SELECT @Query = 'INSERT INTO #Out(G_ID) SELECT ' + CAST(@G_ID AS Varchar)
                    SELECT @Query = @Query + ' UPDATE #Out SET [' + @Name + '] = ''' + @Value + ''' WHERE G_ID = ' + CAST(@G_ID AS Varchar)        
                END
                ELSE
                    SELECT @Query = 'UPDATE #Out SET [' + @Name + '] = ''' + @Value + ''' WHERE G_ID = ' + CAST(@G_ID AS Varchar)
                EXEC (@Query)

                FETCH NEXT FROM #Cur1 INTO @G_ID, @ID, @Value, @Name, @SortOrder
            END
            CLOSE #Cur1
            DEALLOCATE #Cur1

            SELECT * FROM #Out
        END
    END
    DROP TABLE #Tmp  
    IF @InfoOnly = 0 
    BEGIN
        DROP TABLE #Out
        DROP TABLE #Res
    END
    IF @InfoOnly = 1
        DROP TABLE #Res   
END
GO