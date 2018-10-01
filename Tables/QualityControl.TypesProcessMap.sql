CREATE TABLE [QualityControl].[TypesProcessMap] (
  [ID] [int] IDENTITY,
  [StatusID] [tinyint] NOT NULL,
  [GoStatusID] [tinyint] NOT NULL,
  [NotifyEventID] [int] NULL,
  [AutoCreateAct] [bit] NOT NULL,
  [EnableResultCalc] [bit] NOT NULL,
  [SetAuthSignedDate] [bit] NOT NULL,
  [SetAuthSignedDateClear] [bit] NOT NULL,
  [SetQCSpecSignedDate] [bit] NOT NULL,
  [SetQCSpecSignedDateClear] [bit] NOT NULL,
  [NotifyAuthor] [bit] NOT NULL,
  [NotifySpecialist] [bit] NOT NULL,
  [NotifySigners] [bit] NOT NULL,
  [NotifyManager] [bit] NOT NULL,
  [CheckPropsForTest] [bit] NOT NULL,
  [CheckActPropsForTest] [bit] NOT NULL,
  CONSTRAINT [PK_ProtocolProcessMap_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesProcessMap.AutoCreateAct'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesProcessMap.EnableResultCalc'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesProcessMap.SetAuthSignedDate'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesProcessMap.SetAuthSignedDateClear'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesProcessMap.SetQCSpecSignedDate'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesProcessMap.SetQCSpecSignedDateClear'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesProcessMap.NotifyAuthor'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesProcessMap.NotifySpecialist'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesProcessMap.NotifySigners'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesProcessMap.NotifyManager'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesProcessMap.CheckPropsForTest'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesProcessMap.CheckActPropsForTest'
GO

ALTER TABLE [QualityControl].[TypesProcessMap]
  ADD CONSTRAINT [FK_TypesProcessMap_NotifyEvents_ID] FOREIGN KEY ([NotifyEventID]) REFERENCES [dbo].[NotifyEvents] ([ID])
GO

ALTER TABLE [QualityControl].[TypesProcessMap]
  ADD CONSTRAINT [FK_TypesProcessMap_TypesStatuses_ID1] FOREIGN KEY ([StatusID]) REFERENCES [QualityControl].[TypesStatuses] ([ID])
GO

ALTER TABLE [QualityControl].[TypesProcessMap]
  ADD CONSTRAINT [FK_TypesProcessMap_TypesStatuses_ID2] FOREIGN KEY ([GoStatusID]) REFERENCES [QualityControl].[TypesStatuses] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса из которого переходит протокол', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса в который переходит протокол', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'GoStatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сообщения при переходе', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'NotifyEventID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Автосоздание акта ', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'AutoCreateAct'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Разрешить расчет вывода по протоколу', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'EnableResultCalc'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уставновить дату подписи автором', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'SetAuthSignedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Снфть дату подписи автором', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'SetAuthSignedDateClear'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уставновить дату подписи специалистом ОКК', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'SetQCSpecSignedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Снять дату подписи специалистом ОКК', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'SetQCSpecSignedDateClear'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Оповестить автора', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'NotifyAuthor'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Оповестить специалиста', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'NotifySpecialist'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Оповетсить подписчиков', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'NotifySigners'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уведомлять менеджера ЗЛ если тип сырья давальческое', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'NotifyManager'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверять характеристии на наличиие "для тестирования", при наличии - запрещать переход', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'CheckPropsForTest'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Запрещать переход при отсутствии акта тестирования при наличии х-к для тестирования', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesProcessMap', 'COLUMN', N'CheckActPropsForTest'
GO