SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   26.12.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   26.12.2016$*/
/*$Version:    1.00$   $Decription:  $*/
create PROCEDURE [manufacture].[sp_ProductionTasks_FuncShip_GetCreateTableText]
AS
BEGIN
  SELECT '
   SET NOCOUNT ON 
   IF OBJECT_ID(''tempdb..#ProdTaskShipData'') IS NOT NULL 
       TRUNCATE TABLE #ProdTaskShipData ELSE 
   CREATE TABLE #ProdTaskShipData(ID int IDENTITY(1,1), Number varchar(10), TMCID int, MaxAmount decimal(38, 10), Amount decimal(38, 10), 
    Name varchar(255), StatusID int, StatusName varchar(255), ProductionCardCustomizeID int, isMajorTMC bit, StatusFromID int)  

   IF OBJECT_ID(''tempdb..#ProdTaskShipDataPrepare'') IS NOT NULL 
       TRUNCATE TABLE #ProdTaskShipDataPrepare ELSE 
   CREATE TABLE #ProdTaskShipDataPrepare(ID int IDENTITY(1,1), Number varchar(10), TMCID int, MaxAmount decimal(38, 10), Amount decimal(38, 10),
    Name varchar(255), StatusID int, StatusName varchar(255), ProductionCardCustomizeID int, isMajorTMC bit, StatusFromID int)'
END
GO