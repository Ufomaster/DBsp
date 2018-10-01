SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Polyatykin Oleksey$    $Create date:   06.09.2018$*/
/*$Modify:     Polyatykin Oleksey$    $Create date:   28.09.2018$*/
/*$Version:    1.00$   $Description: Создаем таблицу для Pallets_[JobStageID] PalletsDetails_[JobStageID], если она еще не существует$*/
CREATE PROCEDURE [manufacture].[sp_Pallets_CreateTables]
  @JobStageID int
  AS
BEGIN
  SET NOCOUNT ON;
  /*Check table for exist*/
  DECLARE 
    @TableName varchar(50)
  , @TableNameD varchar(50)
  , @TableBoxName varchar(50)

  /*Create main table*/
  SET @TableName = 'Pallets_' + Convert(varchar(30), @JobStageID)
  IF NOT EXISTS(
  SELECT *
  FROM information_schema.tables t
  WHERE t.TABLE_SCHEMA = 'StorageData'
        AND t.TABLE_NAME = @TableName)
  BEGIN
    EXEC ('
              CREATE TABLE [StorageData].['+@TableName+'] (
              [ID] int IDENTITY(1, 1) NOT NULL,
              [Value] varchar(255) NULL,
             
              CONSTRAINT [PK_'+@TableName+'_ID] PRIMARY KEY CLUSTERED ([ID])
              )              
              
              CREATE NONCLUSTERED INDEX [IDX_'+@TableName+
      '_Value] ON [StorageData].['+@TableName+']
                ([Value])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)
              ON [PRIMARY]                         
            ')

  END;
  SELECT TOP 1 @TableBoxName = jsc.TmcID
  FROM manufacture.JobStageChecks jsc
  WHERE jsc.JobStageID = @JobStageID
        AND jsc.isDeleted = 0
  ORDER BY jsc.SortOrder /*Create table history*/
  SET @TableNameD = 'PalletsDetails_' + CONVERT (VARCHAR (30), @JobStageID) 
  IF NOT EXISTS (
  SELECT *
  FROM information_schema.tables t
  WHERE t.TABLE_SCHEMA = 'StorageData'
        AND t.TABLE_NAME = @TableNameD)
  BEGIN
    EXEC ('
              CREATE TABLE [StorageData].['+@TableNameD+'] (
              [ID] int IDENTITY(1, 1) NOT NULL,
              [PalletID] int NULL,
              [BoxID] int NULL,              
              [Status] tinyint NULL,
              [ModifyDate] datetime NOT NULL,
              [ModifyEmployeeID] int NOT NULL,         
              CONSTRAINT [PK_'+@TableNameD+'_ID] PRIMARY KEY CLUSTERED ([ID]),
              CONSTRAINT [FK_'+@TableNameD+'_Pallet_ID] FOREIGN KEY ([PalletID]) 
              REFERENCES [StorageData].['+@TableName+'] ([ID]) 
              ON UPDATE NO ACTION
              ON DELETE NO ACTION
/*            ,CONSTRAINT [FK_'+@TableNameD+'_PTmc_ID] FOREIGN KEY ([BoxID]) 
              REFERENCES [StorageData].[pTMC_'+@TableBoxName+'] ([ID]) 
              ON UPDATE NO ACTION
              ON DELETE NO ACTION
*/              
              )       
              
              EXEC sp_bindefault N''[dbo].[DF_CurrentDate]'', N''[StorageData].['
      +@TableNameD+'].[ModifyDate]''        
            ')

  END;
END;
GO