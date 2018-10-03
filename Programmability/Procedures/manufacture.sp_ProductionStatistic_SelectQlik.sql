SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   14.03.2017$*/
/*$Modify:     Zapadinskiy Anatoliyy$	$Modify date:   29.09.2017$*/
/*$Version:    1.00$   $Decription: Получение информации о выработке операторов$*/
CREATE PROCEDURE [manufacture].[sp_ProductionStatistic_SelectQlik]
AS
BEGIN
    SET ANSI_WARNINGS OFF;
	SET NOCOUNT ON 
    IF object_id('tempdb..#Production') is not null DROP TABLE #Production
    
    CREATE TABLE #Production
    (ManufactureID smallint, ManufactureName varchar(255), SectorID tinyint, SectorName varchar(255), EmployeeID int, EmployeeFullName varchar(255),
     EmployeeCode1C varchar(36), EmployeeINN varchar(30), EmployeePositionName varchar(255), ShiftID int, ShiftStartDate datetime, PCCID int, PCCName varchar(255), PCCNumber varchar(30), CardCountInvoice int,
     TmcID int, TimeAll int, TimeAllMinusOne int, Amount decimal(38,10), TechOperationID int, [TO] varchar(255), TOType varchar(6), TimeAmountSec decimal(38,10), TimeAmountHour decimal(38,10))
     
    INSERT INTO #Production
    EXEC manufacture.sp_ProductionStatistic_Select null, '20160901', null

    SELECT p.ManufactureName as ManufactureNameT
    	   , p.SectorID
           , p.EmployeeINN as [INN]
           , p.EmployeePositionName
           , p.PCCID as PccID
           , p.ShiftStartDate as DateT
           , p.Amount
           , p.[TO] as [TOName]
           , p.TOType
           , p.TimeAmountSec as TimeT
           , 'SpeklerAmount' as TypeT  
           , p.TechOperationID as ToID
    FROM #Production p

    DROP TABLE #Production
END
GO

GRANT EXECUTE ON [manufacture].[sp_ProductionStatistic_SelectQlik] TO [QlikView]
GO