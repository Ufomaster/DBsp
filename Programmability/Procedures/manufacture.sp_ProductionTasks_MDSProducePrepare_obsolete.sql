SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   02.09.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   03.11.2016$*/
/*$Version:    1.00$   $Decription: $*/
create PROCEDURE [manufacture].[sp_ProductionTasks_MDSProducePrepare_obsolete]
    @MainJobStageID int,
    @StorageStructureID int,
    @ProductionTasksID int = 0,
    @ShiftID int
AS
BEGIN


    RETURN;
    -- OBSOLETE
	SET NOCOUNT ON;
    CREATE TABLE #TmcGroups (StorageStructureID int, [StatusID] int, [Batch] varchar(20), [Min] varchar(255), [Max]varchar(255), [Count] int, TmcID int, isPacked bit, JobStageID int, GroupColumnName varchar(255), isMajorTMC bit)
            
    DECLARE @TMCID int, @JobStageID int, @TableName varchar(50), @JobID int, @GroupColumnName varchar(18),
            @Err int, @Query varchar(MAX), @QueryNull varchar(MAX), @Type bit, @OutputNameTmcID int,
            @Amount decimal(38,10), @SectorID int
/*    DECLARE @PT TABLE(ID int)
    
    INSERT INTO @PT(ID)  
    EXEC manufacture.sp_ProductionTasks_GetProdTaskID @ProductionTasksID, @MainJobStageID, @StorageStructureID
    SELECT @ProductionTasksID = ID FROM @PT*/
    
    
    SELECT @SectorID = manufacture.fn_GetSectorID_JobStageID_SSID (@MainJobStageID, @StorageStructureID)
    
    IF @SectorID IS NULL
    BEGIN
        RAISERROR ('Участок не найден для выбранного рабочего места. Выполнение прервано.', 16, 1)
        RETURN
    END        
    
    BEGIN TRAN
    BEGIN TRY
        --объявление курсоров
        DECLARE #cur CURSOR FOR 
        SELECT z.TmcID FROM (
              SELECT a.TmcID 
              FROM manufacture.JobStageChecks a
              WHERE a.JobStageID = @MainJobStageID AND ISNULL(a.isDeleted,0) = 0
              UNION
              SELECT s.OutputTmcID
              FROM manufacture.JobStages s
              WHERE s.ID = @MainJobStageID AND ISNULL(s.isDeleted,0) = 0) z
        WHERE z.TmcID IS NOT NULL
        GROUP BY z.TmcID

       --работаем  
        OPEN #cur
        FETCH NEXT FROM #cur INTO @TMCID
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @TableName = 'pTMC_' + Convert(varchar(30), @TmcID)     
            --SELECT jobs                  
            DECLARE CRSI CURSOR STATIC LOCAL FOR
                SELECT js.ID, jsc.JobStageID, tc.GroupColumnName, NULL AS OutputNameTmcID, 1 AS Type
                FROM manufacture.JobStageChecks jsc
                    INNER JOIN manufacture.PTmcImportTemplateColumns tc ON tc.ID = jsc.ImportTemplateColumnID
                    INNER JOIN manufacture.JobStages js ON jsc.JobStageID = js.ID
                WHERE ISNULL(jsc.isDeleted,0) = 0
                     AND jsc.ImportTemplateColumnID IS NOT NULL
                     AND jsc.TmcID = @TmcID
                     AND jsc.CheckDB = 1
                GROUP BY js.ID, jsc.JobStageID, tc.GroupColumnName 
                UNION 
                SELECT js.ID, jsc.JobStageID, tc.GroupColumnName, jsc.TmcID AS OutputNameTmcID, 0 AS Type
                FROM manufacture.JobStages js
                    INNER JOIN manufacture.JobStageChecks jsc ON jsc.ID = js.OutputNameFromCheckID
                    INNER JOIN manufacture.PTmcImportTemplateColumns tc ON tc.ID = jsc.ImportTemplateColumnID                            
                WHERE js.OutputTmcID = @TmcID 
            OPEN CRSI
            FETCH NEXT FROM CRSI INTO @JobID, @JobStageID, @GroupColumnName, @OutputNameTmcID, @Type
        			
            SET @Query = ''
            SET @QueryNull = ''
            /*Insert only unique values*/
            WHILE @@FETCH_STATUS=0
            BEGIN                
                IF EXISTS(SELECT * FROM information_schema.tables t
                          WHERE t.TABLE_SCHEMA = 'StorageData'
                                AND t.TABLE_NAME = 'G_'  + CAST(@JobStageID as varchar(11)))
                BEGIN              
                    /* Комплектующие*/      
                    IF @Type = 1 BEGIN                          
                        SELECT @Query = @Query +
                        ' SELECT p.StorageStructureID, p.StatusID, p.Batch, tmin.Value as [min], tmax.Value as [max], p.[Count] as [Count], ' + Cast(@TmcID as varchar(11)) + ' as TmcID 
                                 , CASE WHEN p.ParentTMCID is null THEN 0 ELSE 1 END as isPacked,' + CAST(@JobStageID as varchar(11)) +' as JobStageID, ''' + @GroupColumnName + ''' as GroupColumnName, 0
                          FROM 
                              (SELECT StorageStructureID, StatusID, Batch, ParentTMCID, min(p.ID) as minID, max(p.ID) as MaxID, count(p.ID) as [Count]
                              FROM [StorageData].' + @TableName +' p
                                   INNER JOIN (SELECT p.ID FROM StorageData.pTMC_' + Cast(@TmcID as varchar(11)) + ' p
                                               INNER JOIN StorageData.G_' + CAST(@JobStageID as varchar(11)) + ' as g on g.' + @GroupColumnName + ' = p.ID
                                               INNER JOIN shifts.EmployeeGroupsFact ef ON ef.ShiftID = ' + CAST(@ShiftID as varchar(11)) + ' AND ef.JobStageID = ' + CAST(@JobStageID as varchar(11)) + 
                                                  ' AND p.StorageStructureID = ef.WorkPlaceID AND p.EmployeeGroupsFactID = ef.ID
                                               WHERE p.StorageStructureID = ' + CAST(@StorageStructureID AS varchar) + '
                                               GROUP BY p.ID
                                              ) g on g.ID = p.ID         
                              GROUP BY StorageStructureID, StatusID, Batch, ParentTMCID) p
                              LEFT JOIN [StorageData].' + @TableName +' tmin on tmin.ID = p.minID
                              LEFT JOIN [StorageData].' + @TableName +' tmax on tmax.ID = p.maxID
                              WHERE p.StorageStructureID = ' + CAST(@StorageStructureID AS varchar) + '  
                          UNION '               
                        SELECT @QueryNull = @QueryNull + 
                              'SELECT p.ID as ID FROM StorageData.pTMC_' + Cast(@TmcID as varchar(11)) + ' p
                                INNER JOIN StorageData.G_' + CAST(@JobStageID as varchar(11)) + ' as g on g.' + @GroupColumnName + ' = p.ID
                                WHERE p.StorageStructureID = ' + CAST(@StorageStructureID AS varchar) + '
                                UNION '
                    END
                    /* Готовая продукция*/      
                    ELSE BEGIN                                                          
                        SELECT @Query = @Query +
                        ' SELECT p.StorageStructureID, p.StatusID, p.Batch, tmin.Value as [min], tmax.Value as [max], p.[Count] as [Count], ' + Cast(@TmcID as varchar(11)) +' as TmcID 
                                 , CASE WHEN p.ParentTMCID is null THEN 0 ELSE 1 END as isPacked,' + CAST(@JobStageID as varchar(11)) +' as JobStageID, ''' + @GroupColumnName + ''' as GroupColumnName, 1
                          FROM 
                              (SELECT StorageStructureID, StatusID, Batch, ParentTMCID, min(p.ID) as minID, max(p.ID) as MaxID, count(p.ID) as [Count]
                              FROM [StorageData].' + @TableName +' p
                                   INNER JOIN          
                                      (SELECT p.[Value] FROM StorageData.pTMC_' + Cast(@OutputNameTmcID as varchar(11)) + ' p
                                       INNER JOIN StorageData.G_' + CAST(@JobStageID as varchar(11)) + ' as g on g.' + @GroupColumnName + ' = p.ID
                                       INNER JOIN shifts.EmployeeGroupsFact ef ON ef.ShiftID = ' + CAST(@ShiftID as varchar(11)) + ' AND ef.JobStageID = ' + CAST(@JobStageID as varchar(11)) + 
                                           ' AND p.StorageStructureID = ef.WorkPlaceID AND p.EmployeeGroupsFactID = ef.ID
                                       WHERE p.StorageStructureID = ' + CAST(@StorageStructureID AS varchar) + '
                                       ) g on g.[Value] = p.[Value]
                              WHERE p.StorageStructureID = ' + CAST(@StorageStructureID AS varchar) + '
                              GROUP BY StorageStructureID, StatusID, Batch, ParentTMCID) p
                              LEFT JOIN [StorageData].' + @TableName + ' tmin on tmin.ID = p.minID
                              LEFT JOIN [StorageData].' + @TableName + ' tmax on tmax.ID = p.maxID
                          UNION '                       
                        SELECT @QueryNull = @QueryNull + 
                              'SELECT p.ID as ID 
                               FROM [StorageData].' + @TableName +' p
                                    INNER JOIN          
                                      (SELECT p.[Value] FROM StorageData.pTMC_' + Cast(@OutputNameTmcID as varchar(11)) + ' p
                                       INNER JOIN StorageData.G_' + CAST(@JobStageID as varchar(11)) + ' as g on g.' + @GroupColumnName + ' = p.ID
                                       WHERE p.StorageStructureID = ' + CAST(@StorageStructureID AS varchar) + '
                                       ) g on g.[Value] = p.[Value]
                               WHERE p.StorageStructureID = ' + CAST(@StorageStructureID AS varchar) + '
                               UNION '
                    END      
                END      

                        
                FETCH NEXT FROM CRSI INTO @JobID, @JobStageID, @GroupColumnName, @OutputNameTmcID, @Type
            END
            CLOSE CRSI
            DEALLOCATE CRSI         
                    
            IF @Query <> '' BEGIN            
                SET @Query = 'INSERT INTO #TmcGroups (StorageStructureID, [StatusID], [Batch], [Min], [Max], [Count], TmcID, isPacked, JobStageID, GroupColumnName, isMajorTMC)' 
                    + SUBSTRING(@Query, 1, Len(@Query) - 5)                                  
                SET @QueryNull = 
                             ' UNION
                              SELECT p.StorageStructureID, p.StatusID, p.Batch, tmin.Value as [min], tmax.Value as [max], p.[Count] as [Count], ' + CAST(@TmcID as varchar(11)) + ' as TmcID 
                                     , CASE WHEN p.ParentTMCID is null THEN 0 ELSE 1 END as isPacked, Null as JobStageID, Null as GroupColumnName, 0
                              FROM 
                                  (SELECT StorageStructureID, StatusID, Batch, ParentTMCID, min(p.ID) as minID, max(p.ID) as MaxID, count(p.ID) as [Count]
                                  FROM [StorageData].' + @TableName + ' p 
                                       LEFT JOIN (SELECT ID FROM (' + SUBSTRING(@QueryNull, 1, LEN(@QueryNull) - 5) + ') b GROUP BY ID) a on a.ID = p.ID
                                  INNER JOIN shifts.EmployeeGroupsFact ef ON ef.ShiftID = ' + CAST(@ShiftID as varchar(11)) + ' AND ef.JobStageID = ' + CAST(@JobStageID as varchar(11)) + ' AND p.StorageStructureID = ef.WorkPlaceID
                                  WHERE a.ID is null
                                  GROUP BY StorageStructureID, StatusID, Batch, ParentTMCID) p
                              LEFT JOIN [StorageData].' + @TableName +' tmin on tmin.ID = p.minID
                              LEFT JOIN [StorageData].' + @TableName +' tmax on tmax.ID = p.maxID
                              WHERE p.StorageStructureID = ' + CAST(@StorageStructureID AS varchar) + '
                              '
               --SELECT @QueryNull                         
               --SELECT @Query

                --INSERT new Values
               EXEC (@Query + @QueryNull)
               --PRINT @Query 
               --PRINT '-----'
               --PRINT @QueryNull
               -- SELECT @Query + @QueryNull                 
            END
            FETCH NEXT FROM #cur INTO @TMCID            
        END
        CLOSE #cur
        DEALLOCATE #cur   
        
        SELECT @Amount = [Count] FROM #TmcGroups WHERE isPacked = 1 AND isMajorTMC = 1 AND StorageStructureID = @StorageStructureID
