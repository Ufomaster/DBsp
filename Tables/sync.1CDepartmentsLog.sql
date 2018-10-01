CREATE TABLE [sync].[1CDepartmentsLog] (
  [ID] [int] NOT NULL,
  [Date] [datetime] NOT NULL,
  [VisibleCode] [varchar](30) NULL,
  [Code1C] [varchar](36) NOT NULL,
  [ParentCode1C] [varchar](36) NULL,
  [Name] [varchar](100) NULL,
  [OperationType] [tinyint] NOT NULL,
  [Status] [tinyint] NULL,
  [StatusError] [varchar](1000) NULL,
  [ModifyName] [varchar](100) NULL,
  [ModifyDate] [datetime] NULL
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CDepartmentsLog', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата', 'SCHEMA', N'sync', 'TABLE', N'1CDepartmentsLog', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый пользователю код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CDepartmentsLog', 'COLUMN', N'VisibleCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уникальный идентификатор 1с', 'SCHEMA', N'sync', 'TABLE', N'1CDepartmentsLog', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор родительской группы, которой подчинена запись', 'SCHEMA', N'sync', 'TABLE', N'1CDepartmentsLog', 'COLUMN', N'ParentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Полное наименование', 'SCHEMA', N'sync', 'TABLE', N'1CDepartmentsLog', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции (0-Insert, 1-Update, 2-Delete)', 'SCHEMA', N'sync', 'TABLE', N'1CDepartmentsLog', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние 0-успешно 1-ошибка', 'SCHEMA', N'sync', 'TABLE', N'1CDepartmentsLog', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Если состояние ошибка - то текст ошибки', 'SCHEMA', N'sync', 'TABLE', N'1CDepartmentsLog', 'COLUMN', N'StatusError'
GO