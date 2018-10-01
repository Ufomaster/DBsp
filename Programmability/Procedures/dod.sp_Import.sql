SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   24.07.2018$
--$Modify:     Yuriy Oleynik$    $Modify date:   25.07.2018$
--$Version:    1.00$   $Decription: Добавляем данные в таблицы таблицы XCardsData_X и XCardsData_XDetailes
CREATE PROCEDURE [dod].[sp_Import] (
    @FileType tinyint,
    @JobsSettingsID int)
 AS
BEGIN 
    SET NOCOUNT ON;
    DECLARE @TableName varchar(50) , @TableNameDetails varchar(50)
    SET @TableName = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)
    SET @TableNameDetails = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)+'Details'

    IF @FileType IN (1,2,3,5,6,8)
    BEGIN
        EXEC ('
DECLARE @T TABLE(ID Int, uid varchar(14))
DECLARE @Err Int
SET XACT_ABORT ON
BEGIN TRAN
BEGIN TRY    
    DELETE a 
    FROM dod.'+@TableNameDetails+' a 
    INNER JOIN dod.'+@TableName+' m ON m.ID = a.XCardsDataID AND m.Status = 1
    INNER JOIN #DodImportTable dit ON m.UID = dit.uid

    DELETE a 
    FROM dod.'+@TableName+' a
    INNER JOIN #DodImportTable dit ON a.UID = dit.uid
    WHERE a.Status = 1

    INSERT INTO dod.'+@TableName+' (uid, CardMasterKey, CardConfigurationKey, CardLevel3SwitchKey, ModifyDate, MTrack1, MTrack2, MTrack3, Status)
    OUTPUT INSERTED.ID, INSERTED.uid INTO @T
    SELECT 
        dit.UID
        , dit.CardMasterKey
        , dit.CardConfigurationKey
        , dit.CardLevel3SwitchKey
        , GETDATE()
        , dit.MTrack1
        , dit.MTrack2
        , dit.MTrack3 
        , 1
    FROM #DodImportTable dit 
    LEFT JOIN dod.'+@TableName+' a ON a.UID = dit.uid
    WHERE (a.ID IS NULL) OR (a.ID IS NOT NULL AND a.Status = 1)
    GROUP BY dit.uid, dit.CardMasterKey, dit.CardConfigurationKey, dit.CardLevel3SwitchKey, dit.MTrack1, dit.MTrack2, dit.MTrack3

    INSERT INTO dod.'+@TableNameDetails+' (XCardsDataID, Sector, Block0,  Block1, Block2, Block3, Block4, Block5, Block6, Block7, Block8, Block9, Block10, Block11, Block12, Block13, Block14, Block15, AESkeyA, AESkeyB)
    SELECT 
        ttab.id,
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
    LEFT JOIN dod.'+@TableName+' a ON a.UID = dit.uid    
    LEFT JOIN @t as ttab on ttab.UID = dit.UID
    WHERE (a.ID IS NULL) OR (a.ID IS NOT NULL AND a.Status = 1)
    ORDER BY ttab.id
    
    COMMIT TRAN
END TRY
BEGIN CATCH
    SET @Err = @@ERROR
    IF @@TRANCOUNT > 0 ROLLBACK TRAN
    EXEC sp_RaiseError @ID = @Err
END CATCH
    
');
    END
END
GO