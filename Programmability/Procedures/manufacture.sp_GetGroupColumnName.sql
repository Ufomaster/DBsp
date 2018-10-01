SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   26.09.2014$*/
/*$Modify:     Zapadinskiy Anatoliyy$	$Modify date:   14.12.2016$*/
/*$Version:    1.00$   $Decription: выбор Column_Name по TmcID and Value$*/
CREATE PROCEDURE [manufacture].[sp_GetGroupColumnName] 
@JobStageID int, @TmcID int, @Value varchar(255)
with recompile
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @GroupColumnName varchar(18), @Query varchar(MAX) 
    CREATE TABLE #Res21(ID int, GroupColumnName varchar(18))
    
    DECLARE CRSI CURSOR STATIC LOCAL FOR
    SELECT itc.GroupColumnName
    FROM 
         manufacture.JobStages js                 
         INNER JOIN manufacture.PTmcImportTemplates it on (js.ID = it.JobStageID) AND (IsNull(it.isDeleted,0) = 0)          
         INNER JOIN manufacture.JobStageChecks jsc on jsc.JobStageID = js.ID AND jsc.UseMaskAsStaticValue = 0 
         INNER JOIN manufacture.PTmcImportTemplateColumns itc on itc.TemplateImportID = it.ID AND itc.ID = jsc.ImportTemplateColumnID
         INNER JOIN Tmc t on t.ID = jsc.TmcID
    WHERE js.ID = @JobStageID
          AND jsc.TmcID = @TmcID
    ORDER BY itc.ID
    
    OPEN CRSI
    
    FETCH NEXT FROM CRSI INTO @GroupColumnName

    WHILE @@FETCH_STATUS=0               
    BEGIN
         
        SET @Query = IsNull(@Query + ' UNION ','') + '     
        SELECT g.' + @GroupColumnName + ' as ID, ''' + @GroupColumnName + ''' as GroupColumnName
        FROM StorageData.G_'+Convert(varchar(13), @JobStageID)+ ' g
        WHERE g.' + @GroupColumnName + ' =
             (SELECT top 1 p.ID
             FROM StorageData.pTMC_'+Convert(varchar(13), @TmcID) + ' p
             WHERE p.Value = ''' + @Value + ''')'
             
        FETCH NEXT FROM CRSI INTO @GroupColumnName
    END              
    
    SET @Query = 'INSERT INTO #Res21(ID, GroupColumnName) ' + @Query
            
    CLOSE CRSI    
    DEALLOCATE CRSI    
            
    EXEC (@Query)
    
    SELECT TOP 1 ID, GroupColumnName
    FROM #Res21
    
    DROP TABLE #Res21
END
GO