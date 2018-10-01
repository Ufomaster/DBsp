SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   26.08.2014$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   10.10.2014$*/
/*$Version:    1.00$   $Decription: Get data from pTMC table $*/
CREATE PROCEDURE [manufacture].[sp_PTmcTable_Select]
    @PTmcGroupID int
AS
BEGIN   
    SET NOCOUNT ON
    
    DECLARE @STmcID varchar(11), @FromValue varchar(255), @ToValue varchar(255), @StatusID tinyint, @JobStageID int, @isPacked bit
           , @Query varchar(5000), @TmcName varchar(500), @ColumnName varchar(18), @StorageStructureID int

	--Здесь может быть проблема - можем выгрузить не те данные, если ТМЦ в работе используется больше одного раза
    SELECT TOP 1 @STmcID = p.TmcID, @FromValue = p.Min, @ToValue = p.Max, @StatusID = p.StatusID, @JobStageID = p.JobStageID, @isPacked = p.isPacked, @TmcName = t.Name, @ColumnName = p.GroupColumnName, @StorageStructureID= p.StorageStructureID
    FROM manufacture.PTmcGroups p
         LEFT JOIN tmc t on p.TmcID = t.ID
    WHERE p.ID = @PTmcGroupID

    SET @Query ='
        SELECT pack.EmployeeGroupsFactID as EmployeeGroupsFactID, shifts.fn_EmployeeGroupDetails_Select(pack.EmployeeGroupsFactID) as EmployeeGroupsFactList
        INTO #TmpEmployees
        FROM 
           StorageData.pTMC_'  + @STmcID +  ' as pack 
        GROUP BY pack.EmployeeGroupsFactID
        
        SELECT p.ID,
               p.Value as [' + @TmcName + '],
               p.Batch as Batch,       
               CASE WHEN p.ParentTMCID is null THEN 0 ELSE 1 END as [Упакован],
               p.PackedDate as [Дата упаковки/списания],
               ps.Name as [Статус],
               te.EmployeeGroupsFactList as [Операторы],
               ss.[Name] as [Место хранения]
        FROM
           (SELECT top 1 t.ID FROM [StorageData].pTMC_'+ @STmcID+' t WHERE Value = '''+ @FromValue +''' ) as tmin,
           (SELECT top 1 t.ID FROM [StorageData].pTMC_'+ @STmcID+' t WHERE Value = '''+ @ToValue +''' ) as tmax,
           StorageData.pTMC_' + @STmcID + ' p                     
           LEFT JOIN manufacture.StorageStructure ss on ss.ID = p.StorageStructureID
           LEFT JOIN #TmpEmployees te on te.EmployeeGroupsFactID = p.EmployeeGroupsFactID                     
           INNER JOIN manufacture.PtmcStatuses ps on ps.ID = p.StatusID
           INNER JOIN
                     (SELECT p.ID FROM StorageData.pTMC_' + @STmcID + ' p
                      INNER JOIN StorageData.G_' + CAST(@JobStageID as varchar(11)) + ' as g on g.' + @ColumnName + ' = p.ID
                      GROUP BY p.ID) g on g.ID = p.ID
        WHERE p.ID between (CASE WHEN tmin.ID > tmax.ID THEN tmax.ID ELSE tmin.ID END) AND (CASE WHEN tmin.ID<tmax.ID THEN tmax.ID ELSE tmin.ID END)                    
             AND p.StatusID = ' + CAST(@StatusID as varchar(11)) + '
             AND (CASE WHEN p.ParentTMCID is null THEN 0 ELSE 1 END = ' + CAST(@isPacked as varchar(1)) + ')             
             AND IsNull(p.StorageStructureID,-1) = ' +  IsNull(CAST(@StorageStructureID as varchar(11)),'-1') +  '
        DROP TABLE #TmpEmployees'
    EXEC (@Query)
END
GO