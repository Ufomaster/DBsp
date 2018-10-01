SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   03.08.2016$*/
/*$Modify:     Oleynik Yuriy$         $Modify date:   08.09.2017$*/
/*$Version:    3.00$   $Decription: Выбор сменок для конкретного сектора с учетом закрытого периода в 1С$*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_Select]
    @StorageStructureSectorID int,
    @ViewAll bit
    
AS
BEGIN
    SET NOCOUNT ON
    
    DECLARE @ClosedPeriod datetime
    SELECT @ClosedPeriod = cp.[Date] FROM sync.ClosedPeriods cp
	
    SELECT CONVERT(varchar(10), dbo.fn_DateCropTime(s.PlanStartDate), 104) + ' ' + st.[Name] AS ShiftNameEx
           -- 0 - no ProductionTask
           -- 1 - started
           -- 2 - finished
           , CASE WHEN pt.StartDate IS NOT NULL AND pt.EndDate IS NULL THEN 1 
                WHEN pt.StartDate IS NOT NULL AND pt.EndDate IS NOT NULL THEN 2
                ELSE 0 
           END AS PTStatus
           , IsNull(pt.ID,-1) AS ID
           , pt.StartDate
           , pt.EndDate
           , pt.StorageStructureSectorID
           , s.ID AS ShiftID           
    FROM manufacture.StorageStructureSectors sss
    INNER JOIN shifts.ShiftsGroups sg ON sg.ID = sss.ShiftsGroupsID
    INNER JOIN shifts.ShiftsTypes st ON st.ShiftsGroupsID = sg.ID
    INNER JOIN shifts.Shifts s ON s.ShiftTypeID = st.ID AND ISNULL(s.IsDeleted, 0) = 0
    LEFT JOIN manufacture.ProductionTasks pt on pt.ShiftID = s.ID AND pt.StorageStructureSectorID = sss.ID
    WHERE sss.ID = @StorageStructureSectorID
         AND (s.PlanStartDate >= @ClosedPeriod OR (s.PlanStartDate < @ClosedPeriod AND pt.EndDate IS NULL AND pt.StartDate IS NOT NULL))
         AND ( 
               ABS(DATEDIFF(d, s.PlanStartDate, GETDATE())) < 3
               OR @ViewAll = 1
             )
    ORDER BY CASE WHEN pt.StartDate IS NOT NULL AND pt.EndDate IS NULL THEN 0 ELSE 1 END, s.PlanStartDate DESC
END
GO