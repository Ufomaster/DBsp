SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   21.08.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   18.11.2014$*/
/*$Version:    1.00$   $Decription: Выбор цепочки комплектующих Готовой Продукции(включая ГП) 
для функции УНДО. @InfoOnly=1 выбирает информацию для выполения операций,
                  @InfoOnly=0 выдает читабельный вид для пользователя$
                  @SomeID - айдишка финальной записи на которой ошибка или что. от неё пляшем вначало на 10 записей*/
CREATE PROCEDURE [manufacture].[sp_MDS_Undo] (@JobStageID int, @StorageStructureID int, @InfoOnly bit)
AS
BEGIN
    CREATE TABLE #Res (G_ID int NOT NULL, ID int, [Value] varchar(255), [Name] varchar(255), SortOrder int, TypeID int, 
         JobStageChecksID int, OutputNameFromTmcID int, OutputTmcID int, TmcID int, isCheckDB bit, ColumnName varchar(255), NoLinks bit)       

    DECLARE @Counter int, @Query varchar(8000), @SomeTmcID int, @SomeColName varchar(8000), @NoLinks bit
    --Ищем первый попавшийся комплект с наличием импортированных номеров в БД
    SELECT TOP 1 @SomeTmcID = jj.TmcID, @SomeColName = itc.GroupColumnName
    FROM manufacture.JobStageChecks jj
    INNER JOIN manufacture.PTmcImportTemplateColumns itc ON itc.ID = jj.ImportTemplateColumnID
    WHERE /*jj.[CheckDB] = 1 AND*/ jj.isDeleted = 0 AND jj.JobStageID = @JobStageID AND jj.TypeID = 2
    ORDER BY jj.SortOrder

    --ищем текущий обрабатываемый номерок
    SELECT @Query = '              
    DECLARE @ID int
    DECLARE #Cur CURSOR LOCAL FOR 
        SELECT TOP 10 sd.ID FROM StorageData.G_' + CAST(@JobStageID AS varchar) + ' a
        INNER JOIN StorageData.pTMC_' + CAST(@SomeTmcID AS varchar) + ' sd ON sd.ID = a.' + @SomeColName + '
        WHERE sd.StorageStructureID = ' + CAST(@StorageStructureID AS varchar) + ' AND sd.StatusID = 3
        ORDER BY sd.ID DESC
    OPEN #cur
    FETCH NEXT FROM #Cur INTO @ID
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        INSERT INTO #Res (G_ID, ID, [Value], [Name] , SortOrder, TypeID , 
          JobStageChecksID, OutputNameFromTmcID , OutputTmcID, TmcID)
        EXEC manufacture.sp_MDSChainValue_Select @ID, ''' + @SomeColName + ''', ' + CAST(@JobStageID AS varchar) + ', 1

        FETCH NEXT FROM #Cur INTO @ID
    END
    CLOSE #Cur
    DEALLOCATE #Cur '      
    
    EXEC (@Query)
    SET @Query = NULL
    
    IF EXISTS(SELECT ID FROM manufacture.JobStageChecks a 
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

    DECLARE @MaxSortOrder int 

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

        DECLARE @G_ID int, @ID int, @Value varchar(255), @Name varchar(255), @SortOrder int

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
    IF @InfoOnly = 0 
    BEGIN
        DROP TABLE #Out
        DROP TABLE #Res
    END
    IF @InfoOnly = 1
        DROP TABLE #Res
END
GO