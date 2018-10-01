SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   14.09.2017$
--$Modify:     Poliatykin Oleksii$    $Modify date:   13.11.2017$
--$Version:    1.00$   $Decription: Выводит комплекты ТМС сборки в рамках JobStageID$
CREATE PROCEDURE [manufacture].[sp_MDS_SearchValue] @Search VARCHAR(255),
@JobStageID INT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE  @Numbering INT                  -- нумерация последовательности
           , @TMCId INT
           , @Name NVARCHAR(500)             --ТМЦ принимаемое участие в сборке
           , @Colmns VARCHAR(MAX)            -- Накопительна часть столбцов
           , @LeftJoin VARCHAR(MAX)          -- Накопительные лефт жоины
           , @where VARCHAR(MAX)             -- Накопительные фильтры
           , @query VARCHAR(MAX)             -- Итоговый запрос
           , @TMCIdFP INT
           , @NameFP NVARCHAR(500)           -- ТМЦ готовой продукции
    DECLARE Cursor_1 CURSOR STATIC LOCAL FOR  -- получаем список участвующих тмц и тмц для готовой продукции
    SELECT
        jsc.SortOrder
       ,jsc.TmcID
       ,tmc.Name
       ,CASE
            WHEN jsc.TmcID = jscGp.TmcID THEN js.OutputTmcID
        ELSE 0
        END AS TmcIdFP
       ,tmcGP.Name AS NameGP
    FROM manufacture.JobStages js
    INNER JOIN manufacture.JobStageChecks jsc ON js.ID = jsc.JobStageID AND ISNULL(jsc.isDeleted, 0) = 0
    LEFT JOIN tmc ON Tmc.ID = jsc.TmcID
    LEFT JOIN tmc tmcGP ON tmcGP.ID = js.OutputTmcID
    LEFT JOIN manufacture.JobStageChecks jscGp ON jscgp.id = js.OutputNameFromCheckID
    WHERE jsc.JobStageID = @JobStageID
    ORDER BY jsc.SortOrder
		
    OPEN Cursor_1 -- собираем части итогового запроса 
    FETCH NEXT FROM Cursor_1 INTO @Numbering, @TMCId, @Name, @TMCIdFP, @NameFP
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- название тмц используем как имя колонки
        SET @Colmns = ISNULL(@Colmns, '') + ', tmc_' + CAST(@Numbering AS VARCHAR(255)) + '.Value as [' + @Name + '] ' +
        ', pts_' + CAST(@Numbering AS VARCHAR(255)) + '.Name as Статус_' + CAST(@Numbering AS VARCHAR(255)) + ', ss_' + CAST(@Numbering AS VARCHAR(255)) + '.Name as РМ_' + CAST(@Numbering AS VARCHAR(255)) + ' '
        -- собираем итоговый лефт жоин
        SET @LeftJoin = ISNULL(@LeftJoin, '') +
        ' LEFT JOIN StorageData.pTMC_' + CAST(@TMCId AS VARCHAR(255)) + ' tmc_' + CAST(@Numbering AS VARCHAR(255)) + ' ON tmc_' + CAST(@Numbering AS VARCHAR(255)) + '.ID = g.Column_' + CAST(@Numbering AS VARCHAR(255)) +
        ' LEFT JOIN tmc tmc' + CAST(@Numbering AS VARCHAR(255)) + ' ON tmc' + CAST(@Numbering AS VARCHAR(255)) + '.ID = tmc_' + CAST(@Numbering AS VARCHAR(255)) + '.TMCID ' +
        ' LEFT JOIN manufacture.PTmcStatuses pts_' + CAST(@Numbering AS VARCHAR(255)) + ' ON pts_' + CAST(@Numbering AS VARCHAR(255)) + '.ID = tmc_' + CAST(@Numbering AS VARCHAR(255)) + '.StatusID ' +
        ' LEFT JOIN manufacture.StorageStructure ss_' + CAST(@Numbering AS VARCHAR(255)) + ' ON ss_' + CAST(@Numbering AS VARCHAR(255)) + '.ID = tmc_' + CAST(@Numbering AS VARCHAR(255)) + '.StorageStructureID '
        -- собираем условия фильтрации для любого тмц входящего в сборку 
        SET @where = ISNULL(@where + ' UNION ', '') + ' SELECT G.ID FROM StorageData.G_' + CAST(@JobStageID AS VARCHAR(255)) + ' g' +
        ' join StorageData.pTMC_' + CAST(@TMCId AS VARCHAR(255)) + ' tmc_' + CAST(@Numbering AS VARCHAR(255)) + ' ON tmc_' + CAST(@Numbering AS VARCHAR(255)) + '.ID = g.Column_' + CAST(@Numbering AS VARCHAR(255)) + ' WHERE tmc_' + CAST(@Numbering AS VARCHAR(255)) + '.Value = ''' + @Search + ''' '
        -- если обрабатываемц тмц используется для заполнения Value готовой продукции то добавляем колонку и лефт жоин для готовой продукции
        IF @TMCIdFP <> 0
        BEGIN
            SET @Colmns = ', tmc_GP.Value as [' + @NameFP + '] , pts_GP.Name as Статус, ss_GP.Name as РМ ' + ISNULL(@Colmns, '')
            SET @LeftJoin = ISNULL(@LeftJoin, '') +
            ' LEFT JOIN StorageData.pTMC_' + CAST(@TMCIdFP AS VARCHAR(255)) + ' tmc_GP ON tmc_GP.Value = tmc_' + CAST(@Numbering AS VARCHAR(255)) + '.Value ' +
            ' LEFT JOIN manufacture.PTmcStatuses pts_GP ON pts_GP.ID = tmc_GP.StatusID ' +
            ' LEFT JOIN manufacture.StorageStructure ss_GP ON ss_GP.ID = tmc_GP.StorageStructureID '
        END

    FETCH NEXT FROM Cursor_1 INTO @Numbering, @TMCId, @Name, @TMCIdFP, @NameFP
    END
    CLOSE Cursor_1
    DEALLOCATE Cursor_1
    -- общий запрос выводит строку перед найденой и строку после найденной. Обязательно используем дистинкт 
    SET @query = 'SELECT g.id ' + @Colmns +
    ' FROM StorageData.G_' + CAST(@JobStageID AS VARCHAR(255)) + ' g' +
    @LeftJoin + ' where   g.id IN ( SELECT A.ID-1 FROM (' + @where + ') A UNION  SELECT A.ID FROM (' + @where + ') A UNION SELECT A.ID+1 FROM (' + @where + ') A  ) '

    EXEC (@query)
--   SELECT @query

END
GO