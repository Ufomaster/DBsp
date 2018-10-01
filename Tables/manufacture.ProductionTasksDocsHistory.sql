CREATE TABLE [manufacture].[ProductionTasksDocsHistory] (
  [ID] [int] IDENTITY,
  [ModifyDate] [datetime] NULL,
  [ModifyEmployeeID] [int] NULL,
  [DocID] [int] NULL,
  [ProductionTasksID] [int] NULL,
  [EmployeeFromID] [int] NULL,
  [EmployeeToID] [int] NULL,
  [LinkedProductionTasksDocsID] [int] NULL,
  [ProductionTasksOperTypeID] [tinyint] NULL,
  [ConfirmStatus] [bit] NULL,
  [CreateDate] [datetime] NULL,
  [StorageStructureSectorID] [smallint] NULL,
  [StorageStructureSectorToID] [smallint] NULL,
  [OperationType] [tinyint] NULL,
  [JobStageID] [int] NULL,
  CONSTRAINT [PK_ProductionTasksDocsHistory_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionTasksDocsHistory_DocID]
  ON [manufacture].[ProductionTasksDocsHistory] ([DocID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionTasksDocsHistory_StorageStructureSectorToID]
  ON [manufacture].[ProductionTasksDocsHistory] ([StorageStructureSectorToID])
  ON [PRIMARY]
GO

ALTER TABLE [manufacture].[ProductionTasksDocsHistory] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasksDocsHistory_ProductionTasks (manufacture)_ID] FOREIGN KEY ([ProductionTasksID]) REFERENCES [manufacture].[ProductionTasks] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифиикатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата изменений', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя изменившего запись', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор документа', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'DocID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сменного задания', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'ProductionTasksID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника от которого идет перемещение', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'EmployeeFromID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника к которому идет перемещение', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'EmployeeToID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор связанного документа сменного задания при передаче с участка на участок', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'LinkedProductionTasksDocsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор операции документа', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'ProductionTasksOperTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус подтверждения - 0 - ожидает подтверждения, 1 - подтверждено, 2 - не подтверждено', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'ConfirmStatus'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор текущего участка.', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'StorageStructureSectorID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор целевого участка.', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'StorageStructureSectorToID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции 0-insert, 1-update, 2-delete', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsHistory', 'COLUMN', N'OperationType'
GO