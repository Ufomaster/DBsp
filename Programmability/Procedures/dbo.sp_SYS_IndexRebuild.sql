SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   13.03.2017$*/
/*$Modify:     Yuriy Oleynik$	$Modify date:   24.07.2017$*/
/*$Version:    1.00$   $Decription: Перестроение индексов по БД Спеклер$*/
CREATE PROCEDURE [dbo].[sp_SYS_IndexRebuild]
    @IncludedTables varchar(max)
AS 
BEGIN
  EXEC dbo.sp_SYS_rebuild_indexes_by_db
  @DBName = 'Spekler'
, @IncludedTables  = @IncludedTables -- Comma delimited list of tables (DB.schema.Table) to include in processing - '' - AllTables
, @ReorgLimit = 15     -- Minimum fragmentation % to use Reorg method
, @RebuildLimit = 30   -- Minimum fragmentation % to use Rebuild method
, @PageLimit = 10      -- Minimum # of Pages before you worry about it
, @SortInTempdb = 0    -- 1 = Sort in tempdb option
, @OnLine = 0          -- 1 = Online Rebuild, Reorg is ignored
, @ByPartition = 1     -- 1 = Treat each partition separately
, @LOBCompaction = 1   -- 1 = Always do LOB compaction
, @DoCIOnly = 0        -- 1 = Only do Clustered indexes
, @UpdateStats = 1     -- 1 = Update the statistics after the Reorg process
, @MaxDOP = 0

  RETURN
  
/*  
  
  
  
  --OBSOLETE
    -- Ensure a USE <databasename> statement has been executed first.  
    SET NOCOUNT ON  
    DECLARE @objectid int, @indexid int, @partitioncount bigint, @schemaname nvarchar(130), @objectname nvarchar(130),
       	    @indexname nvarchar(130), @partitionnum bigint, @partitions bigint, @frag float, @command nvarchar(4000)

    IF object_id('tempdb..#work_to_do') is not null DROP TABLE #work_to_do
    -- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function   
    -- and convert object and index IDs to names.  
    SELECT  
        a.object_id AS objectid,  
        a.index_id AS indexid,  
        a.partition_number AS partitionnum,  
        a.avg_fragmentation_in_percent AS frag--,
--        t.[name] as TableName,
--        s.[name] as SchemeName
    --INTO #work_to_do  
    FROM sys.dm_db_index_physical_stats (DB_ID(N'Spekler'), NULL, NULL , NULL, 'LIMITED') a
         LEFT JOIN sys.Tables t on t.object_id = a.object_id
         LEFT JOIN sys.schemas s on t.schema_id = s.schema_id
    WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0
          AND s.[name] <> 'StorageData';  
      
    -- Declare the cursor for the list of partitions to be processed.  
    DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;  
      
    -- Open the cursor.  
    OPEN partitions;  
      
    -- Loop through the partitions.  
    WHILE (1=1)  
        BEGIN;  
            FETCH NEXT FROM partitions INTO @objectid, @indexid, @partitionnum, @frag;  
            IF @@FETCH_STATUS < 0 BREAK;  
            SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)  
            FROM sys.objects AS o  
            JOIN sys.schemas as s ON s.schema_id = o.schema_id  
            WHERE o.object_id = @objectid;  
            
            SELECT @indexname = QUOTENAME(name)  
            FROM sys.indexes  
            WHERE  object_id = @objectid AND index_id = @indexid;  
            
            SELECT @partitioncount = count (*)  
            FROM sys.partitions  
            WHERE object_id = @objectid AND index_id = @indexid;  
      
    -- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.  
            IF @frag < 30.0  
                SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE';  
            IF @frag >= 30.0  
                SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD';  
            IF @partitioncount > 1  
                SET @command = @command + N' PARTITION=' + CAST(@partitionnum AS nvarchar(10));  
            EXEC (@command);  
            --PRINT N'Executed: ' + @command;  
        END;  
      
    -- Close and deallocate the cursor.  
    CLOSE partitions;  
    DEALLOCATE partitions;  
      
    -- Drop the temporary table.  
    DROP TABLE #work_to_do; */  
END
GO