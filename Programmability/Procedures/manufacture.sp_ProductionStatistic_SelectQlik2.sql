SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$	$Create date:   09.11.2017$*/
/*$Modify:     Oleynik Yuriy$	$Modify date:   22.01.2018$$*/
/*$Version:    2.00$   $Decription: Получение информации о выработке операторов$*/
CREATE PROCEDURE [manufacture].[sp_ProductionStatistic_SelectQlik2]
   @StartDate datetime, 
   @EndDate datetime
AS
BEGIN
    SET ANSI_WARNINGS OFF;
	SET NOCOUNT ON 
    IF object_id('tempdb..#Production') is not null DROP TABLE #Production
    
    CREATE TABLE #Production
    (ManufactureID smallint, ManufactureName varchar(255), SectorID tinyint, SectorName varchar(255), 
     EmployeeID int, EmployeeFullName varchar(255),  EmployeeCode1C varchar(36), EmployeeINN varchar(30),-- EmployeePositionName varchar(255), 
     ShiftID int, ShiftStartDate datetime, PCCID int, PCCName varchar(255), PCCNumber varchar(30), CardCountInvoice int,
     TmcID int, TimeAll int, TimeAllMinusOne int, Amount decimal(38,10), 
     TechOperationID int, [TO] varchar(255), TOType varchar(6),
     TimeAmountSec decimal(38,10), TimeAmountHour decimal(38,10), TOTimePerOneCard decimal(38,10))
     
    INSERT INTO #Production
    EXEC manufacture.sp_ProductionStatistic_Select2 null, @StartDate, @EndDate

    SELECT p.ManufactureName as ManufactureNameT
    	   , p.SectorID
           , p.EmployeeINN as [INN]
           --, p.EmployeePositionName
           , p.PCCID as PccID
           , p.ShiftStartDate as DateT
           , p.Amount
           --, p.[TO] as [TOName]
           , p.TOType
           , p.TimeAmountSec as TimeT
           , 'SpeklerAmount' as TypeT  
           , p.TOID
    FROM #Production p

    DROP TABLE #Production
END
GO