SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   12.12.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   30.10.2017$*/
/*$Version:    1.00$   $Description: Вставка данных в группировочную таблицу$*/
CREATE PROCEDURE [manufacture].[sp_PTmcGroups_Calculate] 
  @TmcID int
AS
BEGIN
	SET NOCOUNT ON;
	/*Check table for exist*/
    DECLARE @TableName varchar(50), @JobID int, @JobStageID int, @GroupColumnName varchar(18),
            @Err int, @Query varchar(MAX), @QueryNull varchar(MAX), @Type bit, @OutputNameTmcID int

    SET @TableName = 'pTMC_' + Convert(varchar(30), @TmcID)
    IF EXISTS(
          SELECT * FROM information_schema.tables t
          WHERE t.TABLE_SCHEMA = 'StorageData'
                AND t.TABLE_NAME = @TableName)
    BEGIN
        BEGIN TRAN
        BEGIN TRY      
            --DELETE old values
            DELETE FROM manufacture.PTmcGroups
            WHERE TmcID = @TmcID

            --SELECT jobs            
           DECLARE CRSI CURSOR STATIC LOCAL FOR
           SELECT js.ID, jsc.JobStageID, tc.GroupColumnName, null as OutputNameTmcID, 1 as Type
           FROM manufacture.JobStageChecks jsc
                INNER JOIN manufacture.PTmcImportTemplateColumns tc on tc.ID = jsc.ImportTemplateColumnID
                INNER JOIN manufacture.JobStages js on jsc.JobStageID = js.ID
           WHERE ISNULL(jsc.isDeleted,0) = 0
                 AND jsc.ImportTemplateColumnID is not null
                 AND jsc.TmcID = @TmcID
           GROUP BY js.ID, jsc.JobStageID, tc.GroupColumnName 
           UNION 
           SELECT js.ID, jsc.JobStageID, tc.GroupColumnName, jsc.TmcID as OutputNameTmcID, 0 as Type
           FROM manufacture.JobStages js
                INNER JOIN manufacture.JobStageChecks jsc on jsc.ID = js.OutputNameFromCheckID AND ISNULL(jsc.isDeleted,0) = 0
                INNER JOIN manufacture.PTmcImportTemplateColumns tc on tc.ID = jsc.ImportTemplateColumnID                            
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
                        ' SELECT p.StorageStructureID, p.StatusID, p.Batch, tmin.Value as [min], tmax.Value as [max], p.[Count] as [Count], ' + Cast(@TmcID as varchar(11)) +' as TmcID 
                                 , CASE WHEN p.ParentTMCID is null THEN 0 ELSE 1 END as isPacked,' + CAST(@JobStageID as varchar(11)) +' as JobStageID, ''' + @GroupColumnName + ''' as GroupColumnName
                          FROM 
                              (SELECT StorageStructureID, StatusID, Batch, ParentTMCID, min(p.ID) as minID, max(p.ID) as MaxID, count(p.ID) as [Count]
                              FROM [StorageData].' + @TableName +' p
                                   INNER JOIN (SELECT p.ID FROM StorageData.pTMC_' + Cast(@TmcID as varchar(11)) + ' p
                                               LEFT JOIN StorageData.G_' + CAST(@JobStageID as varchar(11)) + ' as g on g.' + @GroupColumnName + ' = p.ID
                                               LEFT JOIN manufacture.PTmcOperations o ON p.OperationID = o.id AND o.JobStageID = ' + CAST(@JobStageID as varchar(11)) +' 
                                               WHERE g.ID IS NOT NULL OR o.ID IS NOT NULL
                                               GROUP BY p.ID
                                              ) g on g.ID = p.ID         
                              GROUP BY StorageStructureID, StatusID, Batch, ParentTMCID) p
                              LEFT JOIN [StorageData].' + @TableName +' tmin on tmin.ID = p.minID
                              LEFT JOIN [StorageData].' + @TableName +' tmax on tmax.ID = p.maxID
                          UNION '               
