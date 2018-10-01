SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   12.05.2017$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   06.11.2017$*/
/*$Version:    1.00$   $Decription:  $*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncProduceGetCreateTableText]
AS
BEGIN
  SELECT '
   SET NOCOUNT ON
   IF OBJECT_ID(''tempdb..#WPProduce'') IS NOT NULL 
       TRUNCATE TABLE #WPProduce ELSE 
   CREATE TABLE #WPProduce(ID smallint IDENTITY(1,1), TMCID int, AmountMax decimal(38, 10), Amount decimal(38, 10), 
       Name varchar(255), StatusName varchar(255), isMajorTMC bit, StatusID int, UnitName varchar(50), 
       isDeleted bit, Number varchar(20), IsTL bit, PCCID int, Norma decimal(38, 10), NormaAmount decimal(38, 10), 
       CntID int, SkipZlSplit bit, FailAmount decimal(38, 10), isNormaOverrideWithValueOne bit)
    
   IF OBJECT_ID(''tempdb..#TLList'') IS NOT NULL 
       TRUNCATE TABLE #TLList ELSE 
   CREATE TABLE #TLList(TMCID int, Name varchar(255), StatusName varchar(255), StatusID int)

   IF OBJECT_ID(''tempdb..#ProductOutEmployees'') IS NOT NULL 
       TRUNCATE TABLE #ProductOutEmployees ELSE
   CREATE TABLE #ProductOutEmployees(ID smallint IDENTITY(1,1), EID int,
       FullName varchar(255), Number varchar(20), PCCID int, TmcID int, Amount decimal(38, 10))
  
   IF OBJECT_ID(''tempdb..#WPProducePCC'') IS NOT NULL
       TRUNCATE TABLE #WPProducePCC ELSE
   CREATE TABLE #WPProducePCC(ID smallint IDENTITY(1,1), CardCount tinyint, 
       Name varchar(255), Number varchar(20), PCCID int, TmcID int) 
  
   IF OBJECT_ID(''tempdb..#ProductTMCSplit'') IS NOT NULL 
       TRUNCATE TABLE #ProductTMCSplit ELSE
   CREATE TABLE #ProductTMCSplit(ID smallint IDENTITY(1,1), TMCID int, Amount decimal(38, 10), AmountMax decimal(38, 10), PCCID int,
       Name varchar(255), StatusName varchar(255), isMajorTMC bit, StatusID int, UnitName varchar(50), Number varchar(20), PCCFromID int)
  
   IF OBJECT_ID(''tempdb..#WPProduceProduct'') IS NOT NULL
       TRUNCATE TABLE #WPProduceProduct ELSE 
   CREATE TABLE #WPProduceProduct(ID smallint IDENTITY(1,1), TMCID int, AmountMax decimal(38, 10), Amount decimal(38, 10),
       Name varchar(255), StatusName varchar(255), isMajorTMC bit, StatusID int)
  '
END
GO