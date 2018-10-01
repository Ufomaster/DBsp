CREATE TABLE [dod].[ImportLog] (
  [ID] [int] IDENTITY,
  [StartDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [Log] [varchar](8000) NULL,
  [JobsSettingsID] [int] NULL,
  CONSTRAINT [PK_ImportLog_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dod', 'TABLE', N'ImportLog', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата начала загрузки', 'SCHEMA', N'dod', 'TABLE', N'ImportLog', 'COLUMN', N'StartDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата окончания загрузки', 'SCHEMA', N'dod', 'TABLE', N'ImportLog', 'COLUMN', N'EndDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Лог', 'SCHEMA', N'dod', 'TABLE', N'ImportLog', 'COLUMN', N'Log'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор работы', 'SCHEMA', N'dod', 'TABLE', N'ImportLog', 'COLUMN', N'JobsSettingsID'
GO