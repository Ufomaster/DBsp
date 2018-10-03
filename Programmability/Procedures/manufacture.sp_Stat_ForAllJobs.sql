SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   08.07.2015$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   03.09.2015$*/
/*$Version:    1.00$   $Decription: Get statistic for all jobs $*/
CREATE PROCEDURE [manufacture].[sp_Stat_ForAllJobs]
AS
BEGIN
    SET NOCOUNT ON;   
    DECLARE @SomeTmcID int, @JobStageID int, @Query varchar(8000)

    CREATE TABLE #Stat(pID int, Time float, EmployeeGroupsFactID int, StorageStructureID smallint, ShiftID int, JobStageID int, PackedDate datetime)
    CREATE TABLE #P(ID int, [StorageStructureID] smallint, [EmployeeGroupsFactID] int, [PackedDate] datetime, RNum int)

    DECLARE CRS CURSOR STATIC LOCAL FOR
    SELECT js.ID
    FROM manufacture.JobStages js
         LEFT JOIN manufacture.PTmcImportTemplates i on (i.JobStageID = js.ID) AND (IsNull(i.isDeleted,0) <> 1)
    WHERE IsNull(js.isDeleted,0) = 0
          AND i.ID is not NULL
       
    OPEN CRS         

    FETCH NEXT FROM CRS INTO @JobStageID
                     
    PRINT @JobStageID
                       
    WHILE @@FETCH_STATUS=0
    BEGIN
        SELECT TOP 1 @SomeTmcID = a.TmcID
        FROM manufacture.JobStageChecks a
        WHERE a.JobStageID = @JobStageID AND a.TypeID = 2 AND a.isDeleted = 0
        ORDER BY a.SortOrder DESC
        
        IF EXISTS(
              SELECT * FROM information_schema.tables t
              WHERE t.TABLE_SCHEMA = 'StorageData'
                    AND t.TABLE_NAME = 'pTMC_' + CAST(@SomeTmcID AS Varchar(13)))
        BEGIN          
            TRUNCATE TABLE #P
    		
            SET @Query = 
            'INSERT INTO #P(ID, [StorageStructureID], [EmployeeGroupsFactID], [PackedDate], RNum)
            SELECT ID, [StorageStructureID], [EmployeeGroupsFactID], [PackedDate], Row_Number() OVER (ORDER BY EmployeeGroupsFactID, PackedDate) as RNum 
            FROM StorageData.pTMC_' + CAST(@SomeTmcID AS Varchar(13)) + ' 
            WHERE StatusID = 3 '
            
            EXEC (@Query)
            
            INSERT INTO #Stat(pID, EmployeeGroupsFactID, Time, StorageStructureID, ShiftID, JobStageID, PackedDate)
            SELECT p.ID, p.EmployeeGroupsFactID, DATEDIFF(ms, p1.PackedDate, p.PackedDate)/1000.0 as Time, p.StorageStructureID, s.ID as ShiftID, @JobStageID, p.PackedDate
            FROM #P p
                 LEFT JOIN #P p1 on (p.RNum = p1.RNum + 1) AND (p.EmployeeGroupsFactID = p1.EmployeeGroupsFactID)
                 LEFT JOIN shifts.Shifts s on p.PackedDate BETWEEN s.FactStartDate AND IsNull(s.FactEndDate,s.PlanEndDate) AND ISNULL(s.IsDeleted,0) = 0
                 LEFT JOIN shifts.WorkPlaces wp on (wp.ShiftID = s.id) AND (wp.StorageStructureID = p.StorageStructureID)
            WHERE wp.ID is not null    

            UPDATE tab
            SET Time = avgTime
            FROM
                (SELECT s.Time, g.avgTime
                FROM #Stat s
                     LEFT JOIN (SELECT s.EmployeeGroupsFactID, Round(AVG(s.Time),3) as avgTime
                                FROM #Stat s
                                WHERE s.Time is not null
                                GROUP BY s.EmployeeGroupsFactID) g on (g.EmployeeGroupsFactID = s.EmployeeGroupsFactID)
                WHERE s.Time is NULL) tab
            
        END    
        FETCH NEXT FROM CRS INTO @JobStageID     
    END 

    SELECT * FROM #Stat
    ORDER BY PID

    DROP TABLE #P
	DROP TABLE #Stat
END
GO

GRANT EXECUTE ON [manufacture].[sp_Stat_ForAllJobs] TO [QlikView]
GO