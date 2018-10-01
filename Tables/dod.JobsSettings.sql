CREATE TABLE [dod].[JobsSettings] (
  [ID] [int] IDENTITY,
  [Name] [varchar](256) NULL,
  [CreateDate] [datetime] NULL,
  [ModifyEmployeeID] [int] NULL,
  [PCCID] [int] NULL,
  [Status] [tinyint] NULL,
  [CardType] [smallint] NULL,
  [optSWL1] [bit] NULL,
  [optWriteL1] [bit] NULL,
  [optVerify] [bit] NULL,
  [optCreateDB] [bit] NULL,
  [optSWL3] [bit] NULL,
  [optWriteMagnetic] [bit] NULL,
  [optStopOnUIDNotFound] [bit] NULL,
  [DefaultMasterKey] [varchar](32) NULL,
  [DefaultConfigKey] [varchar](32) NULL,
  [DefaultLevelSwitchKey] [varchar](32) NULL,
  CONSTRAINT [PK_JobSettings_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dod].[JobsSettings]
  ADD CONSTRAINT [FK_JobsSettings_Employees_ID] FOREIGN KEY ([ModifyEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dod].[JobsSettings]
  ADD CONSTRAINT [FK_JobsSettings_ProductionCardCustomize_ID] FOREIGN KEY ([PCCID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование работы', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'PCCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус-0 черновик, 1- в работе, 2 завершен', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип карт. 0- Mifare Ultralight, 1-Mifare Plus SE', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'CardType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Переключение в левел 1', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'optSWL1'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Запись карты - персонализация', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'optWriteL1'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Верификация данных после записи', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'optVerify'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Считывание данных по карте для формирования БД', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'optCreateDB'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Переключение в левел 3', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'optSWL3'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Писать магнитную полосу на карту', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'optWriteMagnetic'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Останавливать работу машины если не найдена карта в БД.', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'optStopOnUIDNotFound'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Master ключ по умолчанию', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'DefaultMasterKey'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ConfigKey по умлочанию', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'DefaultConfigKey'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'LevelSwitch ключ по умолчанию', 'SCHEMA', N'dod', 'TABLE', N'JobsSettings', 'COLUMN', N'DefaultLevelSwitchKey'
GO