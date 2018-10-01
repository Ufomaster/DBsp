SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   28.04.2016$*/
/*$Create:     Zapadinskiy Anatoliy$    $Modify date:   28.04.2016$*/
/*$Version:    2.00$   $Decription: Get statistic for all jobs $*/
CREATE PROCEDURE [manufacture].[sp_Stat_ForAllJobsEx]
AS
BEGIN
  SET NOCOUNT ON;   
    
    CREATE TABLE #Stat(pID int, Time float, EmployeeGroupsFactID int, StorageStructureID smallint, ShiftID int, JobStageID int, PackedDate datetime)
    CREATE TABLE #P(ID int, [StorageStructureID] smallint, [EmployeeGroupsFactID] int, [PackedDate] datetime, RNum int NOT NULL, JobStageID int)
        
    DECLARE @SomeTmcID int, @ColumnName varchar(255), @JobStageID int, @Query varchar(8000)
    
    DECLARE CRS CURSOR STATIC LOCAL FOR
    SELECT js.ID
    FROM manufacture.JobStages js
         LEFT JOIN manufacture.PTmcImportTemplates i on (i.JobStageID = js.ID) AND (IsNull(i.isDeleted,0) <> 1)
    WHERE IsNull(js.isDeleted,0) = 0
          AND i.ID is not NULL
       
    OPEN CRS         

    FETCH NEXT FROM CRS INTO @JobStageID                     
                      
    WHILE @@FETCH_STATUS=0
    BEGIN
        SELECT TOP 1 @SomeTmcID = a.TmcID, @ColumnName = c.GroupColumnName
        FROM manufacture.JobStageChecks a
        	LEFT JOIN manufacture.PTmcImportTemplateColumns c on c.ID = a.ImportTemplateColumnID
        WHERE a.JobStageID = @JobStageID AND a.TypeID = 2 AND a.isDeleted = 0
        ORDER BY a.SortOrder DESC
        
        IF EXISTS(
              SELECT * FROM information_schema.tables t
              WHERE t.TABLE_SCHEMA = 'StorageData'
                    AND t.TABLE_NAME = 'pTMC_' + CAST(@SomeTmcID AS Varchar(13)))
        BEGIN          
            /*TRUNCATE TABLE #P*/
    		SET @Query = 
            'INSERT INTO #P(ID, [StorageStructureID], [EmployeeGroupsFactID], [PackedDate], RNum, JobStageID)
            SELECT p.ID, p.[StorageStructureID], p.[EmployeeGroupsFactID], p.[PackedDate], Row_Number() OVER (ORDER BY p.EmployeeGroupsFactID, p.PackedDate) as RNum, '+ CAST(@JobStageID AS Varchar(13)) +'
            FROM StorageData.pTMC_' + CAST(@SomeTmcID AS Varchar(13)) + ' p
                 INNER JOIN StorageData.G_' + CAST(@JobStageID AS Varchar(13)) + ' as g on g.' + @ColumnName +' = p.ID            
            WHERE StatusID = 3 '
            
            EXEC (@Query)
            
        END    
        FETCH NEXT FROM CRS INTO @JobStageID     
    END
    CLOSE CRS
    DEALLOCATE CRS
         
    INSERT INTO #Stat(pID, EmployeeGroupsFactID, Time, StorageStructureID, ShiftID, JobStageID, PackedDate)
    SELECT p.ID, p.EmployeeGroupsFactID, DATEDIFF(ms, p1.PackedDate, p.PackedDate)/1000.0 as Time, p.StorageStructureID, e.ShiftID as ShiftID, p.JobStageID, p.PackedDate
    FROM #P p
         LEFT JOIN #P p1 on (p.RNum = p1.RNum + 1) AND (p.EmployeeGroupsFactID = p1.EmployeeGroupsFactID) AND (p.JobStageID = p1.JobStageID)
         LEFT JOIN shifts.EmployeeGroupsFact e on e.ID = p.EmployeeGroupsFactID

	UPDATE tab
    SET Time = avgTime
    FROM
        (SELECT s.Time, g.avgTime
        FROM #Stat s
             LEFT JOIN (SELECT s.JobStageID, s.EmployeeGroupsFactID, Round(AVG(s.Time),3) as avgTime
                        FROM #Stat s
                        WHERE s.Time is not null
                        GROUP BY s.JobStageID, s.EmployeeGroupsFactID) g on (g.EmployeeGroupsFactID = s.EmployeeGroupsFactID) AND (g.JobStageID = s.JobStageID)
	    WHERE s.Time is NULL) tab     

   SELECT Time, EmployeeGroupsFactID, StorageStructureID, ShiftID, JobStageID, PackedDate
   FROM #Stat
   ORDER BY PID
   
   DROP TABLE #P
   DROP TABLE #Stat
END
GO