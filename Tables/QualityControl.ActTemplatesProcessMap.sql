CREATE TABLE [QualityControl].[ActTemplatesProcessMap] (
  [ID] [int] IDENTITY,
  [StatusID] [tinyint] NOT NULL,
  [GoStatusID] [tinyint] NOT NULL,
  [NotifyEventID] [int] NULL,
  [NotifyAuthor] [bit] NOT NULL,
  [CreateTasks] [bit] NOT NULL,
  CONSTRAINT [PK_ActTemplatesProcessMap_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.ActTemplatesProcessMap.NotifyAuthor'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.ActTemplatesProcessMap.CreateTasks'
GO

ALTER TABLE [QualityControl].[ActTemplatesProcessMap]
  ADD CONSTRAINT [FK_ActTemplatesProcessMap_ActStatuses_ID1] FOREIGN KEY ([StatusID]) REFERENCES [QualityControl].[ActStatuses] ([ID])
GO

ALTER TABLE [QualityControl].[ActTemplatesProcessMap]
  ADD CONSTRAINT [FK_ActTemplatesProcessMap_ActStatuses_ID2] FOREIGN KEY ([GoStatusID]) REFERENCES [QualityControl].[ActStatuses] ([ID])
GO

ALTER TABLE [QualityControl].[ActTemplatesProcessMap]
  ADD CONSTRAINT [FK_ActTemplatesProcessMap_NotifyEvents_ID] FOREIGN KEY ([NotifyEventID]) REFERENCES [dbo].[NotifyEvents] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesProcessMap', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса из которого переходит протокол', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesProcessMap', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса в который переходит протокол', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesProcessMap', 'COLUMN', N'GoStatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сообщения при переходе', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesProcessMap', 'COLUMN', N'NotifyEventID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уведомить автора', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesProcessMap', 'COLUMN', N'NotifyAuthor'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Создавать задачи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesProcessMap', 'COLUMN', N'CreateTasks'
GO