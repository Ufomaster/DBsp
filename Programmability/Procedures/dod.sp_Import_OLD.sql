SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   05.07.2018$
--$Modify:     Poliatykin Oleksii$    $Modify date:   24.07.2018$
--$Version:    1.00$   $Decription: Добавляем данные в таблицы таблицы XCardsData_X и XCardsData_XDetailes
CREATE PROCEDURE [dod].[sp_Import_OLD] (
    @FileType tinyint,
    @JobsSettingsID int)
  AS
BEGIN

  SET NOCOUNT ON;
  DECLARE @TableName varchar(50)
  , @TableNameDetails varchar(50)
  SET @TableName = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)
  SET @TableNameDetails = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)+'Details'

  IF @FileType IN (1,2,3,5,6,8)
  BEGIN

    EXEC ('
    MERGE INTO  dod.'+@TableName+' as xcd
    USING 
    (
    SELECT
      uid
    , Max(dit.CardMasterKey) as CardMasterKey
    , Max(dit.CardConfigurationKey) as CardConfigurationKey
    , Max(dit.CardLevel3SwitchKey) as CardLevel3SwitchKey
    , Max(dit.MTrack1) as MTrack1
    , Max(dit.MTrack2) as MTrack2
    , Max(dit.MTrack3) as MTrack3
     FROM #DodImportTable dit
--     FROM dod.DodImportTable dit
    GROUP BY uid 
    )
    as det
     ON xcd.uid = det.uid
    WHEN MATCHED THEN
     UPDATE SET
     xcd.CardMasterKey = det.CardMasterKey,
     xcd.CardConfigurationKey = det.CardConfigurationKey,
     xcd.CardLevel3SwitchKey = det.CardLevel3SwitchKey,
     xcd.ModifyDate = GETDATE(),
     xcd.MTrack1 = det.MTrack1,
     xcd.MTrack2 = det.MTrack2,
     xcd.MTrack3 = det.MTrack3
    WHEN NOT MATCHED THEN
     INSERT (Uid, CardMasterKey, CardConfigurationKey, CardLevel3SwitchKey, ModifyDate, MTrack1, MTrack2, MTrack3, Status) 
     VALUES (det.Uid, det.CardMasterKey, det.CardConfigurationKey, det.CardLevel3SwitchKey, GETDATE(), det.MTrack1, det.MTrack2, det.MTrack3, 1)
-- поддерживаем дозагрузку - закоменчено 2 строки
--    WHEN NOT MATCHED BY SOURCE THEN
--     DELETE
     ; 
    ')
    
    EXEC ('
    MERGE INTO  dod.'+@TableNameDetails+' as xcdd
    USING 
    (
    SELECT 
      xcd.id as XCardsDataID, 
      dit.Sector,
      dit.Block0, 
      dit.Block1,
      dit.Block2,
      dit.Block3,
      dit.Block4,
      dit.Block5,
      dit.Block6,
      dit.Block7,
      dit.Block8,
      dit.Block9,
      dit.Block10,
      dit.Block11,
      dit.Block12,
      dit.Block13,
      dit.Block14,
      dit.Block15,
      dit.AESkeyA,
      dit.AESkeyB
     FROM #DodImportTable dit 
--     FROM dod.DodImportTable dit      
    LEFT JOIN dod.'+@TableName+' xcd on dit.UID = xcd.UID 
    WHERE dit.Sector IS NOT NULL
    )
    as det
     ON (xcdd.XCardsDataID = det.XCardsDataID) and (xcdd.Sector =  det.Sector)
    WHEN MATCHED THEN
     UPDATE SET
      xcdd.Block0 =  det.Block0,
      xcdd.Block1 =  det.Block1,
      xcdd.Block2 =  det.Block2,
      xcdd.Block3 =  det.Block3,
      xcdd.Block4 =  det.Block4,
      xcdd.Block5 =  det.Block5,
      xcdd.Block6 =  det.Block6,
      xcdd.Block7 =  det.Block7,
      xcdd.Block8 =  det.Block8,
      xcdd.Block9 =  det.Block9,
      xcdd.Block10 =  det.Block10,
      xcdd.Block11 =  det.Block11,
      xcdd.Block12 =  det.Block12,
      xcdd.Block13 =  det.Block13,
      xcdd.Block14 =  det.Block14,
      xcdd.Block15 =  det.Block15,
      xcdd.AESkeyA =  det.AESkeyA,
      xcdd.AESkeyB =  det.AESkeyB
    WHEN NOT MATCHED THEN
     INSERT (XCardsDataID, Sector,Block0,Block1,Block2,Block3,Block4,Block5,Block6,Block7,Block8,Block9,Block10,Block11,Block12,Block13,Block14,Block15,AESkeyA,AESkeyB) 
     VALUES (det.XCardsDataID, det.Sector, det.Block0, det.Block1, det.Block2, det.Block3, det.Block4, det.Block5, det.Block6, det.Block7, det.Block8, det.Block9, det.Block10, det.Block11, det.Block12, det.Block13, det.Block14, det.Block15, det.AESkeyA, det.AESkeyB)
-- поддерживаем дозагрузку - закоменчено 2 строки
--    WHEN NOT MATCHED BY SOURCE THEN
--     DELETE
; 
    ')

  END
END
GO