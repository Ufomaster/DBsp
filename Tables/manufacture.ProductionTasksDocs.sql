CREATE TABLE [manufacture].[ProductionTasksDocs] (
  [ID] [int] IDENTITY,
  [ProductionTasksID] [int] NULL,
  [EmployeeFromID] [int] NULL,
  [EmployeeToID] [int] NULL,
  [LinkedProductionTasksDocsID] [int] NULL,
  [ProductionTasksOperTypeID] [tinyint] NULL,
  [ConfirmStatus] [tinyint] NULL,
  [CreateDate] [datetime] NOT NULL,
  [StorageStructureSectorID] [tinyint] NULL,
  [StorageStructureSectorToID] [tinyint] NULL,
  [JobStageID] [int] NULL,
  [CreateType] [tinyint] NULL,
  CONSTRAINT [PK_ProductionTasksDocs_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionTasksDocs_ConfirmStatus]
  ON [manufacture].[ProductionTasksDocs] ([ConfirmStatus])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionTasksDocs_ProductionTasksID]
  ON [manufacture].[ProductionTasksDocs] ([ProductionTasksID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionTasksDocs_ProductionTasksOperTypeID]
  ON [manufacture].[ProductionTasksDocs] ([ProductionTasksOperTypeID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionTasksDocs_StorageStructureSectorID]
  ON [manufacture].[ProductionTasksDocs] ([StorageStructureSectorID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionTasksDocs_StorageStructureSectorToID]
  ON [manufacture].[ProductionTasksDocs] ([StorageStructureSectorToID])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UQ_ProductionTasksDocs_LinkedProductionTasksDocsID]
  ON [manufacture].[ProductionTasksDocs] ([LinkedProductionTasksDocsID])
  WHERE ([LinkedProductionTasksDocsID] IS NOT NULL)
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'manufacture.ProductionTasksDocs.CreateDate'
GO

ALTER TABLE [manufacture].[ProductionTasksDocs] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasksDocs_Employees_ID] FOREIGN KEY ([EmployeeFromID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasksDocs] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasksDocs_Employees_ID2] FOREIGN KEY ([EmployeeToID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasksDocs] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasksDocs_JobStages_ID] FOREIGN KEY ([JobStageID]) REFERENCES [manufacture].[JobStages] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasksDocs] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasksDocs_ProductionTasks (manufacture)_ID1] FOREIGN KEY ([ProductionTasksID]) REFERENCES [manufacture].[ProductionTasks] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasksDocs] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasksDocs_ProductionTasksDocs (manufacture)_ID] FOREIGN KEY ([LinkedProductionTasksDocsID]) REFERENCES [manufacture].[ProductionTasksDocs] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasksDocs] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasksDocs_ProductionTasksOperationTypes (manufacture)_ID] FOREIGN KEY ([ProductionTasksOperTypeID]) REFERENCES [manufacture].[ProductionTasksOperationTypes] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasksDocs] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasksDocs_StorageStructureSectors (manufacture)_ID] FOREIGN KEY ([StorageStructureSectorID]) REFERENCES [manufacture].[StorageStructureSectors] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasksDocs] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasksDocs_StorageStructureSectors (manufacture)_ID1] FOREIGN KEY ([StorageStructureSectorToID]) REFERENCES [manufacture].[StorageStructureSectors] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocs', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сменного задания', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocs', 'COLUMN', N'ProductionTasksID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника от которого идет перемещение', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocs', 'COLUMN', N'EmployeeFromID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника к которому идет перемещение', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocs', 'COLUMN', N'EmployeeToID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор связанного документа сменного задания при передаче с участка на участок', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocs', 'COLUMN', N'LinkedProductionTasksDocsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор операции документа', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocs', 'COLUMN', N'ProductionTasksOperTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус подтверждения - 0 - ожидает подтверждения, 1 - подтверждено, 2 - не подтверждено', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocs', 'COLUMN', N'ConfirmStatus'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocs', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор текущего участка.', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocs', 'COLUMN', N'StorageStructureSectorID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор целевого участка.', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocs', 'COLUMN', N'StorageStructureSectorToID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор этапа работы', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocs', 'COLUMN', N'JobStageID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', 'Null - From Interface Call
0 - From sp....MoveEx Call', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocs', 'COLUMN', N'CreateType'
GO