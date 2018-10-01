SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   09.06.2016$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   11.11.2016$*/
/*$Version:    1.00$   $Decription:  $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_SummaryPrepareShifts]
    @ManufactureStructureID int,
    @StartDate datetime,
    @EndDate datetime,
    @ActiveOnly bit
AS
BEGIN
    DELETE FROM #PT_ShiftFilter
    
    /*DELETE FROM #PT_ZLFilter*/
    
    INSERT INTO #PT_ShiftFilter(ProductionTaskID, ShiftID, Name, Selected, Period, SectorName, PlanStartDate)
    SELECT 
        pt.ID, pt.ShiftID, st.Name, 0,/* ms.[Name],*/
        dbo.fn_DateToString(s.FactStartDate, 'ddmmyy') + ' ' + dbo.fn_DateToString(s.FactStartDate, 'hh:nn') + 
        ' - ' + 
        ISNULL(dbo.fn_DateToString(s.FactEndDate, 'ddmmyy') + ' ' + dbo.fn_DateToString(s.FactEndDate, 'hh:nn'), ''),
        ss.Name,
        DateAdd(dd,DATEDIFF(dd,0,s.PlanStartDate),0) as PlanStartDate
    FROM manufacture.ProductionTasks pt
    INNER JOIN manufacture.StorageStructureSectors ss ON ss.ID = pt.StorageStructureSectorID
    INNER JOIN shifts.Shifts s ON s.ID = pt.ShiftID
    INNER JOIN shifts.ShiftsTypes st ON st.ID = s.ShiftTypeID
    INNER JOIN manufacture.ManufactureStructure ms ON ms.ID = st.ManufactureStructureID
    WHERE s.FactStartDate IS NOT NULL AND ((s.FactEndDate IS NULL AND @ActiveOnly = 1) OR (@ActiveOnly = 0)) AND ISNULL(s.IsDeleted, 0) = 0
        AND s.ShiftTypeID IN (SELECT ID FROM shifts.ShiftsTypes sss WHERE sss.ManufactureStructureID = @ManufactureStructureID OR @ManufactureStructureID = 0)
        AND s.FactStartDate <= ISNULL(@EndDate,   s.FactStartDate) 
        AND (s.FactEndDate   >= ISNULL(@StartDate, s.FactEndDate) OR s.FactEndDate IS NULL)
        --     (s.FactEndDate IS NULL AND s.FactStartDate BETWEEN @StartDate AND @EndDate))
    GROUP BY pt.ID, pt.ShiftID, st.Name, ms.[Name],
        dbo.fn_DateToString(s.FactStartDate, 'ddmmyy') + ' ' + dbo.fn_DateToString(s.FactStartDate, 'hh:nn') + 
        ' - ' + 
        ISNULL(dbo.fn_DateToString(s.FactEndDate, 'ddmmyy') + ' ' + dbo.fn_DateToString(s.FactEndDate, 'hh:nn'), ''),
        ss.Name,
        s.PlanStartDate
    ORDER BY s.PlanStartDate DESC
END
GO