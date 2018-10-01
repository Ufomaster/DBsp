SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   05.11.2014$*/
/*$Modify:     Skliar Nataliia$    $Modify date:   21.03.2017$*/
/*$Version:    1.00$   $Decription: Get statistic for Pack-Pack check history$*/
CREATE PROCEDURE [manufacture].[sp_Stat_PackPackSelect]
    @JobStageID int
AS
BEGIN
    SET NOCOUNT ON;
    --ищем список тмц для проверки.
    --
   
    DECLARE @CR varchar(5), @SO int
    SET @CR = CHAR(13) + CHAR(10)
    DECLARE @Query varchar(max)
    
    SELECT TOP 1 @SO = j.SortOrder 
    FROM manufacture.JobStageChecks j 
    WHERE j.TypeID = 2 AND j.isDeleted = 0 AND j.JobStageID = @JobStageID 
    ORDER BY j.SortOrder ASC
                       
    
    SELECT @Query = 'CREATE TABLE #Res(ID int identity(1,1), pTmcID int, Value varchar(255), TmcName varchar(255), StorageStructureName varchar(255)) ' + @CR
    
    SELECT @Query = @Query + 
        'INSERT INTO #Res(pTmcID, Value, TmcName, StorageStructureName)' + @CR + 
        'SELECT a.ID, a.Value, ' +  @CR +
        '''' + CAST(t.XMLData.value('(/TMC/Props/Value)[1]', 'varchar(max)') AS varchar(max)) + ''' AS TmcName, ' + @CR +
        'ss.Name AS StorageStructureName ' + @CR +
        'FROM StorageData.pTMC_' + CAST(j.TmcID AS varchar) + ' AS a ' + @CR +
        'LEFT JOIN StorageData.G_' + CAST(j.JobStageID AS varchar) + ' g ON a.id = g.' + itc.GroupColumnName + @CR + 
        'INNER JOIN manufacture.StorageStructure ss ON ss.ID = a.StorageStructureID' + @CR +
        'WHERE g.ID IS NOT NULL AND a.ID IN (SELECT a.ID FROM StorageData.pTMC_' + CAST(j.TmcID AS varchar) + ' AS a ' + @CR +
        '                                        LEFT JOIN StorageData.G_' + CAST(j.JobStageID AS varchar) + ' g ON a.id = g.' + itc.GroupColumnName + @CR + 
        '                                        INNER JOIN StorageData.pTMC_' + CAST(j.TmcID AS varchar) + 'H AS h ON h.pTmcID = a.ID ' + @CR +
        '                                        INNER JOIN manufacture.PTmcOperations AS o ON o.ID = h.OperationID AND o.OperationTypeID = 6)' + @CR +
        'GROUP BY a.ID, a.Value, ss.Name' + @CR + @CR 
    FROM manufacture.JobStageChecks j
    INNER JOIN manufacture.PTmcImportTemplateColumns itc ON itc.ID = j.ImportTemplateColumnID
    INNER JOIN dbo.Tmc t ON t.ID = j.TmcID
    WHERE j.TypeID = 1 AND j.isDeleted = 0 AND j.JobStageID = @JobStageID
    AND j.SortOrder <= ISNULL(@SO - 2, j.SortOrder)
    
    SELECT @Query = @Query + @CR + 
    'SELECT * FROM #Res ' + @CR +
    'ORDER BY StorageStructureName, TmcName, Value' + @CR +
    'DROP TABLE #Res '
    
    EXEC(@Query)


END
GO