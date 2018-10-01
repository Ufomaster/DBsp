SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   02.11.2016$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   30.11.2016$*/
/*$Version:    1.00$   $Decription: $*/
create PROCEDURE [manufacture].[sp_ProductionTasks_MassMoveGetCreateTableText_obsolete]
AS
BEGIN
    SELECT '
    IF object_id(''tempdb..#TMCKoef'') IS NOT NULL TRUNCATE TABLE #TMCKoef
ELSE
    CREATE TABLE #TMCKoef(ID int, TMCID int, TmcName varchar(255), Koef decimal(38,10), 
                          AddAmount decimal(38,10), MaxAmount decimal(38,10), WOFAmount decimal(38,10))
                              
IF object_id(''tempdb..#NTMCActiveTotals'') IS NOT NULL TRUNCATE TABLE #NTMCActiveTotals
ELSE
    CREATE TABLE #NTMCActiveTotals(ID int, TMCID int, TmcName varchar(255), Amount decimal(38,10), SectorID int, FailAmount decimal(38,10))
        
IF object_id(''tempdb..#PTMCSS'') IS NOT NULL TRUNCATE TABLE #PTMCSS
ELSE
    CREATE TABLE #PTMCSS(ID int, SSID int, Amount decimal(38,10), SectorID int)
    
IF object_id(''tempdb..#DetailRes'') IS NOT NULL TRUNCATE TABLE #DetailRes
ELSE
    CREATE TABLE #DetailRes(ID int IDENTITY(1,1), TMCID int, TmcName varchar(255), 
         AmountNTMCOnPlace decimal(38,10), MaxAmount decimal(38,10), WOFAmount decimal(38,10), 
         SSID int, AmountPTMCOnPlace decimal(38,10), SectorID int, SectorName varchar(255), AmountNeeded decimal(38,10))
         '
END
GO