/*SET @Query = CAST(@Amount AS varchar)
        RAISERROR (@Query, 16, 1)*/        
        
        INSERT INTO #MDSProduce(TMCID, Amount, Name, isMajorTMC)
        SELECT TMCID, SUM(Amount), Name, isMajorTMC
        FROM (
            SELECT TMCID, [Count] as Amount, t.Name, a.isMajorTMC
            FROM #TmcGroups a
            INNER JOIN Tmc t ON t.ID = a.TMCID
            WHERE (a.StatusID = 3 AND a.isMajorTMC = 0) OR (a.StatusID = 2 AND a.isMajorTMC = 1)

            UNION ALL
            
            SELECT
                ko.TMCID,
                --SUM(Amount),
                @Amount * Ko.Koef,
                t.Name,
                0
            FROM manufacture.JobStageNonPersTMC Ko 
            INNER JOIN Tmc t ON t.ID = ko.TMCID
            LEFT JOIN manufacture.JobStageChecks jc ON jc.TmcID = ko.TMCID AND jc.JobStageID = @JobStageID AND ISNULL(jc.isDeleted, 0) = 0 AND jc.CheckDB = 1
            LEFT JOIN manufacture.JobStages Js ON js.OutputTmcID = ko.TMCID AND js.ID = @JobStageID
            WHERE  Ko.JobStageID = @JobStageID
                 AND jc.id IS NULL
                 AND js.ID IS NULL
            --GROUP BY pta.TMCID, t.Name, pta.isMajorTMC
            --HAVING SUM(Amount) <> 0
/*            
            UNION ALL
            
            SELECT --отнимем 
                dd.TMCID,
                SUM(-Amount) as Amount,
                t.Name,
                dd.isMajorTMC
            FROM manufacture.ProductionTasksDocDetails dd
            INNER JOIN Tmc t ON t.ID = dd.TMCID            
            INNER JOIN manufacture.ProductionTasksDocs d ON d.ID = dd.ProductionTasksDocsID
            WHERE d.ProductionTasksID = @ProductionTasksID
                 AND d.JobStageID = @JobStageID  
                 AND d.ProductionTasksOperTypeID = 2
            GROUP BY dd.TMCID, t.Name, dd.isMajorTMC*/
            
/*            UNION ALL
            
            SELECT
                pta.TMCID,
                pta.Amount,
                t.Name,
                pta.isMajorTMC
            FROM manufacture.vw_ProductionTasksAgregation_Select pta
            INNER JOIN manufacture.JobStageNonPersTMC Ko ON Ko.JobStageID = @JobStageID AND Ko.TMCID = pta.TMCID
            INNER JOIN Tmc t ON t.ID = pta.TMCID
            LEFT JOIN manufacture.JobStageChecks jc ON jc.TmcID = pta.TMCID AND jc.JobStageID = @JobStageID AND ISNULL(jc.isDeleted, 0) = 0 AND jc.CheckDB = 1
            LEFT JOIN manufacture.JobStages Js ON js.OutputTmcID = pta.TMCID AND js.ID = @JobStageID
            WHERE pta.ProductionTasksID = @ProductionTasksID
                 AND (pta.ProductionTasksStatusID = 2)
                 AND pta.Amount <> 0
                 AND jc.id IS NULL
                 AND js.ID IS NULL*/
        ) res
        GROUP BY res.TMCID, res.Name, res.isMajorTMC
        
        DROP TABLE #TmcGroups
        
        COMMIT TRAN      
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err        
        SELECT null  
    END CATCH
END
GO