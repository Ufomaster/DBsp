CREATE TABLE [manufacture].[JobStages] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  [isActive] [bit] NULL,
  [ModemID] [tinyint] NULL,
  [JobID] [int] NULL,
  [OperatorsCount] [tinyint] NULL DEFAULT (0),
  [OutputTmcID] [int] NULL,
  [OutputNameFromCheckID] [int] NULL,
  [isDeleted] [bit] NULL DEFAULT (0),
  [MinQuantity] [int] NULL DEFAULT (0),
  [EmptyStage] [bit] NULL,
  [TekOp] [varchar](255) NULL,
  [Kind] [tinyint] NULL DEFAULT (1),
  [TechnologicalOperationID] [int] NULL,
  [ModifyDate] [datetime] NULL,
  CONSTRAINT [PK_JobStages_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.JobStages.EmptyStage'
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'manufacture.JobStages.ModifyDate'
GO

ALTER TABLE [manufacture].[JobStages]
  ADD CONSTRAINT [FK_JobStages_Jobs (mds)_ID] FOREIGN KEY ([JobID]) REFERENCES [manufacture].[Jobs] ([ID])
GO

ALTER TABLE [manufacture].[JobStages]
  ADD CONSTRAINT [FK_JobStages_JobStageChecks (manufacture)_ID] FOREIGN KEY ([OutputNameFromCheckID]) REFERENCES [manufacture].[JobStageChecks] ([ID])
GO

ALTER TABLE [manufacture].[JobStages]
  ADD CONSTRAINT [FK_JobStages_Modems (manufacture)_ID] FOREIGN KEY ([ModemID]) REFERENCES [manufacture].[Modems] ([ID])
GO

ALTER TABLE [manufacture].[JobStages]
  ADD CONSTRAINT [FK_JobStages_TechnologicalOperations_ID] FOREIGN KEY ([TechnologicalOperationID]) REFERENCES [manufacture].[TechnologicalOperations] ([ID])
GO

ALTER TABLE [manufacture].[JobStages]
  ADD CONSTRAINT [FK_JobStages_Tmc_ID] FOREIGN KEY ([OutputTmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Этапы работ', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование этапа', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг активности работы', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'isActive'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип модема', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'ModemID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор работы', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'JobID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во операторов, необходимое для выполнения работы, 0 - ограничения нет', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'OperatorsCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ, "рождающееся" в результате прохождения этапа', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'OutputTmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор проверки из которой будет взят ТМЦ, идентификатор(штрих-код) которого будет присвоен "родившемуся"/исходящему ТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'OutputNameFromCheckID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг удаления записи', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'isDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Минимальный остаток. Используется дл сигнала, что оператору надо готовить материалы/изъять продукцию.', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'MinQuantity'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пометка пустого этапа. Используется для подписания инструкции в работах без идентификаторов для сканирования', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'EmptyStage'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Технологическая операция. Устарело. Используется для обратной совместимости с отчетом кликвью', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'TekOp'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер этапа обработки. Устаревает, есть в справчонике ТО', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'Kind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТО', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'TechnologicalOperationID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата редактирования', 'SCHEMA', N'manufacture', 'TABLE', N'JobStages', 'COLUMN', N'ModifyDate'
GO