SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   ??.??.2013$*/
/*$Modify:     Poliatykin Oleksii$    $Modify date:  03.10.2018$*/
/*$Version:    10.00$   $Description: Импорт данных$*/
CREATE PROCEDURE [manufacture].[sp_TMCBulkInsert]
  @Separator varchar(1),
  @Quote varchar(1),
  @SkipRow int,
  @ColumnCount tinyint,  
  @Data varbinary(max),
  @JobStageID int,
  @EmployeeID int,
  @OperationID int,
  @PalleteColumnName varchar(256)
AS
BEGIN	
 	SET NOCOUNT ON
    SET XACT_ABORT ON

    DECLARE @fFileName varchar(36), @fDirPath varchar(512), @fFilePath varchar(512), @fFilePathFF varchar(512), @Command varchar(512),
		    @HR int, @Stream int, @Buffer varbinary(4096), @Size int, @Pos int, @BufSize int, @ColumnName varchar(256), 
            @BatchColumnName varchar(256), @GroupColumnName varchar(256), @pTmcID int, @SpTmcID varchar(11), @i tinyint,
            @SSkipRow varchar(2), @Query varchar(4000), @QueryS varchar(4000), @QueryI varchar(4000), @TableName varchar(50),
            @TableNameHistory varchar(50), @GTableName varchar(50), @Err Int, @Time datetime, @TimeDetail varchar(MAX),            
            @Count int, @isInserted bit, @TypeID tinyint,  @PalletsTableName varchar(50), @PalletsDetailsTableName varchar(50),
            @BoxTMC varchar(30), @BoxColumnName varchar(256), @Employee varchar(30)

    DECLARE @T TABLE(ID int)
           
    SET @PalletsTableName = 'Pallets_' + Convert(varchar(30), @JobStageID)
    SET @PalletsDetailsTableName = 'PalletsDetails_' + Convert(varchar(30), @JobStageID)
    SET @Employee = Convert(varchar(30), @EmployeeID)
    BEGIN TRAN
    BEGIN TRY  
        
    	SET @Time = Getdate()
        
        /*---------------------------------------------------------------------*/
        /*-STAGE 1. Copy data from local disk to Temporatly table on SQLServer.*/
        /*---------------------------------------------------------------------*/
        
        CREATE TABLE #TMCImport (Blob varbinary(MAX))
        INSERT INTO #TMCImport (Blob) VALUES (@Data)

        /*Save file to disk on server*/
        EXEC @HR = sp_OACreate 'ADODB.Stream',@Stream OUT 
        EXEC @HR = sp_OASetProperty @Stream,'Type',1 /* binary*/
        EXEC @HR = sp_OASetProperty @Stream,'Mode',3 /* write|read*/
        EXEC @HR = sp_OAMethod @Stream,'Open' 
                           
        SET @BufSize = 4096    
        SET @Pos=0
        SET @Size = (SELECT DATALENGTH(Blob) FROM #TMCImport)

        WHILE @Pos < @Size BEGIN
         SET @BufSize = CASE WHEN @Size - @Pos < 4096 THEN @Size - @Pos ELSE 4096 END

         SELECT @Buffer = substring(Blob,@Pos+1, @BufSize)    
         FROM #TMCImport
                         
         EXEC @HR = sp_OAMethod @Stream, 'Write',  NULL, @Buffer  
                      
         SET @Pos = @Pos + @BufSize
        END
    	
        /*Generate uniqueidentfire, it's give us possibility to work from different mashine without rewrite the file*/
        SELECT @fFileName = CONVERT(nvarchar(36), newID())
        SELECT @fDirPath = dbo.fn_GetSystemSetStringValue(3)
        SET @fFilePath = @fDirPath + @fFileName + '.xxx'
        SET @fFilePathFF = @fDirPath + @fFileName + '.fmt'    

        EXEC @HR = sp_OAMethod @Stream, 'SaveToFile', null, @fFilePath, 2 
        EXEC @HR = sp_OAMethod @Stream, 'Close'
        EXEC @HR = sp_OADestroy @Stream 

        /*BULK INSERT*/
        /*IT CAN BE PROBLEM WITH DIFFERENT CODEPAGES OF FILE */
        
        /*Create Format File for bulk insert*/
        /*without FF we couldn't use ID IDENTITY(1,1) in #TMCImportFile*/
        EXEC manufacture.sp_CreateNonXMLFormatFile @ColumnCount, @Separator, @fFilePathFF
        
        SET @SSkipRow = Convert(varchar(3),@SkipRow +1)
        EXEC ('
        BULK INSERT #TMCImportFile 
        FROM ''' + @fFilePath + ''' 
        WITH (FIRSTROW = '+ @SSkipRow +',  FORMATFILE = ''' + @fFilePathFF + ''')
        ')
        
        SET @TimeDetail = 'Stage 1 END: ' + Convert(varchar(20), DATEDIFF(ms, @Time, GetDate())) + ';'
        /*---------------------------------------------------------------------*/
        /*-STAGE 2. Insert data from temporatly table to different pTMC tables.*/
        /*---------------------------------------------------------------------*/
        
        SELECT top 1 @BatchColumnName = ic.ColumnName
        FROM manufacture.PTmcImportColumns ic             
        WHERE ic.OperationID = @OperationID
              AND ic.ImportTemplateColumnID is null          
        
        DECLARE CRSI CURSOR STATIC LOCAL FOR
        SELECT ic.ColumnName, itc.TmcID, CASE WHEN ic.OperationID is null THEN 0 ELSE 1 END as isInserted, jsc.TypeID
        FROM manufacture.PTmcImportTemplateColumns itc
             LEFT JOIN manufacture.PTmcImportColumns ic on itc.ID = ic.ImportTemplateColumnID         
             LEFT JOIN manufacture.PTmcImportTemplates it on it.ID = itc.TemplateImportID
             LEFT JOIN manufacture.JobStageChecks jsc on jsc.ImportTemplateColumnID = itc.ID
        WHERE it.JobStageID = @JobStageID
              AND ic.OperationID = @OperationID
        ORDER BY ic.ID
         
        OPEN CRSI
        
        SET @TimeDetail = @TimeDetail + 'Open CRSI ' + '; BatchColumn: ' + IsNull(@BatchColumnName,'') + ';'

        FETCH NEXT FROM CRSI INTO @ColumnName, @pTmcID, @isInserted, @TypeID

        /*Insert only unique values*/
        WHILE @@FETCH_STATUS=0
        BEGIN
            /*Insert values*/
            IF @isInserted = 1 
            BEGIN
                SET @TableName = (SELECT manufacture.fn_GetPTmcTableName(@pTmcID))
                SET @SpTmcID = CONVERT(varchar(13), @pTmcID)
                SET @TimeDetail = @TimeDetail +' SQL:                
                    INSERT INTO '+ @TableName + '([Value], [TmcID], [StatusID], [OperationID], [Batch])
                    SELECT tiff.' + @ColumnName + ' , ' + @SpTmcID + ' , 1, ' + CAST(@OperationID as varchar(13)) + ', tiff.batch
                    FROM
                        (SELECT tif.' + @ColumnName + ', min(tif.ID) as mini, ' + CASE WHEN @TypeID = 2 THEN IsNull('min(tif.' + @BatchColumnName+')', 'null ') ELSE ' null ' END + ' as batch 
                           FROM #TMCImportFile tif
                             LEFT JOIN '+ @TableName + ' pt on pt.Value = tif.' + @ColumnName + '                 
                        WHERE pt.ID is NULL
                        GROUP BY tif.' + @ColumnName + ') as tiff
                    ORDER BY tiff.mini'
                                    
                SELECT @Query ='                
                    INSERT INTO '+ @TableName + '([Value], [TmcID], [StatusID], [OperationID], [Batch])
                    SELECT tiff.' + @ColumnName + ' , ' + @SpTmcID + ' , 1, ' + CAST(@OperationID as varchar(13)) + ', tiff.batch
                    FROM
                        (SELECT tif.' + @ColumnName + ', min(tif.ID) as mini, ' + CASE WHEN @TypeID = 2 THEN IsNull('min(tif.' + @BatchColumnName+')', 'null ') ELSE ' null ' END + ' as batch 
                        FROM #TMCImportFile tif
                             LEFT JOIN '+ @TableName + ' pt on pt.Value = tif.' + @ColumnName + '                 
                        WHERE pt.ID is NULL
                        GROUP BY tif.' + @ColumnName + ') as tiff
                    ORDER BY tiff.mini'
				

                EXEC (@Query)
                SET @TimeDetail = @TimeDetail + 'Stage 2 '+@SpTmcID+': ' + Convert(varchar(20), DATEDIFF(ms, @Time, GetDate())) + ';'       
                /*Insert history    */
                SET @TableNameHistory = (SELECT manufacture.fn_GetPTmcTableNameHistory(@pTmcID))
                EXEC ('
                    INSERT INTO '+ @TableNameHistory + '([pTmcID], [StatusID], [OperationID], [ModifyDate], [ModifyEmployeeID], [OperationType])
                    SELECT [ID], [StatusID], [OperationID], Getdate(), ' + @EmployeeID + ', 1
                    FROM '+ @TableName + ' pt
                    WHERE pt.OperationID = ' + @OperationID + '
                    ORDER BY pt.ID 
                    ')                
                SET @TimeDetail = @TimeDetail + 'Stage 2 '+@SpTmcID+'H: ' + Convert(varchar(20), DATEDIFF(ms, @Time, GetDate())) + ';'       
                        
            END    
            SET @TimeDetail = @TimeDetail + 'Stage 2 '+@SpTmcID+' Recalculate: ' + Convert(varchar(20), DATEDIFF(ms, @Time, GetDate())) + ';'     
            FETCH NEXT FROM CRSI INTO @ColumnName, @pTmcID, @isInserted, @TypeID
        END        
        
        CLOSE CRSI    
        DEALLOCATE CRSI              
        
        SET @TimeDetail = @TimeDetail + 'Stage 2 END: ' + Convert(varchar(20), DATEDIFF(ms, @Time, GetDate())) + ';'        
        /*-------------------------------------*/
        /*-STAGE 3. Insert data to group table.*/
        /*-------------------------------------*/
        /*Create relations between pTMCs*/            

        IF EXISTS(SELECT itc.ID
                  FROM manufacture.PTmcImportColumns ic
                       LEFT JOIN manufacture.PTmcImportTemplateColumns itc on itc.ID = ic.ImportTemplateColumnID
                       LEFT JOIN manufacture.JobStageChecks jsc on jsc.ImportTemplateColumnID = itc.ID
                  WHERE OperationID = @OperationID
                        AND ic.ImportTemplateColumnID is not null
                        AND jsc.[CheckDB] = 1
                        AND jsc.CheckLink = 1)
        BEGIN           
            DECLARE CRSV CURSOR STATIC LOCAL FOR
            SELECT itc.GroupColumnName, ic.ColumnName, itc.TmcID
            FROM manufacture.PTmcImportColumns ic
                 LEFT JOIN manufacture.PTmcImportTemplateColumns itc on itc.ID = ic.ImportTemplateColumnID
                 LEFT JOIN manufacture.JobStageChecks jsc on jsc.ImportTemplateColumnID = itc.ID
            WHERE OperationID = @OperationID
                  AND ic.ImportTemplateColumnID is not null
                  AND jsc.[CheckDB] = 1
                  AND jsc.CheckLink = 1
            ORDER BY ic.ID
             
            OPEN CRSV

            FETCH NEXT FROM CRSV INTO @GroupColumnName, @ColumnName, @pTmcID

            SET @GTableName = (SELECT manufacture.fn_GetGroupTableName(@JobStageID))
            SET @QueryI = 'INSERT INTO '+@GTableName+'( OperationID, '
            SET @QueryS = 'SELECT ' + CONVERT(varchar(13),@OperationID) +' as ExportID'
            SET @Query =  ' FROM #TMCImportFile tif '
                     
            WHILE @@FETCH_STATUS=0
            BEGIN
                SET @TableName = (SELECT manufacture.fn_GetPTmcTableName(@pTmcID))
                SET @QueryI = @QueryI + 'tif.' + @GroupColumnName + ','
                SET @QueryS = @QueryS + ', [' + @GroupColumnName + '].ID '
                SET @Query = @Query + '
                     LEFT JOIN ' + @TableName + ' as [' + @GroupColumnName + '] ON [' + @GroupColumnName + '].Value = tif.'+@ColumnName             

                FETCH NEXT FROM CRSV INTO @GroupColumnName, @ColumnName, @pTmcID
            END
            
            CLOSE CRSV    
            DEALLOCATE CRSV                    
            
            SET @QueryI = Substring(@QueryI,1, LEN(@QueryI)-1)
            SET @QueryI = @QueryI + ')'
            
            SET @Query = @Query + ' ORDER BY tif.ID'
            
            SET @Query = @QueryI + @QueryS + @Query
            
            SET @TimeDetail = @TimeDetail + '!!!' + @Query + '!!!'
            /*INSERT VALUES*/            
            EXEC(@Query) 		
        END
        
        SET @TimeDetail = @TimeDetail + 'Stage 3 END: ' + Convert(varchar(20), DATEDIFF(ms, @Time, GetDate())) + ';'
        
		/*Recalculate pTMCs*/
        DECLARE CRSI CURSOR STATIC LOCAL FOR
        SELECT itc.TmcID
        FROM manufacture.PTmcImportTemplateColumns itc
             LEFT JOIN manufacture.PTmcImportColumns ic on itc.ID = ic.ImportTemplateColumnID         
             LEFT JOIN manufacture.PTmcImportTemplates it on it.ID = itc.TemplateImportID
        WHERE /*ImportID = @ImportID*/
              it.JobStageID = @JobStageID
              AND ic.OperationID = @OperationID
        GROUP BY itc.TmcID
         
        OPEN CRSI

        FETCH NEXT FROM CRSI INTO @pTmcID

        WHILE @@FETCH_STATUS=0
        BEGIN
            EXEC manufacture.sp_PTmcGroups_Calculate  @pTmcID         
            
            FETCH NEXT FROM CRSI INTO @pTmcID        
        END        
        CLOSE CRSI    
        DEALLOCATE CRSI        
        
        /*-------------------------------------*/
        /*-STAGE Palets. Insert data of pallets*/
        /*-------------------------------------*/
       if  @PalleteColumnName <>'' 
       BEGIN       
           EXEC manufacture.sp_Pallets_CreateTables @JobStageID
        
           SELECT
               @BoxTMC =   Convert(varchar(30), jsc.TmcID)
               ,@BoxColumnName = ic.ColumnName
           FROM manufacture.JobStageChecks jsc
               INNER JOIN manufacture.PTmcOperations o on o.JobStageID = jsc.JobStageID and o.OperationTypeID = 1  and o.isCanceled = 0 
               INNER JOIN manufacture.PTmcImportColumns ic on ic.OperationID = o.id and jsc.ImportTemplateColumnID = ic.ImportTemplateColumnID
           WHERE jsc.JobStageID = @JobStageID and  jsc.SortOrder = 1
                
           EXEC('
                insert into StorageData.'+@PalletsTableName+' (VALUE) 
                (select i.'+@PalleteColumnName+' from #TMCImportFile i group by i.'+@PalleteColumnName+')            
                insert into StorageData.'+@PalletsDetailsTableName+' (PalletID, BoxID, Status, ModifyEmployeeID, ModifyDate)
                (
                SELECT 
                    p.id as PalletID, box.id As BoxID, 0, '+  @Employee +', GetDate()
                from #TMCImportFile i 
                    left join StorageData.pTMC_'+@BoxTMC+'   box on box.Value = i.'+@BoxColumnName+'
                    left JOIN StorageData.'+@PalletsTableName+' p on p.Value = i.'+@PalleteColumnName+'
                group by box.id, p.id
                )             
                ')
        END
    
        /*-------------------------------------*/
        /*-STAGE 4. Delete all temporatly data.*/
        /*-------------------------------------*/
        
        SELECT @Count = Count(*)
        FROM #TMCImportFile 
        
        /*Delete temp table*/
        IF OBJECT_ID('tempdb..#TMCImportFile') IS NOT NULL
        DROP TABLE #TMCImportFile
        
        /*Delete files from disk  */
        SET @Command = 'if exist ' + @fFilePath + ' del ' + @fFilePath
        EXEC master..xp_cmdshell @Command, no_output
        SET @Command = 'if exist ' + @fFilePathFF + ' del ' + @fFilePathFF
        EXEC master..xp_cmdshell @Command, no_output    
        
        UPDATE manufacture.PTmcOperations
        SET [Time] = DATEDIFF(ms, @Time, GetDate())
            , [Count] = @Count
        WHERE ID = @OperationID

        COMMIT TRAN        
        SET @TimeDetail = @TimeDetail + 'Stage 4 END: ' + Convert(varchar(20), DATEDIFF(ms, @Time, GetDate())) + ';'                        
        
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH        

    INSERT INTO manufacture.Test([Value]) 
    VALUES (@TimeDetail)    
    
    SELECT null
END
GO