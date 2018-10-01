CREATE TABLE [sync].[1CNomenclatureLog] (
  [ModifyDate] [datetime] NOT NULL,
  [ID] [int] NULL,
  [UserCode1C] [varchar](30) NULL,
  [Code1C] [varchar](36) NULL,
  [ParentCode1C] [varchar](36) NULL,
  [Name] [varchar](255) NULL,
  [ShortName] [varchar](255) NULL,
  [Type] [int] NULL,
  [OperationType] [int] NULL,
  [UnitName] [varchar](20) NULL,
  [UnitCode1C] [varchar](36) NULL,
  [Status] [tinyint] NULL,
  [StatusError] [varchar](255) NULL,
  [ProdCardNumber] [varchar](10) NULL
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи, которая была обработана', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый пользователю код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'UserCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уникальный идентификатор 1с', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор родительской группы, которой подчинена запись', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'ParentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Полное наименование', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Краткое наименование', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'ShortName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип записи (0-группа, 1-номенклатура)', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции (0-Insert, 1-Update, 2-Delete)', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'наименование единицы измерения', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'UnitName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уникальный идентификатор 1с единицы измерения', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'UnitCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние 0-успешно 1-ошибка', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Елси состояние ошибка - то текст ошибки', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'StatusError'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'№ заказного листа', 'SCHEMA', N'sync', 'TABLE', N'1CNomenclatureLog', 'COLUMN', N'ProdCardNumber'
GO