/*                        SELECT @QueryNull = @QueryNull + 
                              'SELECT p.ID as ID FROM StorageData.pTMC_' + Cast(@TmcID as varchar(11)) + ' p
                                INNER JOIN StorageData.G_' + CAST(@JobStageID as varchar(11)) + ' as g on g.' + @GroupColumnName + ' = p.ID
                                UNION '*/
                    END            
                    /* Готовая продукция*/      
                    ELSE BEGIN                                                          
                        SELECT @Query = @Query +
                        ' SELECT p.StorageStructureID, p.StatusID, p.Batch, tmin.Value as [min], tmax.Value as [max], p.[Count] as [Count], ' + Cast(@TmcID as varchar(11)) +' as TmcID 
                                 , CASE WHEN p.ParentTMCID is null THEN 0 ELSE 1 END as isPacked,' + CAST(@JobStageID as varchar(11)) +' as JobStageID, ''' + @GroupColumnName + ''' as GroupColumnName
                          FROM 
                              (SELECT StorageStructureID, StatusID, Batch, ParentTMCID, min(p.ID) as minID, max(p.ID) as MaxID, count(p.ID) as [Count]
                              FROM [StorageData].' + @TableName +' p
                                   INNER JOIN          
                                      (SELECT p.[Value] FROM StorageData.pTMC_' + Cast(@OutputNameTmcID as varchar(11)) + ' p
                                       INNER JOIN StorageData.G_' + CAST(@JobStageID as varchar(11)) + ' as g on g.' + @GroupColumnName + ' = p.ID
                                       ) g on g.[Value] = p.[Value]         
                              GROUP BY StorageStructureID, StatusID, Batch, ParentTMCID) p
                              LEFT JOIN [StorageData].' + @TableName +' tmin on tmin.ID = p.minID
                              LEFT JOIN [StorageData].' + @TableName +' tmax on tmax.ID = p.maxID
                          UNION '                       
/*                        SELECT @QueryNull = @QueryNull + 
                              'SELECT p.ID as ID 
                               FROM [StorageData].' + @TableName +' p
                                    INNER JOIN          
                                      (SELECT p.[Value] FROM StorageData.pTMC_' + Cast(@OutputNameTmcID as varchar(11)) + ' p
                                       INNER JOIN StorageData.G_' + CAST(@JobStageID as varchar(11)) + ' as g on g.' + @GroupColumnName + ' = p.ID
                                       ) g on g.[Value] = p.[Value]
                               UNION '*/
                    END      
                END      

                
                FETCH NEXT FROM CRSI INTO @JobID, @JobStageID, @GroupColumnName, @OutputNameTmcID, @Type
            END         
            
            IF @Query <> '' BEGIN            
                SET @Query = 'INSERT INTO manufacture.PTmcGroups (StorageStructureID, [StatusID], [Batch], [Min], [Max], [Count], TmcID, isPacked, JobStageID, GroupColumnName)' + SubString(@Query, 1, Len(@Query) - 5)           
                                  
/*                SET @QueryNull = 
                             ' UNION
                              SELECT p.StorageStructureID, p.StatusID, p.Batch, tmin.Value as [min], tmax.Value as [max], p.[Count] as [Count], ' + Cast(@TmcID as varchar(11)) +' as TmcID 
                                     , CASE WHEN p.ParentTMCID is null THEN 0 ELSE 1 END as isPacked, Null as JobStageID, Null as GroupColumnName
                              FROM 
                                  (SELECT StorageStructureID, StatusID, Batch, ParentTMCID, min(p.ID) as minID, max(p.ID) as MaxID, count(p.ID) as [Count]
                                  FROM [StorageData].' + @TableName +' p 
                                       LEFT JOIN (SELECT ID FROM ('+SubString(@QueryNull, 1, Len(@QueryNull) - 5) +') b GROUP BY ID) a on a.ID = p.ID
                                  WHERE a.ID is null
                                  GROUP BY StorageStructureID, StatusID, Batch, ParentTMCID) p
                              LEFT JOIN [StorageData].' + @TableName +' tmin on tmin.ID = p.minID
                              LEFT JOIN [StorageData].' + @TableName +' tmax on tmax.ID = p.maxID
                              '*/
               --SELECT @QueryNull                         
               --SELECT @Query
            
                --INSERT new Values
                EXEC (@Query + @QueryNull)
            END    
                
            COMMIT TRAN      
        END TRY
        BEGIN CATCH
            SET @Err = @@ERROR
            IF @@TRANCOUNT > 0 ROLLBACK TRAN
            EXEC sp_RaiseError @ID = @Err        
           -- SELECT null  
        END CATCH                         
    END
END
GO