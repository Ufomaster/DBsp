SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   26.05.20176$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   23.06.2017$*/
/*$Version:    1.00$   $Decription: Вывод данных для просомтра по существующей продукции и изготовелнной$*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncProduceMDS_Prepare]
    @JobStageID int,
    @ShiftID int,
    @PCCID int --не используется пока
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Query varchar(8000)
    --заполним ТЕКУЩИЕ материалы на РМ
    CREATE TABLE #CurData(TmcID int, Name varchar(255), Amount decimal(38,10), StorageStructureID int)

    SELECT @Query = ISNULL(@Query + ' UNION ALL ', '') + 
    '    SELECT ' + CAST(j.TmcID AS varchar) + ', ''' + REPLACE(t.[Name], '''', '''''') + ''', COUNT([Value]), b.StorageStructureID 
         FROM StorageData.pTMC_' + CAST(j.TmcID AS varchar) + ' AS b
         WHERE b.StatusID = 2
         GROUP BY b.StorageStructureID '
    FROM manufacture.JobStageChecks j
    LEFT JOIN Tmc t ON t.ID = j.TmcID
    INNER JOIN manufacture.PTmcImportTemplateColumns pic ON pic.ID = j.ImportTemplateColumnID
    WHERE j.JobStageID = @JobStageID AND ISNULL(j.isDeleted, 0) = 0 AND j.[CheckDB] = 1
     AND j.TypeID = 2 --проигнорим тару, так как она не списывается.
    ORDER BY j.SortOrder

    SELECT @Query = ' INSERT INTO #CurData(TmcID, Name, Amount, StorageStructureID) ' + @Query
    EXEC(@Query)

/*    --заполним произведенную продукцию
    IF OBJECT_ID('tempdb..#TmcMDS') IS NOT NULL
         TRUNCATE TABLE #TmcMDS ELSE
    CREATE TABLE #TmcMDS(StorageStructureID int, EmployeeGroupsFactID int, Amount decimal(38, 10), StatusID int, TmcID int, DataType smallint)
    
    INSERT INTO #TmcMDS
    EXEC manufacture.sp_ProductionTasks_FuncProduceMDS_CSOverview @JobStageID, @ShiftID, @PCCID*/

    SELECT Res.TmcID, Res.Name, Res.TmcName, Res.Amount, Res.LastsAmount, Res.SortOrder, Res.DataType
    FROM(
        SELECT a.TmcID, ss.Name, t.Name AS TmcName, SUM(a.Amount) AS Amount, NULL AS LastsAmount, 0 AS SortOrder, 0 AS DataType
        FROM #TmcGroups a
--        INNER JOIN manufacture.JobStages j ON j.ID = @JobStageID
        INNER JOIN Tmc t ON t.ID = a.TmcID
        INNER JOIN manufacture.StorageStructureSectorsDetails sdet ON sdet.StorageStructureID = a.StorageStructureID
        INNER JOIN manufacture.StorageStructureSectors ss ON ss.ID = sdet.StorageStructureSectorID
        WHERE a.DataType = 0
        GROUP BY a.TmcID, ss.Name, t.Name

        UNION ALL
        
        SELECT d.TmcID, ss.Name, d.Name AS TmcName, NULL, Amount, 1, 2
        FROM #CurData d 
        INNER JOIN manufacture.StorageStructureSectorsDetails sdet ON sdet.StorageStructureID = d.StorageStructureID
        INNER JOIN manufacture.StorageStructureSectors ss ON ss.ID = sdet.StorageStructureSectorID
        WHERE d.StorageStructureID IN (SELECT StorageStructureID FROM #TmcGroups GROUP BY StorageStructureID)
        ) AS Res
    ORDER BY Res.TmcID, Res.Name, Res.SortOrder, Res.DataType

    DROP TABLE #CurData
END
GO