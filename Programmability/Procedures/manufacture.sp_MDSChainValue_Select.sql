SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    		$Create date:   19.08.2014$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   14.12.2016$*/
/*$Version:    1.00$   $Decription: Выбор цепочки комплектующих Готовой Продукции(включая ГП)$*/
CREATE PROCEDURE [manufacture].[sp_MDSChainValue_Select] (@SomeID int, @SomeColName varchar(255), @JobStageID int, @IncludeFinalProduct bit = 0)
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @Query varchar(8000)
    DECLARE @OutputTmcID int
    --Таблица #Out - результат пишем в неё.
    CREATE TABLE #Out (G_ID int, ID int, [Value] varchar(255), [Name] varchar(255), SortOrder int, TypeID int, 
      JobStageChecksID int, OutputNameFromTmcID int, OutputTmcID int, TmcID int)

    -- соберем одна за другой строчки запроса выбирающего данные (по SortOrder из JobStageChecks)
    SELECT @Query = ISNULL(@Query + ' UNION ALL ' + Char(13) + Char(10), '') +
        ' SELECT @ID AS G_ID, ID, [Value], ''' + jj.[Name] + ''' AS Name, ' + 
              CAST(jj.SortOrder AS VarChar) + ' AS SortOrder,' + Char(13) + Char(10) + 
              CAST(jj.TypeID AS VarChar) + ' AS TypeID, ' + Char(13) + Char(10) + 
              CAST(jj.ID AS VarChar) + ' AS JobStageChecksID, ' + Char(13) + Char(10) +
              CASE WHEN jOutputName.OutputNameFromCheckID IS NULL THEN 'NULL' ELSE CAST(jj.TmcID AS Varchar) + ' AS OutputNameFromTmcID' END + ', ' + Char(13) + Char(10) + 
              CASE WHEN jOutputTmcID.ID IS NULL THEN 'NULL' ELSE CAST(jj.TmcID AS Varchar) + ' AS OutputTmcID' END + ', ' + Char(13) + Char(10) + 
              CAST(jj.TmcID AS VarChar) + ' AS TmcID' + Char(13) + Char(10) +
        ' FROM StorageData.pTMC_' + CAST(jj.TmcID AS VarChar) + Char(13) + Char(10) + ' WHERE ID = ' +
        '(SELECT ' + ic.GroupColumnName + ' FROM [StorageData].G_'+ CAST(@JobStageID AS varchar) + 
        ' WHERE ID = @ID)' + Char(13) + Char(10)
    FROM manufacture.JobStageChecks jj
    LEFT JOIN manufacture.JobStages jOutputName ON jOutputName.ID = jj.JobStageID AND jj.ID = jOutputName.OutputNameFromCheckID
    LEFT JOIN manufacture.JobStages jOutputTmcID ON jOutputTmcID.ID = jj.JobStageID AND jj.TmcID = jOutputTmcID.OutputTmcID    
    INNER JOIn manufacture.PTmcImportTemplateColumns ic ON ic.ID = jj.ImportTemplateColumnID
    WHERE ic.GroupColumnName IS NOT NULL AND jj.JobStageID = @JobStageID AND jj.isDeleted = 0 AND jj.UseMaskAsStaticValue = 0
    ORDER BY jj.SortOrder

    --Выолняем выборку тары и комплектов.
    SELECT
     @Query = ' DECLARE @ID int SELECT @ID = ID FROM [StorageData].G_' + CAST(@JobStageID AS varchar) + 
              ' WHERE ' + @SomeColName + ' = ' + CAST(@SomeID AS varchar) + Char(13) + Char(10) +
              ' INSERT INTO #Out (G_ID, ID, [Value], [Name], SortOrder, TypeID, JobStageChecksID, OutputNameFromTmcID, OutputTmcID, TmcID) ' + 
              + Char(13) + Char(10) +
              @Query
    EXEC (@Query)
    SELECT @Query = NULL
    -- Если включать ГП, то выпоняем поиск данных ГП и добавляем эту запись в конец списка
    IF @IncludeFinalProduct = 1
    BEGIN  --если включена готовая продукция, то добавляем в конец данные о ней.
        SELECT @OutputTmcID = OutputTmcID FROM manufacture.JobStages WHERE ID = @JobStageID
        SELECT @Query =
        ' INSERT INTO #Out (G_ID, ID, [Value], [Name], SortOrder, TypeID, JobStageChecksID, OutputNameFromTmcID, OutputTmcID, TmcID) '  + Char(13) + Char(10) +             
        'SELECT
            (SELECT TOP 1 G_ID FROM #Out),
            ID, 
            [Value],
            (SELECT ''(ГП) '' + Name FROM Tmc WHERE ID = ' + CAST(@OutputTmcID AS Varchar) + '),
            (SELECT Max(SortOrder) + 1 FROM #Out),
            3, NULL, NULL, ' + CAST(@OutputTmcID AS Varchar) + ', 
            ' + CAST(@OutputTmcID AS Varchar) + Char(13) + Char(10) +                
        ' FROM StorageData.pTMC_' + CAST(@OutputTmcID AS Varchar) + 
        ' WHERE ParentPTMCID = (SELECT TOP 1 ID FROM #Out WHERE TypeID = 1 ORDER BY SortOrder DESC) 
          AND Value = (SELECT Value FROM #Out WHERE OutputNameFromTmcID IS NOT NULL) '
        EXEC (@Query)
    END

    SELECT * FROM #Out
    DROP TABLE #Out
END
GO