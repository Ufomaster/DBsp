SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   19.08.2014$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   03.09.2015$*/
/*$Version:    1.00$   $Decription: obsolete$*/
create PROCEDURE [manufacture].[sp_Stat_ShiftSelect_obsolete]
    @JobStageID int, 
    @ShiftID int
AS
BEGIN 
    RETURN;    
  
    SET NOCOUNT ON;
    DECLARE @TmcID int, @Query varchar(max)

    SELECT TOP 1 @TmcID = a.TmcID 
    FROM manufacture.JobStageChecks a
    WHERE a.JobStageID = @JobStageID AND a.TypeID = 2
        AND a.isDeleted = 0 AND a.UseMaskAsStaticValue = 0

    IF OBJECT_ID('tempdb..#EMP') IS NOT NULL DROP TABLE #EMP
        CREATE TABLE #EMP(cnt INT, EmployeeGroupsFactID INT)

    SET @Query =
    'INSERT INTO #EMP (cnt, EmployeeGroupsFactID)
         SELECT 
             COUNT(DISTINCT p.ID),
             p.EmployeeGroupsFactID
         FROM [StorageData].pTMC_' + CAST(@TmcID as varchar(13)) + ' p
         LEFT JOIN shifts.EmployeeGroupsFactDetais eg ON eg.EmployeeGroupsFactID = p.EmployeeGroupsFactID
         INNER JOIN shifts.Shifts s ON p.PackedDate > s.FactStartDate AND ((p.PackedDate <= ISNULL(s.FactEndDate, p.PackedDate))) AND ISNULL(s.IsDeleted,0) = 0
         WHERE p.StorageStructureID IN (SELECT DISTINCT w.StorageStructureID
                                        FROM shifts.Shifts s
                                        LEFT JOIN shifts.WorkPlaces w on w.ShiftID = s.ID
                                        WHERE ISNULL(s.IsDeleted,0) = 0 AND s.ID = ' + CAST(@ShiftID as varchar(13)) + ')
               AND s.ID = '+ CAST(@ShiftID as varchar(13)) + '
         GROUP BY p.EmployeeGroupsFactID'

    EXEC(@Query)      

    SELECT em.FullName,
          SUM(a.IDs) AS RecCount
    FROM
       (SELECT s.EmployeeGroupsFactID,
              CAST(e.cnt as float)/COUNT(s.EmployeeID) IDs
       FROM #EMP e
            LEFT JOIN shifts.EmployeeGroupsFactDetais s ON s.EmployeeGroupsFactID=e.EmployeeGroupsFactID
       GROUP BY s.EmployeeGroupsFactID, e.cnt) a
       LEFT JOIN shifts.EmployeeGroupsFactDetais eg ON eg.EmployeeGroupsFactID=a.EmployeeGroupsFactID
       LEFT JOIN vw_Employees em ON em.ID=eg.EmployeeID
    GROUP BY em.FullName

    DROP TABLE #EMP
END
GO