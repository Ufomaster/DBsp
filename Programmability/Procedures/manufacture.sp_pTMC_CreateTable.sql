SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   28.11.2013$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   30.01.2018$*/
/*$Version:    4.00$   $Description: Создаем таблицу для пТМЦ + History, если она еще не существует$*/
CREATE PROCEDURE [manufacture].[sp_pTMC_CreateTable]
  @TmcID int
AS
BEGIN	
	SET NOCOUNT ON;
	/*Check table for exist*/
    DECLARE @TableName varchar(50)
           , @TableNameH varchar(50)
    
	/*Create main table*/
    SET @TableName = 'pTMC_' + Convert(varchar(30), @TmcID)
    IF NOT EXISTS(
          select * from information_schema.tables t
          WHERE t.TABLE_SCHEMA = 'StorageData'
                AND t.TABLE_NAME = @TableName)
    BEGIN
        EXEC ('
              CREATE TABLE [StorageData].['+@TableName+'] (
              [ID] int IDENTITY(1, 1) NOT NULL,
              [Value] varchar(255) NULL,
              [StatusID] tinyint NULL,
              [TMCID] int NULL,
              [StorageStructureID] smallint NULL,
              [ParentTMCID] int NULL,
              [ParentPTMCID] int NULL,
              [OperationID] int NULL,
              [EmployeeGroupsFactID] int NULL,
              [PackedDate] datetime NULL,
              [Batch] varchar(255) NULL,
              [ChallengeTime] smallint NULL,              
              CONSTRAINT [PK_'+@TableName+'_ID] PRIMARY KEY CLUSTERED ([ID]),
              CONSTRAINT [FK_'+@TableName+'_PTmc_ID] FOREIGN KEY ([ParentTMCID]) 
              REFERENCES [dbo].[Tmc] ([ID]) 
              ON UPDATE NO ACTION
              ON DELETE NO ACTION,
              CONSTRAINT [FK_'+@TableName+'_Tmc_ID] FOREIGN KEY ([TMCID]) 
              REFERENCES [dbo].[Tmc] ([ID]) 
              ON UPDATE NO ACTION
              ON DELETE NO ACTION,
              CONSTRAINT [FK_'+@TableName+'_StorageStructure_ID] FOREIGN KEY ([StorageStructureID]) 
              REFERENCES manufacture.[StorageStructure] ([ID]) 
              ON UPDATE NO ACTION
              ON DELETE NO ACTION,
              CONSTRAINT [FK_'+@TableName+'_PTmcStatuses_ID] FOREIGN KEY ([StatusID]) 
              REFERENCES manufacture.[PTmcStatuses] ([ID]) 
              ON UPDATE NO ACTION
              ON DELETE NO ACTION,
              CONSTRAINT [FK_'+@TableName+'_PTmcOperations_ID] FOREIGN KEY ([OperationID]) 
              REFERENCES [manufacture].[PTmcOperations] ([ID]) 
              ON UPDATE NO ACTION
              ON DELETE NO ACTION,
              CONSTRAINT [FK_'+@TableName+'_EmployeeGroupsFact_ID] FOREIGN KEY ([EmployeeGroupsFactID]) 
              REFERENCES [shifts].[EmployeeGroupsFact] ([ID]) 
              ON UPDATE NO ACTION
              ON DELETE NO ACTION )              
              
              CREATE NONCLUSTERED INDEX [IDX_'+@TableName+'_PackedDate] ON [StorageData].['+@TableName+']
                ([PackedDate])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)
              ON [PRIMARY]
              
              CREATE NONCLUSTERED INDEX [IDX_'+@TableName+'_StatusID] ON [StorageData].['+@TableName+']
                ([StatusID])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)
              ON [PRIMARY]

              CREATE NONCLUSTERED INDEX [IDX_'+@TableName+'_TMCID] ON [StorageData].['+@TableName+']
                ([TMCID])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)
              ON [PRIMARY]

              CREATE NONCLUSTERED INDEX [IDX_'+@TableName+'_StorageStructureID] ON [StorageData].['+@TableName+']
                ([StorageStructureID])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)
              ON [PRIMARY]

              CREATE NONCLUSTERED INDEX [IDX_'+@TableName+'_Value] ON [StorageData].['+@TableName+']
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
              
              CREATE NONCLUSTERED INDEX [IDX_'+@TableName+'_EmployeeGroupsFactID] ON [StorageData].['+@TableName+']
                ([EmployeeGroupsFactID])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)
              ON [PRIMARY]            
              
              CREATE NONCLUSTERED INDEX [IDX_'+@TableName+'_Batch] ON [StorageData].['+@TableName+']
                ([Batch])
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
    
/* REMOVE FROM HISTORY*/
/* [TMCID] - we update this field only ones and didnt changed during stages of work*/
/* [Value] - we update this field only ones and didnt changed during stages of work*/
/* [Batch] - we update this field only ones and didnt changed during stages of work*/

	/*Create table history*/    
    SET @TableNameH = 'pTMC_' + Convert(varchar(30), @TmcID) + 'H'
    IF NOT EXISTS(
          select * from information_schema.tables t
          WHERE t.TABLE_SCHEMA = 'StorageData'
                AND t.TABLE_NAME = @TableNameH)
    BEGIN
        EXEC ('
              CREATE TABLE [StorageData].['+@TableNameH+'] (
              [ID] int IDENTITY(1, 1) NOT NULL,
              [StatusID] tinyint NULL,
              [StorageStructureID] smallint NULL,
              [ParentTMCID] int NULL,
              [pTmcID] int NULL,              
              [ParentPTMCID] int NULL,
              [ModifyDate] datetime NOT NULL,
              [ModifyEmployeeID] int NOT NULL,
              [OperationID] int NULL,
              [EmployeeGroupsFactID] int NULL,
              [PackedDate] datetime NULL,  
              [OperationType] tinyint NULL,           
              CONSTRAINT [PK_'+@TableNameH+'_ID] PRIMARY KEY CLUSTERED ([ID]))       
              
              EXEC sp_bindefault N''[dbo].[DF_CurrentDate]'', N''[StorageData].['+@TableNameH+'].[ModifyDate]''        
            ')
/*              CREATE NONCLUSTERED INDEX [IDX_'+@TableNameH+'_PackedDate] ON [StorageData].['+@TableNameH+']
                ([PackedDate])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)
              ON [PRIMARY]
              
              CREATE NONCLUSTERED INDEX [IDX_'+@TableNameH+'_StatusID] ON [StorageData].['+@TableNameH+']
                ([StatusID])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)
              ON [PRIMARY]
              
              CREATE NONCLUSTERED INDEX [IDX_'+@TableNameH+'_pTmcID] ON [StorageData].['+@TableNameH+']
                ([pTmcID])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)
              ON [PRIMARY]              

              CREATE NONCLUSTERED INDEX [IDX_'+@TableNameH+'_StorageStructureID] ON [StorageData].['+@TableNameH+']
                ([StorageStructureID])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)
              ON [PRIMARY]
              
              CREATE NONCLUSTERED INDEX [IDX_'+@TableNameH+'_OperationID] ON [StorageData].['+@TableNameH+']
                ([OperationID])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)
              ON [PRIMARY]       
              
              CREATE NONCLUSTERED INDEX [IDX_'+@TableNameH+'_EmployeeGroupsFactID] ON [StorageData].['+@TableNameH+']
                ([EmployeeGroupsFactID])
              WITH (
                PAD_INDEX = OFF,
                DROP_EXISTING = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                SORT_IN_TEMPDB = OFF,
                ONLINE = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON)
              ON [PRIMARY]        
*/
    END;    
END;
GO