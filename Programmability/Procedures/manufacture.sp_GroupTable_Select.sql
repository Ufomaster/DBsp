SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   27.05.2014$*/
/*$Modify:     Oleynik Yuriy$   		 $Modify date:   22.04.2015$*/
/*$Version:    1.00$   $Decription: Get data from group table $*/
CREATE PROCEDURE [manufacture].[sp_GroupTable_Select]
    @JobStageID int
AS
BEGIN   
    SET NOCOUNT ON
    DECLARE @SomeTmcID int, @SomeColumnName varchar(18), @GroupColumnName varchar(18), 
            @TmcName varchar(500), @TextJoin varchar(5000), @TextSelect varchar(5000), @TmcID int, @Query varchar(5000)

    IF NOT EXISTS(
          SELECT * FROM information_schema.tables t
          WHERE t.TABLE_SCHEMA = 'StorageData'
                AND t.TABLE_NAME = 'G_' + CAST(@JobStageID AS Varchar(13)))
    BEGIN            
        SELECT ''
        RAISERROR ('Данные отсутствуют', 16, 1)        
    END    

    SELECT TOP 1 @SomeTmcID = a.TmcID
    FROM manufacture.JobStageChecks a
    WHERE a.JobStageID = @JobStageID AND a.TypeID = 2 AND a.isDeleted = 0 AND a.UseMaskAsStaticValue = 0
    ORDER BY a.SortOrder

    SELECT top 1 @SomeColumnName = itc.GroupColumnName
    FROM manufacture.PTmcImportTemplates it
         LEFT JOIN manufacture.JobStages js on js.ID = it.JobStageID 
         LEFT JOIN manufacture.PTmcImportTemplateColumns itc on itc.TemplateImportID = it.ID
    WHERE js.ID = @JobStageID
          AND itc.TmcID = @SomeTmcID

    
    SET @TextSelect = '' 
    SET @TextJoin = '' 
   
    DECLARE CRSI CURSOR STATIC LOCAL FOR
/*    SELECT itc.GroupColumnName, t.[Name], t.ID
    FROM manufacture.PTmcImportTemplates it
         LEFT JOIN manufacture.JobStages js on js.ID = it.JobStageID 
         LEFT JOIN manufacture.PTmcImportTemplateColumns itc on itc.TemplateImportID = it.ID
         LEFT JOIN Tmc t on t.ID = itc.TmcID
    WHERE js.ID = @JobStageID
    ORDER BY itc.ID*/
    
    SELECT it.GroupColumnName, t.[Name], t.ID
    FROM manufacture.JobStageChecks c
    INNER JOIN manufacture.PTmcImportTemplateColumns it ON it.ID = c.ImportTemplateColumnID 
    INNER JOIN Tmc t ON t.ID = c.TmcID
    WHERE c.isDeleted = 0 AND c.JobStageID = @JobStageID AND c.UseMaskAsStaticValue = 0
    ORDER BY c.SortOrder

    OPEN CRSI

    FETCH NEXT FROM CRSI INTO @GroupColumnName, @TmcName, @TmcID

    /*Insert only unique values*/
    WHILE @@FETCH_STATUS=0
    BEGIN    
        SELECT @TextSelect = @TextSelect + ' [' + @GroupColumnName  + '].Value' + ' as [' + Substring(@TmcName,1,100)  + '],' 
        SELECT @TextSelect = @TextSelect + ' [' + @GroupColumnName  + '].Batch' + ' as [' + Substring(@TmcName,1,100)  + ' Batch],'         
        SET @TextJoin = @TextJoin + ' LEFT JOIN StorageData.pTMC_'+ CAST(@TmcID AS Varchar(13)) + ' as [' + @GroupColumnName  + '] on g.' + @GroupColumnName + ' = [' + @GroupColumnName + '].ID '
        
        FETCH NEXT FROM CRSI INTO @GroupColumnName, @TmcName, @TmcID
    END         

    SET @Query = '
    SELECT pack.EmployeeGroupsFactID as EmployeeGroupsFactID, shifts.fn_EmployeeGroupDetails_Select(pack.EmployeeGroupsFactID) as EmployeeGroupsFactList
    INTO #TmpEmployees
    FROM 
        StorageData.G_' + CAST(@JobStageID AS Varchar(13)) +  ' as g
        LEFT JOIN StorageData.pTMC_'  + CAST(@SomeTmcID AS Varchar(13)) +  ' as pack on pack.ID = g.' + @SomeColumnName + ' 
    GROUP BY pack.EmployeeGroupsFactID

    SELECT ' + @TextSelect + '
           pack.PackedDate as PackedDate,
           te.EmployeeGroupsFactList as EmployeeGroupsFactList,
           ss.[Name] as StorageName,
           pack.Batch as Batch
    FROM StorageData.G_' + CAST(@JobStageID AS Varchar(13)) +  ' as g     
         LEFT JOIN StorageData.pTMC_'  + CAST(@SomeTmcID AS Varchar(13)) +  ' as pack on pack.ID = g.' + @SomeColumnName + 
         @TextJoin + '
         LEFT JOIN manufacture.StorageStructure ss on ss.ID = pack.StorageStructureID
         LEFT JOIN #TmpEmployees te on te.EmployeeGroupsFactID = pack.EmployeeGroupsFactID
    WHERE pack.PackedDate is not null

    DROP TABLE #TmpEmployees'

    EXEC (@Query)
    --SELECT @Query
END
GO