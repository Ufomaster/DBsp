CREATE TABLE [manufacture].[PTmcImportTemplates] (
  [ID] [int] IDENTITY,
  [ModifyDate] [datetime] NULL,
  [EmployeeID] [int] NULL,
  [Time] [int] NULL,
  [Count] [int] NULL,
  [JobStageID] [int] NULL,
  [isDeleted] [bit] NULL DEFAULT (0),
  CONSTRAINT [PK_PTmcImportTemplates_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [manufacture].[PTmcImportTemplates]
  ADD CONSTRAINT [FK_PTmcImportTemplates_JobStages (manufacture)_ID] FOREIGN KEY ([JobStageID]) REFERENCES [manufacture].[JobStages] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportTemplates', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата импорта', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportTemplates', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пользователь, который провел импорт', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportTemplates', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Время в милисекундах', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportTemplates', 'COLUMN', N'Time'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Количество импортированных строк', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportTemplates', 'COLUMN', N'Count'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на этап', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportTemplates', 'COLUMN', N'JobStageID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пометка на удаление', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportTemplates', 'COLUMN', N'isDeleted'
GO