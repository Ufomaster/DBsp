SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   12.06.20176$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   25.10.2017$*/
/*$Version:    1.00$   $Decription: Выборка всех ТМЦ по РМ ЦС - ГП, брак, списано, ПТМЦ, НПТМЦ$*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncProduceMDS_CSOverview]
    @JobStageID int,
    @ShiftID int,
    @PCCID int
AS
BEGIN
--DECLARE
--    @JobStageID int = 786,
--  @ShiftID int = 4355,
--    @ShiftID int =4383,
--    @PCCID int = 12326
    SET NOCOUNT ON

    IF OBJECT_ID('tempdb..#TmcGroups') IS NOT NULL TRUNCATE TABLE #TmcGroups

/*CREATE TABLE #TmcGroups(StorageStructureID int, EmployeeGroupsFactID int, Amount decimal(38, 10), StatusID int, TmcID int, DataType smallint)*/
--DataType 0-ГП, 1-ПТМЦ, 2-НПТМЦ
    DECLARE @SomeTmcID int, @ColumnName varchar(255), @TableName varchar(16), @OutputTmcID int, @Kind tinyint
    DECLARE @Query varchar(8000)
    SELECT @SomeTmcID = jsc.TmcID, @ColumnName = c.GroupColumnName
    FROM manufacture.JobStageChecks jsc
    LEFT JOIN manufacture.PTmcImportTemplateColumns c on c.ID = jsc.ImportTemplateColumnID
    INNER JOIN manufacture.JobStages js on js.OutputNameFromCheckID = jsc.ID
    WHERE jsc.JobStageID = @JobStageID AND jsc.TypeID = 2 AND jsc.isDeleted = 0 AND jsc.TmcID IS NOT NULL

    SELECT @OutputTmcID = js.OutputTmcID, @Kind = js.Kind
    FROM manufacture.JobStages js WHERE js.ID = @JobStageID AND ISNULL(js.isDeleted,0) = 0 AND js.OutputTmcID IS NOT NULL
    --заполним произведенную продукцию
    SET @Query =' INSERT INTO #TmcGroups(StorageStructureID, EmployeeGroupsFactID, Amount, StatusID, TmcID, DataType)
                  SELECT ef.WorkPlaceID, p.EmployeeGroupsFactID, Count(p.ID), p.StatusID, ' + Cast(@OutputTmcID as varchar(20)) + ', 0
                  FROM [StorageData].pTMC_' + CAST(@SomeTmcID as varchar(20)) + ' p
                  INNER JOIN StorageData.G_' + CAST(@JobStageID AS varchar(20)) + ' as g on g.' + @ColumnName + ' = p.ID
                  INNER JOIN shifts.EmployeeGroupsFact ef ON p.EmployeeGroupsFactID = ef.ID
                  WHERE p.StatusID = 3 AND ef.ShiftID = ' + CAST(@ShiftID as varchar(20)) + '
                  GROUP BY ef.WorkPlaceID, p.EmployeeGroupsFactID, p.StatusID '
    EXEC (@Query)
    SET @Query = NULL

    --заполним списанные материалы на РМ - кол-во
    SELECT @Query = ISNULL(@Query + ' UNION ALL ', '') +
    '    SELECT ' + CAST(j.TmcID AS varchar) + ', NULL, COUNT([Value]), ISNULL(ef.WorkPlaceID, p.StorageStructureID), p.StatusID, 1
         FROM StorageData.pTMC_' + CAST(j.TmcID AS varchar) + ' AS p
         INNER JOIN StorageData.G_' + CAST(@JobStageID AS varchar(20)) + ' as g on g.' + pic.GroupColumnName + ' = p.ID
         LEFT JOIN shifts.EmployeeGroupsFact ef ON p.EmployeeGroupsFactID = ef.ID
         WHERE (p.StatusID = 3 AND ef.ShiftID = ' + CAST(@ShiftID as varchar(20)) + ') OR (p.StatusID = 4 AND p.StorageStructureID NOT IN (14,15))
         GROUP BY ISNULL(ef.WorkPlaceID, p.StorageStructureID), p.StatusID '
    FROM manufacture.JobStageChecks j
    INNER JOIN manufacture.PTmcImportTemplateColumns pic ON pic.ID = j.ImportTemplateColumnID
    WHERE j.JobStageID = @JobStageID AND ISNULL(j.isDeleted, 0) = 0 --AND j.[CheckDB] = 1
    ORDER BY j.SortOrder

    SELECT @Query = 'INSERT INTO #TmcGroups(TmcID, EmployeeGroupsFactID, Amount, StorageStructureID, StatusID, DataType) ' + @Query
    EXEC(@Query)
    SET @Query = NULL

    /*Неперсонализированные ТМЦ*/
    INSERT INTO #TmcGroups(TmcID, EmployeeGroupsFactID, Amount, StorageStructureID, StatusID, DataType)
    SELECT
        d.TmcID,
        NULL,
        tg.Amount * (CASE WHEN otaNormSkip.ID IS NULL THEN d.Norma/pc.CardCountInvoice ELSE 1 END),
        tg.StorageStructureID,
        3,
        2
    FROM (SELECT SUM(Amount) AS Amount, StorageStructureID --Это Кол-во ГП на РМ.
          FROM #TmcGroups WHERE DataType = 0 GROUP BY StorageStructureID) AS tg
     , dbo.ProductionCardCustomizeMaterials AS d --декартово произведение. все материалы из СЛ на все РМ с амаунтом.
    INNER JOIN ProductionCardCustomize PC ON PC.ID = d.ProductionCardCustomizeID AND d.ProductionCardCustomizeID = @PCCID
    INNER JOIN Tmc t ON t.ID = d.TmcID
    INNER JOIN ProductionCardCustomizeDetails det ON det.Kind = @Kind AND det.TmcID = t.ID AND det.ProductionCardCustomizeID = @PCCID
    INNER JOIN ObjectTypes ot ON ot.ID = t.ObjectTypeID
    LEFT JOIN ObjectTypesAttributes otaNormSkip ON otaNormSkip.ObjectTypeID = ot.ID AND otaNormSkip.AttributeID = 25
    LEFT JOIN manufacture.JobStageChecks jc ON jc.TmcID = d.TMCID AND jc.JobStageID = @JobStageID AND ISNULL(jc.isDeleted, 0) = 0 AND jc.CheckDB = 1
    LEFT JOIN manufacture.JobStages Js ON js.OutputTmcID = d.TMCID AND js.ID = @JobStageID
    WHERE d.TmcID IN (SELECT ID FROM dbo.fn_TMCLinkedToSectors_Select(0, d.TmcID, tg.StorageStructureID)) 
        AND ISNULL(t.IsHidden, 0) = 0 AND t.Code1C IS NOT NULL
        AND jc.id IS NULL
        AND js.ID IS NULL

    UNION ALL

    SELECT r.TmcID, NULL, SUM(r.Amount), ef.WorkPlaceID, 4, 2
    FROM manufacture.PTmcFailRegister r
    INNER JOIN shifts.EmployeeGroupsFact ef ON r.EmployeeGroupFactID = ef.ID AND ISNULL(ef.IsDeleted, 0) = 0
    WHERE ef.JobStageID = @JobStageID AND ef.ShiftID = @ShiftID
    GROUP BY r.TmcID, ef.WorkPlaceID
END
GO