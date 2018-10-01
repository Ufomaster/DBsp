SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create PROCEDURE [dod].[sp_GetTempTableFields] 
    @FileType tinyint = 0
AS
BEGIN
  SELECT 1 AS ID, 'UID' AS [Name], 0 AS [Type]
  UNION ALL
  SELECT 2, 'CardMasterKey', 0
  UNION ALL
  SELECT 3, 'CardConfigurationKey', 0
  UNION ALL
  SELECT 4, 'CardLevel3SwitchKey', 0
  UNION ALL
  SELECT 5, 'MTrack1', 0
  UNION ALL
  SELECT 6, 'MTrack2', 0
  UNION ALL
  SELECT 7, 'MTrack3', 0
  UNION ALL
  SELECT 8, 'Sector', 1
  UNION ALL
  SELECT 9, 'Block0', 2
  UNION ALL
  SELECT 10, 'Block1', 2
  UNION ALL
  SELECT 11, 'Block2', 2
  UNION ALL
  SELECT 12, 'Block3', 2
  UNION ALL
  SELECT 13, 'Block4', 2
  UNION ALL
  SELECT 14, 'Block5', 2
  UNION ALL
  SELECT 15, 'Block6', 2
  UNION ALL
  SELECT 16, 'Block7', 2
  UNION ALL
  SELECT 17, 'Block8', 2
  UNION ALL
  SELECT 18, 'Block9', 2
  UNION ALL
  SELECT 19, 'Block10', 2
  UNION ALL
  SELECT 20, 'Block11', 2
  UNION ALL
  SELECT 21, 'Block12', 2
  UNION ALL
  SELECT 22, 'Block13', 2
  UNION ALL
  SELECT 23, 'Block14', 2
  UNION ALL
  SELECT 24, 'Block15', 2
  UNION ALL
  SELECT 25, 'AESkeyA', 2
  UNION ALL
  SELECT 26, 'AESkeyB', 2
  
END
GO