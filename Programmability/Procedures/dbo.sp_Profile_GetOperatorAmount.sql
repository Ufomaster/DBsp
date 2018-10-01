SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   01.03.2017$
--$Modify:     Yuriy Oleynik$    $Modify date:   02.03.2017$
--$Version:    1.00$   $Decription: В профиле - выборка статискии оператора$
CREATE PROCEDURE [dbo].[sp_Profile_GetOperatorAmount]
    @MonthID tinyint,
    @YearID smallint,
    @EmployeeID int
AS
BEGIN
    SET NOCOUNT ON;
    SELECT pc.Number, pc.Name, ss.Name AS SectorName, dbo.fn_DateCropTime(a.CreateDate) AS [Date], pc.TechCardNumber, SUM(a.Amount) AS Amount
    FROM manufacture.ProductionTasksDocDetails a
    INNER JOIN manufacture.ProductionTasksDocs d ON d.ID = a.ProductionTasksDocsID AND d.ProductionTasksOperTypeID = 2
    INNER JOIN ProductionCardCustomize pc ON pc.ID = a.ProductionCardCustomizeID
    INNER JOIN manufacture.StorageStructureSectors ss ON ss.ID = d.StorageStructureSectorID
    WHERE a.EmployeeID = @EmployeeID AND a.MoveTypeID = 1 AND DATEPART(mm, a.CreateDate) = @MonthID AND DATEPART(yy, a.CreateDate) = @YearID
    GROUP BY pc.Number, pc.Name, ss.Name, dbo.fn_DateCropTime(a.CreateDate), pc.TechCardNumber
    HAVING SUM(a.Amount) > 0
END
GO