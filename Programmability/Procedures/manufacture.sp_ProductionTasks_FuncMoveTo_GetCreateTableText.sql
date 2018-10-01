SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   02.12.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   02.12.2016$*/
/*$Version:    1.00$   $Decription:  $*/
create PROCEDURE [manufacture].[sp_ProductionTasks_FuncMoveTo_GetCreateTableText]
AS
BEGIN
  SELECT '
   SET NOCOUNT ON 
   IF OBJECT_ID(''tempdb..#ProdTaskMoveData'') IS NOT NULL 
       TRUNCATE TABLE #ProdTaskMoveData ELSE 
   CREATE TABLE #ProdTaskMoveData(ID int IDENTITY(1,1), Number varchar(10), TMCID int, MaxAmount decimal(38, 10), Amount decimal(38, 10), 
    Name varchar(255), StatusID int, StatusName varchar(255), ProductionCardCustomizeID int, isMajorTMC bit, StatusFromID int)  

   IF OBJECT_ID(''tempdb..#ProdTaskMoveDataPrepare'') IS NOT NULL 
       TRUNCATE TABLE #ProdTaskMoveDataPrepare ELSE 
   CREATE TABLE #ProdTaskMoveDataPrepare(ID int IDENTITY(1,1), Number varchar(10), TMCID int, MaxAmount decimal(38, 10), Amount decimal(38, 10),
    Name varchar(255), StatusID int, StatusName varchar(255), ProductionCardCustomizeID int, isMajorTMC bit, StatusFromID int)'
END
GO