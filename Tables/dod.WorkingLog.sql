CREATE TABLE [dod].[WorkingLog] (
  [ID] [int] IDENTITY,
  [JobSettingsID] [int] NULL,
  [ModifyDate] [datetime] NULL,
  [UID] [varchar](100) NULL,
  [LogMessage] [varchar](8000) NULL,
  [Type] [tinyint] NULL,
  CONSTRAINT [PK_WorkingLog_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dod.WorkingLog.ModifyDate'
GO

ALTER TABLE [dod].[WorkingLog]
  ADD CONSTRAINT [FK_WorkingLog_JobsSettings_ID] FOREIGN KEY ([JobSettingsID]) REFERENCES [dod].[JobsSettings] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dod', 'TABLE', N'WorkingLog', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор работы', 'SCHEMA', N'dod', 'TABLE', N'WorkingLog', 'COLUMN', N'JobSettingsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата события, автоматическая', 'SCHEMA', N'dod', 'TABLE', N'WorkingLog', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор карты', 'SCHEMA', N'dod', 'TABLE', N'WorkingLog', 'COLUMN', N'UID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Текст', 'SCHEMA', N'dod', 'TABLE', N'WorkingLog', 'COLUMN', N'LogMessage'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип сообщения 0 - ОК, 1 - отладочное(детальное), 2-ошибка', 'SCHEMA', N'dod', 'TABLE', N'WorkingLog', 'COLUMN', N'Type'
GO