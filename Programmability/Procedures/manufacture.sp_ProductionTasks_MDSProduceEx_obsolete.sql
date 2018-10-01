SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   07.11.2016$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   22.12.2016$*/
/*$Version:    1.00$   $Decription: Production for assembling     $*/
create PROCEDURE [manufacture].[sp_ProductionTasks_MDSProduceEx_obsolete]
    @JobStageID int,
    @StorageStructureID int,
    @ProductionTasksID int,
    @ShiftID int,
    @EmployeeID int,
    @isCheck bit = 1 /* If true - don't produce, only return data for check */
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @SomeTmcID int, @ColumnName varchar(255), @Query varchar(8000), @TableName varchar(16), @Amount int
    DECLARE @Err Int, @StatusID int, @PCCID int, @DocID int, @SectorID int
    DECLARE @t TABLE(ID int)

    IF object_id('tempdb..#TmcGroups') is not null DROP TABLE #TmcGroups
    CREATE TABLE #TmcGroups (StorageStructureID int, [Min] varchar(255), [Max] varchar(255), [Count] int, TmcID int, isPacked bit, JobStageID int, GroupColumnName varchar(255), isMajorTMC bit, EmployeeGroupsFactID int)
	
    DELETE FROM #MDSProduce
    SELECT @SectorID = manufacture.fn_GetSectorID_JobStageID_SSID (@JobStageID, @StorageStructureID)
        
    IF @SectorID IS NULL
    BEGIN
        RAISERROR ('Участок не найден для выбранного рабочего места. Выполнение прервано.', 16, 1)
        RETURN
    END        

    /* Получаем пТМЦ, их которого берется значения для ГП*/
    /* из этого пТМЦ мы берем количество, диапазоны и операторов*/
    /* основная концепция: кол-во произведенной продукции не может отличаться от количества списанных пТМЦ*/
    /* это значить, что пТМЦ1 = Х, пТМЦ2 = Х ... пТМЦN = Х и ГП = Х*/
    /* при этом пТМЦ1 может равняться пТМЦ2 (быть одним и тем же ТМЦ, к примеру, две одинаковые карточки), тогда по пТМЦ1 кол-во продукции в результате группирования по пТМЦ будет равно 2*Х*/
    SELECT @SomeTmcID = jsc.TmcID, @ColumnName = c.GroupColumnName
    FROM manufacture.JobStageChecks jsc
        LEFT JOIN manufacture.PTmcImportTemplateColumns c on c.ID = jsc.ImportTemplateColumnID
        INNER JOIN manufacture.JobStages js on js.OutputNameFromCheckID = jsc.ID
    WHERE jsc.JobStageID = @JobStageID AND jsc.TypeID = 2 AND jsc.isDeleted = 0 AND jsc.TmcID IS NOT NULL

    SET @TableName = 'pTMC_' + CAST(@SomeTmcID as varchar(11))  
    SET @Query = ''

    IF EXISTS(
          SELECT * FROM information_schema.tables t
          WHERE t.TABLE_SCHEMA = 'StorageData'
                AND t.TABLE_NAME = 'pTMC_' + CAST(@SomeTmcID AS Varchar(11)))
    BEGIN          
        SET @Query =     
                    ' INSERT INTO #TmcGroups(StorageStructureID, EmployeeGroupsFactID, [Min], [Max], [Count], TmcID)
                      SELECT p.StorageStructureID, p.EmployeeGroupsFactID, tmin.Value as [min], tmax.Value as [max], p.[Count] as [Count], ' + Cast(@SomeTmcID as varchar(11)) + ' as TmcID 
                      FROM 
                          (SELECT StorageStructureID, p.EmployeeGroupsFactID, min(p.ID) as minID, max(p.ID) as MaxID, count(p.ID) as [Count]
                          FROM [StorageData].' + @TableName +' p
                               INNER JOIN StorageData.G_' + CAST(@JobStageID as varchar(11)) + ' as g on g.' + @ColumnName + ' = p.ID
                               INNER JOIN shifts.EmployeeGroupsFact ef ON p.EmployeeGroupsFactID = ef.ID
                          WHERE p.StatusID = 3 AND ef.ShiftID = ' + CAST(@ShiftID as varchar(11)) + --' AND ef.JobStageID = ' + CAST(@JobStageID as varchar(11)) +
                               ' AND ef.WorkPlaceID = ' + CAST(@StorageStructureID AS varchar(11)) + '
                          GROUP BY p.StorageStructureID, p.EmployeeGroupsFactID) p
                          LEFT JOIN [StorageData].' + @TableName +' tmin on tmin.ID = p.minID
                          LEFT JOIN [StorageData].' + @TableName +' tmax on tmax.ID = p.maxID                              
                    '               
        /*SELECT @Query            */
        EXEC (@Query)            
    END

    SELECT @Amount = SUM(Count) FROM #TmcGroups 
	
    INSERT INTO #MDSProduce(TmcID, Name, Amount, isMajorTMC, [Min], [Max], EmployeeID)
    SELECT tt.TmcID, t.Name, tt.Amount, tt.isMajorTMC, tt.[Min], tt.[Max], tt.EmployeeID
    FROM
        (/*Готовая продукция*/
        SELECT js.OutputTmcID as TmcID, Sum(tg.Count * egf.PercOfWork) as Amount, 1 as isMajorTMC, MIN(tg.[Min]) as [Min], MAX(tg.[Max]) as [Max], egfd.EmployeeID
        FROM manufacture.JobStages js,
             #TmcGroups tg
             INNER JOIN (SELECT s1.EmployeeGroupsFactID as ID, 1.0/COUNT (s1.EmployeeID) as PercOfWork 
                         FROM shifts.EmployeeGroupsFactDetais as s1 
                         GROUP BY s1.EmployeeGroupsFactID) as egf on egf.ID = tg.EmployeeGroupsFactID
             LEFT JOIN shifts.EmployeeGroupsFactDetais as egfd ON egfd.EmployeeGroupsFactID = egf.ID
        WHERE js.ID = @JobStageID AND ISNULL(js.isDeleted,0) = 0 AND js.OutputTmcID is not null
        GROUP BY js.OutputTmcID, egfd.EmployeeID
        UNION ALL
        /*Комплектующие*/
        SELECT jsc.TmcID, @Amount as Amount, 0 as isMajorTMC, null [Min], null [Max], null EmployeeID
        FROM manufacture.JobStageChecks jsc
        WHERE jsc.JobStageID = @JobStageID AND ISNULL(jsc.isDeleted,0) = 0 AND jsc.TmcID is not null AND jsc.TypeID = 2 AND IsNull(jsc.[CheckDB],0) = 1
        UNION ALL
        /*Неперсонализированные ТМЦ*/
        SELECT ko.TMCID, @Amount * Ko.Koef as Amount, 0 as isMajorTMC, null [Min], null [Max], null EmployeeID
        FROM manufacture.JobStageNonPersTMC Ko 
        /*INNER JOIN Tmc t ON t.ID = ko.TMCID*/
             LEFT JOIN manufacture.JobStageChecks jc ON jc.TmcID = ko.TMCID AND jc.JobStageID = @JobStageID AND ISNULL(jc.isDeleted, 0) = 0 AND jc.CheckDB = 1
             LEFT JOIN manufacture.JobStages Js ON js.OutputTmcID = ko.TMCID AND js.ID = @JobStageID
        WHERE  Ko.JobStageID = @JobStageID
             AND jc.id IS NULL
             AND js.ID IS NULL
		) tt
        INNER JOIN Tmc t ON t.ID = tt.TMCID        
	WHERE @Amount > 0
    
	IF (@isCheck = 0) AND (@Amount > 0)
    BEGIN        
        SELECT @PCCID = j.ProductionCardCustomizeID
        FROM manufacture.JobStages js 
        INNER JOIN manufacture.Jobs j ON j.ID = js.JobID AND ISNULL(j.isDeleted, 0) = 0
        WHERE js.ID = @JobStageID AND ISNULL(js.isDeleted, 0) = 0
        
        /*Get Sector Auto Status or gain from interface*/
        SELECT @StatusID = a.ProductionTasksStatusID
        FROM manufacture.StorageStructureManufactures a
        INNER JOIN dbo.ProductionCardTypes t ON t.ManufactureID = a.ManufactureStructureID
        INNER JOIN dbo.ProductionCardCustomize c ON c.ID = @PCCID AND c.TypeID = t.ProductionCardPropertiesID
        WHERE a.StorageStructureID = @StorageStructureID
                    
        SET XACT_ABORT ON;
        BEGIN TRAN
        BEGIN TRY
            SET @DocID = NULL
            
            SELECT @DocID = del.ID
            FROM manufacture.ProductionTasksDocs del 
            	 INNER JOIN manufacture.ProductionTasksDocDetails d ON d.ProductionTasksDocsID = del.ID
            WHERE del.ProductionTasksID = @ProductionTasksID AND del.ProductionTasksOperTypeID = 2
                  AND d.ProductionCardCustomizeID = @PCCID AND del.JobStageID = @JobStageID

            IF @DocID IS NOT NULL 
            BEGIN
                EXEC manufacture.sp_ProductionTasksDocsHistory_Insert @EmployeeID, @DocID, 2
                            
                DELETE
                FROM manufacture.ProductionTasksDocs 
                WHERE ID = @DocID
            END
                
            INSERT INTO manufacture.ProductionTasksDocs (ProductionTasksID, [EmployeeToID],
                StorageStructureSectorID, ProductionTasksOperTypeID, JobStageID)
            OUTPUT INSERTED.ID INTO @t
            SELECT @ProductionTasksID, @EmployeeID, @SectorID, 2/*производство*/, @JobStageID
            
            SELECT @DocID = ID FROM @t
            DELETE FROM @t

            /*Next Step - Готовая продукция и Списание материалов */
            INSERT INTO manufacture.ProductionTasksDocDetails(TMCID, ProductionCardCustomizeID, Amount, [Name], MoveTypeID, 
                isMajorTMC, StatusID, ProductionTasksDocsID, StatusFromID, ProductionCardCustomizeFromID, EmployeeID, RangeFrom, RangeTo)
            OUTPUT INSERTED.ID INTO @t
            SELECT 
                e.TMCID, 
                @PCCID, 
                e.Amount, 
                t.[Name],
                1,
                e.isMajorTMC,
                CASE WHEN isMajorTMC = 1 THEN @StatusID ELSE 2 END,
                @DocID,
                1,
                CASE WHEN ko.ID IS NULL THEN @PCCID ELSE NULL END,
                e.EmployeeID,
                e.[Min],
                e.[Max]
            FROM #MDSProduce e
                 LEFT JOIN Tmc t ON t.ID = e.TMCID
                 LEFT JOIN manufacture.JobStageNonPersTMC Ko ON ko.TmcID = e.TMCID AND Ko.JobStageID = @JobStageID

            SELECT @DocID
            COMMIT TRAN
        END TRY
        BEGIN CATCH
            SET @Err = @@ERROR
            IF @@TRANCOUNT > 0 ROLLBACK TRAN
            EXEC sp_RaiseError @ID = @Err
        END CATCH
	END
END
GO