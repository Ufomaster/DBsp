CREATE TABLE [manufacture].[JobStagesHistory] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  [isActive] [bit] NULL,
  [ModemID] [tinyint] NULL,
  [JobID] [int] NULL,
  [OperatorsCount] [tinyint] NULL DEFAULT (0),
  [OutputTmcID] [int] NULL,
  [JobStageID] [int] NULL,
  [isDeleted] [bit] NULL,
  [ModifyEmployeeID] [int] NOT NULL,
  [ModifyDate] [datetime] NOT NULL,
  [OperationType] [tinyint] NULL,
  [MinQuantity] [int] NULL,
  [OutputNameFromCheckID] [int] NULL,
  [TekOp] [varchar](255) NULL,
  [Kind] [tinyint] NULL,
  [TechnologicalOperationID] [int] NULL,
  CONSTRAINT [PK_JobStageHistory_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'manufacture.JobStagesHistory.ModifyDate'
GO

ALTER TABLE [manufacture].[JobStagesHistory]
  ADD CONSTRAINT [FK_JobStagesHistory_Employees_ID] FOREIGN KEY ([ModifyEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [manufacture].[JobStagesHistory]
  ADD CONSTRAINT [FK_JobStagesHistory_Jobs (mds)_ID] FOREIGN KEY ([JobID]) REFERENCES [manufacture].[Jobs] ([ID])
GO

ALTER TABLE [manufacture].[JobStagesHistory]
  ADD CONSTRAINT [FK_JobStagesHistory_JobStageChecks (manufacture)_ID] FOREIGN KEY ([OutputNameFromCheckID]) REFERENCES [manufacture].[JobStageChecks] ([ID])
GO

ALTER TABLE [manufacture].[JobStagesHistory]
  ADD CONSTRAINT [FK_JobStagesHistory_JobStages (manufacture)_ID] FOREIGN KEY ([JobStageID]) REFERENCES [manufacture].[JobStages] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [manufacture].[JobStagesHistory]
  ADD CONSTRAINT [FK_JobStagesHistory_Modems (manufacture)_ID] FOREIGN KEY ([ModemID]) REFERENCES [manufacture].[Modems] ([ID])
GO

ALTER TABLE [manufacture].[JobStagesHistory]
  ADD CONSTRAINT [FK_JobStagesHistory_Tmc_ID] FOREIGN KEY ([OutputTmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Этапы работ', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование этапа', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Доступен ли этап для работы', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'isActive'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип модема', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'ModemID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на работу', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'JobID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Жестко задаем кол-во операторов, которое необходимо для выполнения работы, если 0 - ограничения нет', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'OperatorsCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ТМЦ, "рождающееся" в результате прохождения этапа', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'OutputTmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на этап', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'JobStageID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг, отображающий удалена ли запись', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'isDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пользователь, внесший правки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата правок', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции 0-вставка, 1-апдейт, 2-удаление', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Минимальный остаток. Используется дл сигнала, что оператору надо готовить материалы/изъять продукцию.', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'MinQuantity'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Указываем проверку из которой будем брать ТМЦ, идентификатор(штрих-код) которого будет присвоен "родившемуся"/исходящему ТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'OutputNameFromCheckID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'номер этапа', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'Kind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор технологической операции', 'SCHEMA', N'manufacture', 'TABLE', N'JobStagesHistory', 'COLUMN', N'TechnologicalOperationID'
GO