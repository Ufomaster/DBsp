CREATE TABLE [manufacture].[PTmcOperations] (
  [ID] [int] IDENTITY,
  [ModifyDate] [datetime] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  [Time] [int] NULL,
  [Count] [int] NULL,
  [OperationTypeID] [tinyint] NOT NULL,
  [ImportTemplateID] [int] NULL,
  [JobStageID] [int] NULL,
  [isCanceled] [bit] NULL,
  CONSTRAINT [PK_PTmcOperations_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_PTmcOperations_JobStageID]
  ON [manufacture].[PTmcOperations] ([JobStageID])
  INCLUDE ([ID], [isCanceled])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.PTmcOperations.isCanceled'
GO

ALTER TABLE [manufacture].[PTmcOperations]
  ADD CONSTRAINT [FK_PTmcOperations_JobStages (manufacture)_ID] FOREIGN KEY ([JobStageID]) REFERENCES [manufacture].[JobStages] ([ID])
GO

ALTER TABLE [manufacture].[PTmcOperations]
  ADD CONSTRAINT [FK_PTmcOperations_PTmcImportTemplates (manufacture)_ID] FOREIGN KEY ([ImportTemplateID]) REFERENCES [manufacture].[PTmcImportTemplates] ([ID])
GO

ALTER TABLE [manufacture].[PTmcOperations]
  ADD CONSTRAINT [FK_PTmcOperations_PTmcOperationTypes (manufacture)_ID] FOREIGN KEY ([OperationTypeID]) REFERENCES [manufacture].[PTmcOperationTypes] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperations', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата импорта', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperations', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пользователь, который провел импорт', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperations', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Время в милисекундах', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperations', 'COLUMN', N'Time'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Количество импортированных строк', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperations', 'COLUMN', N'Count'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperations', 'COLUMN', N'OperationTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на шаблон для импорта', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperations', 'COLUMN', N'ImportTemplateID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на этап работы', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperations', 'COLUMN', N'JobStageID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг, отмечающий отмену данной операции', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperations', 'COLUMN', N'isCanceled'
GO