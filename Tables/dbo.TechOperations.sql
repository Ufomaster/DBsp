CREATE TABLE [dbo].[TechOperations] (
  [ID] [int] IDENTITY,
  [BeginDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [StorageStructureSectorID] [tinyint] NULL,
  [ClassID] [smallint] NULL,
  [TechnologicalOperationID] [int] NULL,
  CONSTRAINT [PK_TechOperations_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[TechOperations] WITH NOCHECK
  ADD CONSTRAINT [FK_TechOperations_StorageStructureSectors_ID] FOREIGN KEY ([StorageStructureSectorID]) REFERENCES [manufacture].[StorageStructureSectors] ([ID])
GO

ALTER TABLE [dbo].[TechOperations]
  ADD CONSTRAINT [FK_TechOperations_TechnologicalOperations_ID] FOREIGN KEY ([TechnologicalOperationID]) REFERENCES [manufacture].[TechnologicalOperations] ([ID])
GO

ALTER TABLE [dbo].[TechOperations]
  ADD CONSTRAINT [FK_TechOperations_TechOperationsClasses_ID] FOREIGN KEY ([ClassID]) REFERENCES [dbo].[TechOperationsClasses] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'TechOperations', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата начала действия', 'SCHEMA', N'dbo', 'TABLE', N'TechOperations', 'COLUMN', N'BeginDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата конца действия', 'SCHEMA', N'dbo', 'TABLE', N'TechOperations', 'COLUMN', N'EndDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор участка', 'SCHEMA', N'dbo', 'TABLE', N'TechOperations', 'COLUMN', N'StorageStructureSectorID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор класса технологической операции', 'SCHEMA', N'dbo', 'TABLE', N'TechOperations', 'COLUMN', N'ClassID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТО', 'SCHEMA', N'dbo', 'TABLE', N'TechOperations', 'COLUMN', N'TechnologicalOperationID'
GO