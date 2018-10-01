SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   01.09.2017$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   01.09.2017$*/
/*$Version:    1.00$   $Decription: Поиск диапазона для отката упаковки ЦС по диапазону$*/
CREATE PROCEDURE [manufacture].[sp_MDS_UndoByRange_Select] (@JobStageID int, @FromValue varchar(255), @ToValue varchar(255))
AS
BEGIN
--DECLARE @JobStageID int, @FromValue varchar(255), @ToValue varchar(255)  
/*SET @JobStageID = 786
SET @FromValue = '1'
SET @ToValue = '2'*/
    DECLARE @Query varchar(8000)
    --Ищем @FromValue
    CREATE TABLE #Tmp (ID int, TmcID int, SortOrder tinyint)
    --мы не знаем какой ТМЦ сканируется , поэтому ищем тупо всю цепочку
    --ТМЦ, так как разницы нет в итоге по какому ТМЦ работать, но для поиска АЙДИшки это нужно         
    --в итоге по валью нашли ТМЦ и если номера вдруг схожи берем топ 1
    SELECT @Query = ISNULL(@Query + ' UNION ALL ', '') + 
      ' SELECT p.ID, ' + CAST(jc.TmcID AS Varchar(36)) + ' AS TmcID, 
        1 AS SortOrder
        FROM StorageData.pTMC_' + CAST(jc.TmcID AS Varchar(36)) + ' AS p ' +
      ' WHERE p.Value = ''' + @FromValue + ''' AND StatusID = 3 '
    FROM manufacture.JobStageChecks jc
    WHERE jc.JobStageID = @JobStageID AND jc.isDeleted = 0 AND jc.TypeID = 2 AND jc.UseMaskAsStaticValue = 0

    SELECT @Query = ISNULL('INSERT INTO #Tmp (ID, TmcID, SortOrder) SELECT TOP 1 res.* FROM ( ' + @Query + ')  AS res ', '')
    EXEC (@Query)
    SELECT @Query = NULL
    
    --Ищем @ToValue
    --мы не знаем какой ТМЦ сканируется , поэтому ищем тупо всю цепочку
    --ТМЦ, так как разницы нет в итоге по какому ТМЦ работать, но для поиска АЙДИшки это нужно         
    --в итоге по валью нашли ТМЦ и если номера вдруг схожи берем топ 1
    SELECT @Query = ISNULL(@Query + ' UNION ALL ', '') + 
      ' SELECT p.ID, ' + CAST(jc.TmcID AS Varchar(36)) + ' AS TmcID, 
        2 AS SortOrder
        FROM StorageData.pTMC_' + CAST(jc.TmcID AS Varchar(36)) + ' AS p ' +
      ' WHERE p.Value = ''' + @ToValue + ''' AND StatusID = 3 '
    FROM manufacture.JobStageChecks jc
    WHERE jc.JobStageID = @JobStageID AND jc.isDeleted = 0 AND jc.TypeID = 2 AND jc.UseMaskAsStaticValue = 0

    SELECT @Query = ISNULL('INSERT INTO #Tmp (ID, TmcID, SortOrder) SELECT TOP 1 res.* FROM ( ' + @Query + ')  AS res ', '')
    EXEC (@Query)

    --ПРОВЕРКА. Должно быть найдено 2 записи, мин и макс.
    IF (SELECT COUNT(ID) FROM #Tmp) <> 2
    BEGIN
        DROP TABLE #Tmp
        RAISERROR('Диапазон в упакованной продукции не найден', 16, 1)
        SELECT NULL
        RETURN
    END
    
    --Выберем записи для обработки входящие в найденный диапазон.
    DECLARE @MinID int, @MaxID int, @STmcID int    
    SELECT @MinID = ID, @STmcID = TmcID FROM #Tmp WHERE SortOrder = 1    
    SELECT @MaxID = ID FROM #Tmp WHERE SortOrder = 2 
       
    SELECT @Query = ' DECLARE @MinID int, @MaxID int SET @MinID = '+ CAST(@MinID AS VARCHAR)+ ' SET @MaxID = ' + CAST(@MaxID AS VARCHAR)+ '
           SELECT * FROM StorageData.pTMC_' + CAST(@STmcID AS VARCHAR)+ '
           WHERE ID BETWEEN (CASE WHEN @MinID > @MaxID THEN @MaxID ELSE @MinID END) AND (CASE WHEN @MinID < @MaxID THEN @MaxID ELSE @MinID END)'
    EXEC(@Query)
            
--    SELECT * FROM #Tmp
    DROP TABLE #Tmp
END
GO