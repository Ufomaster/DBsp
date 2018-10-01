SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   21.01.2015$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   25.01.2018$*/
/*$Version:    3.00$   $Description: Отмена операции импорта $*/
CREATE PROCEDURE [manufacture].[sp_PTmcOperation_CancelLast]
	@JobStageID int
AS    
BEGIN
	SET NOCOUNT ON
    DECLARE 
          @Err int
        , @query varchar(max)
        , @querySelect varchar(max)
        , @queryDel varchar(max)
        , @CR varchar(5)
        , @GroupColumnName varchar(max)
        , @TmcID int
        , @TypeID int 
        , @SortOrder int
        , @into varchar(max)
        , @OutputTmcID int
    DECLARE Cur_col CURSOR STATIC LOCAL FOR
    SELECT
        pitc.GroupColumnName
       ,pitc.TmcID
       ,jsc.TypeID
       ,jsc.SortOrder
    FROM manufacture.PTmcImportTemplates pit
    JOIN manufacture.PTmcImportTemplateColumns pitc
        ON pit.ID = pitc.TemplateImportID
    JOIN manufacture.JobStageChecks jsc
        ON jsc.JobStageID = pit.JobStageID
            AND jsc.TmcID = pitc.TmcID
    WHERE pit.JobStageID = @JobStageID 
    AND  ISNULL(pit.isDeleted,0) = 0
    
    SELECT @OutputTmcID = js.OutputTmcID FROM manufacture.JobStages js WHERE id = @JobStageID
    UPDATE Tmc SET LastAccessDate = GetDate() WHERE ID = @OutputTmcID 

    SET @CR = CHAR(13) + CHAR(10)     
        OPEN Cur_col
        FETCH NEXT FROM Cur_col INTO @GroupColumnName, @TmcID, @TypeID, @SortOrder
        WHILE @@FETCH_STATUS=0               
        BEGIN
            UPDATE Tmc SET LastAccessDate = GetDate() WHERE ID = @TmcID
            if @SortOrder = 1 set @into = ' INTO #sborkag '   else set @into = ''
            set @querySelect = isnull(@querySelect + ' UNION ','') +
                              ' SELECT DISTINCT t.* '+@into+
                              ' FROM StorageData.pTMC_'+ cast(@TmcID as varchar(max))+' t ' +
                              ' JOIN StorageData.G_'+ cast(@JobStageID as varchar(max))+' g ON g.'+@GroupColumnName+' = t.ID'

            set @queryDel = isnull(@queryDel,'' ) +
                           ' DELETE FROM StorageData.pTMC_'+ cast(@TmcID as varchar(max))+'H ' + @CR +
                           ' WHERE pTMCid IN (SELECT ' + @CR +
                           '               id ' + @CR +
                           '              FROM #sborkag s ' + @CR +
                           '              WHERE s.TMCID = '+ cast(@TmcID as varchar(max))+') ' + @CR +
                           ' DELETE FROM StorageData.pTMC_'+ cast(@TmcID as varchar(max))+' ' + @CR +
                           ' WHERE id IN (SELECT ' + @CR +
                           '               id ' + @CR +
                           '              FROM #sborkag s ' + @CR +
                           '              WHERE s.TMCID = '+ cast(@TmcID as varchar(max))+') ' + @CR +
                           ' EXEC manufacture.sp_PTmcGroups_Calculate '+ cast(@TmcID as varchar(max))+' ' + @CR 

                                                  

        FETCH NEXT FROM Cur_col INTO @GroupColumnName, @TmcID, @TypeID, @SortOrder
        END
        CLOSE Cur_col
        DEALLOCATE Cur_col  
        SET @querySelect = ' DECLARE @Count int ' + @CR +
                           ' DECLARE @Err Int' + @CR +
                           ' SET XACT_ABORT ON' + @CR +
                           ' BEGIN TRAN' + @CR +
                           ' BEGIN TRY' + @CR +
                           ' IF object_id(''tempdb..#columng'') IS NOT NULL DROP TABLE #columng ' + @CR +
                           ' SELECT ' + @CR +
                           '    pitc.GroupColumnName ' + @CR +
                           '   ,pitc.TmcID ' + @CR +
                           '   ,jsc.TypeID ' + @CR +
                           '  ,jsc.SortOrder INTO #columng ' + @CR +
                           ' FROM manufacture.PTmcImportTemplates pit ' + @CR +
                           ' JOIN manufacture.PTmcImportTemplateColumns pitc ' + @CR +
                           '    ON pit.ID = pitc.TemplateImportID ' + @CR +
                           ' JOIN manufacture.JobStageChecks jsc ' + @CR +
                           '    ON jsc.JobStageID = pit.JobStageID ' + @CR +
                           '        AND jsc.TmcID = pitc.TmcID ' + @CR +
                           ' WHERE pit.JobStageID = '+ cast(@JobStageID as varchar(max))+' ' + @CR +
                           ' AND  ISNULL(pit.isDeleted,0) = 0 ' + @CR +
                           ' IF object_id(''tempdb..#sborkag'') IS NOT NULL DROP TABLE #sborkag ' + @CR +
                            +  @querySelect  + @CR +
                           '  DECLARE @inbox INT ' + @CR +
                           '        ,@inboxColumn VARCHAR(20) ' + @CR +
                           ' SELECT TOP 1 ' + @CR +
                           '     @inbox = c.TmcID ' + @CR +
                           '        ,@inboxColumn = c.GroupColumnName ' + @CR +
                           '     FROM #columng c ' + @CR +
                           '     WHERE c.TypeID = 1 ' + @CR +
                           '     ORDER BY c.SortOrder DESC ' + @CR +
                           ' DECLARE @gYes1 INT ' + @CR +
                           '           ,@gYes2 INT ' + @CR +
                           '    SELECT ' + @CR +
                           '        @gYes1 = COUNT(*) ' + @CR +
                           '    FROM StorageData.pTMC_'+ cast(@OutputTmcID as varchar(max))+' t ' + @CR +
                           '    WHERE t.ParentTMCID = @inbox ' + @CR +
                           '    SELECT ' + @CR +
                           '        @gYes2 = COUNT(g.ID) ' + @CR +
                           '    FROM StorageData.pTMC_'+ cast(@OutputTmcID as varchar(max))+' t ' + @CR +
                           '    JOIN StorageData.G_'+ cast(@JobStageID as varchar(max))+' g ' + @CR +
                           '        ON g.Column_2 = t.ParentPTMCID ' + @CR +
                           '            AND g.OperationID IS NULL ' + @CR +
                           '            AND t.ParentTMCID = @inbox ' + @CR +
                           '    IF (@gYes1 = @gYes2) ' + @CR +
                           '        AND (@gYes1 = 0) ' + @CR +
                           '    BEGIN ' + @CR


        SET @queryDel =  @queryDel +
                        ' DELETE FROM StorageData.G_'+ cast(@JobStageID as varchar(max))+' ' + @CR +
                        ' DELETE FROM manufacture.PTmcGroups WHERE Jobstageid = '+ cast(@JobStageID as varchar(max))+' ' + @CR +
                        ' UPDATE manufacture.PTmcOperations SET isCanceled = 1 WHERE Jobstageid = '+ cast(@JobStageID as varchar(max))+ @CR +
                        ' END ' + @CR +
                        ' ELSE RAISERROR (''Некоторые материалами были упакованы - удаление невозможно.'', 16, 1) '+ @CR +
                        ' COMMIT' + @CR +
                        ' END TRY' + @CR +
                        ' BEGIN CATCH' + @CR +
                        '    SET @Err = @@ERROR;' + @CR +
                        '    IF @@TRANCOUNT > 0 ROLLBACK TRAN' + @CR +
                        '    EXEC sp_RaiseError @ID = @Err;' + @CR +
                        ' END CATCH' + @CR

        SET @query = @querySelect + @queryDel

        EXEC(@query)
--        SELECT @query
               
END
GO