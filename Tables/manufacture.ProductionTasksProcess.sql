CREATE TABLE [manufacture].[ProductionTasksProcess] (
  [ID] [int] IDENTITY,
  [StorageStructureSectorID] [tinyint] NULL,
  [StorageStructureSectorToID] [tinyint] NULL,
  [StatusDegradationEnabled] [bit] NULL,
  CONSTRAINT [PK_ProductionTasksProcess_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [manufacture].[ProductionTasksProcess] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasksProcess_StorageStructureSectors (manufacture)_ID] FOREIGN KEY ([StorageStructureSectorID]) REFERENCES [manufacture].[StorageStructureSectors] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasksProcess] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasksProcess_StorageStructureSectors (manufacture)_ID1] FOREIGN KEY ([StorageStructureSectorToID]) REFERENCES [manufacture].[StorageStructureSectors] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksProcess', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор участка, с которого возможно перемещение', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksProcess', 'COLUMN', N'StorageStructureSectorID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор участка, на который возможно перемещение', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksProcess', 'COLUMN', N'StorageStructureSectorToID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Включает понижение статуса передаваемой на целевой участок ГП до "в работе"', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksProcess', 'COLUMN', N'StatusDegradationEnabled'
GO