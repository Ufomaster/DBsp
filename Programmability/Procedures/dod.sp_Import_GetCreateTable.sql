SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dod].[sp_Import_GetCreateTable]   
@FileType tinyint
AS
BEGIN
    IF @FileType IN (1,2,3,5,6,8)
        SELECT '
 IF object_id(''tempdb..#DodImportTable'') IS NOT NULL DROP TABLE #DodImportTable
    
  CREATE TABLE #DodImportTable (ID int identity(1,1) NOT NULL, 
  UID varchar(14) NULL,
  CardMasterKey varchar(32) NULL,
  CardConfigurationKey varchar(32) NULL,
  CardLevel3SwitchKey varchar(32) NULL,
  MTrack1 varchar(255) NULL,
  MTrack2 varchar(255) NULL,
  MTrack3 varchar(255) NULL,
  Sector tinyint NULL,
  Block0 varchar(32) NULL,
  Block1 varchar(32) NULL,
  Block2 varchar(32) NULL,
  Block3 varchar(32) NULL,
  Block4 varchar(32) NULL,
  Block5 varchar(32) NULL,
  Block6 varchar(32) NULL,
  Block7 varchar(32) NULL,
  Block8 varchar(32) NULL,
  Block9 varchar(32) NULL,
  Block10 varchar(32) NULL,
  Block11 varchar(32) NULL,
  Block12 varchar(32) NULL,
  Block13 varchar(32) NULL,
  Block14 varchar(32) NULL,
  Block15 varchar(32) NULL,
  AESkeyA varchar(32) NULL,
  AESkeyB varchar(32) NULL)
  
  /*
  CREATE NONCLUSTERED INDEX [IDX_DodImportTableUID] ON #DodImportTable(
    [UID])
WITH(
    PAD_INDEX = OFF,
    IGNORE_DUP_KEY = OFF,
    DROP_EXISTING = OFF,
    STATISTICS_NORECOMPUTE = OFF,
    SORT_IN_TEMPDB = OFF,
    ONLINE = OFF,
    ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON)  
    
CREATE NONCLUSTERED INDEX [IDX_DodImportTableSector] ON #DodImportTable(
    [Sector])
WITH(
    PAD_INDEX = OFF,
    IGNORE_DUP_KEY = OFF,
    DROP_EXISTING = OFF,
    STATISTICS_NORECOMPUTE = OFF,
    SORT_IN_TEMPDB = OFF,
    ONLINE = OFF,
    ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON)      
  */
  '
END
GO