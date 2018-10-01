SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Poliatykin Oleksii$    $Create date:   20.06.2018$
--$Modify:     Poliatykin Oleksii$    $Modify date:   24.07.2018$
--$Version:    1.00$   $Decription: Создаем таблицы XCardsData_X b XCardsData_XDetailes$

CREATE PROCEDURE [dod].[sp_XCards_CreateTable]
  @JobsSettingsID int
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @TableName varchar(50)
           , @TableNameDetails varchar(50)
  SET @TableName = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)
  SET @TableNameDetails = 'XCardsData_' + Convert(varchar(30), @JobsSettingsID)+'Details'
  
  IF NOT EXISTS(
          select * from information_schema.tables t
          WHERE t.TABLE_SCHEMA = 'dod'
                AND t.TABLE_NAME = @TableName)
   BEGIN
  EXEC ('
              CREATE TABLE [dod].['+@TableName+'] (
              [ID] int IDENTITY(1, 1) NOT NULL,
              [UID] varchar(14) NULL,
              [CardMasterKey] varchar(32) NULL,
              [CardConfigurationKey] varchar(32) NULL,
              [CardLevel3SwitchKey] varchar(32) NULL,
              [ModifyDate] datetime NULL,
              [MTrack1] varchar(255) NULL,
              [MTrack2] varchar(255) NULL,
              [MTrack3] varchar(255) NULL,
              [Status] tinyint NULL,
              CONSTRAINT [PK_'+@TableName+'_ID] PRIMARY KEY CLUSTERED ([ID])
          )              
              
              CREATE UNIQUE NONCLUSTERED INDEX [IDX_'+@TableName+'UID] ON [dod].['+@TableName+']
                ([UID])
              WITH (
                PAD_INDEX = OFF,
                IGNORE_DUP_KEY = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)                                   
            ')
   
   END 

  
    IF NOT EXISTS(
          select * from information_schema.tables t
          WHERE t.TABLE_SCHEMA = 'dod'
                AND t.TABLE_NAME = @TableNameDetails)
   BEGIN
  EXEC ('
              CREATE TABLE [dod].['+@TableNameDetails+'] (
              [ID] int IDENTITY(1, 1) NOT NULL,
              [XCardsDataID] int NULL,
              [Sector] int NULL,
              [Block0] varchar(32) NULL,
              [Block1] varchar(32) NULL,
              [Block2] varchar(32) NULL,
              [Block3] varchar(32) NULL,
              [Block4] varchar(32) NULL,
              [Block5] varchar(32) NULL,
              [Block6] varchar(32) NULL,
              [Block7] varchar(32) NULL,
              [Block8] varchar(32) NULL,
              [Block9] varchar(32) NULL,
              [Block10] varchar(32) NULL,
              [Block11] varchar(32) NULL,
              [Block12] varchar(32) NULL,
              [Block13] varchar(32) NULL,
              [Block14] varchar(32) NULL,
              [Block15] varchar(32) NULL,
              [AESkeyA] varchar(32) NULL,
              [AESkeyB] varchar(32) NULL,
              
              CONSTRAINT [PK_'+@TableNameDetails+'_ID] PRIMARY KEY CLUSTERED ([ID]),
              CONSTRAINT [FK_'+@TableNameDetails+'_XCardsData_ID] FOREIGN KEY ([XCardsDataID]) 
              REFERENCES [dod].['+@TableName+'] ([ID]) 
              ON UPDATE NO ACTION
              ON DELETE NO ACTION )              

              CREATE NONCLUSTERED INDEX [IDX_'+@TableNameDetails+'Sector] ON [dod].['+@TableNameDetails+']
                ([Sector])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)   
                
              CREATE NONCLUSTERED INDEX [IDX_'+@TableNameDetails+'XCardsDataID] ON [dod].['+@TableNameDetails+']
                ([XCardsDataID])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)                                       
            ')
   
   END 
  
END
GO