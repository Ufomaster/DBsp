SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuiriy$    	$Create date:   30.07.2018$*/
/*$Modify:     Oleynik Yuiriy$    	$Modify date:   30.07.2018$*/
/*$Version:    1.00$   $Description: выгрузка выработки по ЦС в буферную таблицу для создания сдельных нарядов в 1С $*/
create PROCEDURE [sync].[sp_1CProductivity_Insert]
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @StartDate datetime, @EndDate datetime
  --  SELECT @StartDate = '07.29.2018 00:00:00', @EndDate = '07.29.2018 23:59:59'    
    DECLARE @D datetime
    SELECT @D = GetDate()
    SELECT @StartDate = CAST(MONTH(@D) as varchar) + '.' + CAST(DAY(@D) AS varchar) + '.' + CAST(YEAR(@D) AS Varchar) + ' 00:00:00', 
           @EndDate = CAST(MONTH(@D) as varchar) + '.' + CAST(DAY(@D) AS varchar) + '.' + CAST(YEAR(@D) AS Varchar) + ' 23:59:59'
    --делаем прыдыдущий день
    SELECT @StartDate = @StartDate-1, @EndDate = @EndDate -1

    IF object_id('tempdb..#Production') IS NOT NULL DROP TABLE #Production

    --Get Spekler Data
     
    CREATE TABLE #Production
    (ManufactureID smallint, ManufactureName varchar(255), SectorID tinyint, SectorName varchar(255), 
     EmployeeID int, EmployeeFullName varchar(255),  EmployeeCode1C varchar(36), EmployeeINN varchar(30), --EmployeePositionName varchar(255), 
     ShiftID int, ShiftStartDate datetime, PCCID int, PCCName varchar(255), PCCNumber varchar(30), CardCountInvoice int,
     TmcID int, TimeAll int, TimeAllMinusOne int, Amount decimal(38,10), 
     TechnologicalOperationID int, TOType varchar(6), TimeAmountSec decimal(38,10), TimeAmountHour decimal(38,10), TOTimePerOneCard decimal(38,10))
         
    INSERT INTO #Production
    EXEC manufacture.sp_ProductionStatistic_Select2 null, @StartDate, @EndDate

    IF EXISTS(SELECT TOP 1 * FROM #Production WHERE ManufactureID = 1)
    BEGIN
        DECLARE @T TABLE(ID int)
        DECLARE @ID int
        INSERT INTO sync.[1CProductivity](Status, DocDate, DepartmentCode1C, Comments)
        OUTPUT INSERTED.ID INTO @t
        SELECT 0, @StartDate, 'dec639db-e2f9-11e6-96da-0050569e8704', 'Выгрузка из Спеклера'
        SELECT @ID = ID FROM @T

        INSERT INTO sync.[1CProductivityDetails]( [1CProductivityID], EmployeeCode1C, PCCNumber, TechnologicalOperationCode1C, ShiftStartDate, Amount, AmountTime) 
        SELECT @ID, p.EmployeeCode1C, pc.Number, t.Code1C, p.ShiftStartDate, SUM(p.Amount), SUM(p.TimeAmountSec)
        FROM #Production p
        LEFT JOIN ProductionCardCustomize pc ON pc.ID = p.PCCID
        LEFT JOIN manufacture.StorageStructureSectors sss ON sss.ID = p.SectorID
        LEFT JOIN vw_Employees e ON e.INN = p.EmployeeINN
        INNER JOIN manufacture.TechnologicalOperations t ON t.ID = p.TechnologicalOperationID
        WHERE p.ManufactureID = 1
        GROUP BY p.EmployeeCode1C, pc.Number, p.ShiftStartDate, t.Code1C
        ORDER BY p.EmployeeCode1C

        UPDATE sync.[1CProductivity]
        SET Status = 1 WHERE ID = @ID 
    END

    DROP TABLE #Production
END
GO