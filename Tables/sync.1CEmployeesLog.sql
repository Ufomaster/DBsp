CREATE TABLE [sync].[1CEmployeesLog] (
  [ID] [int] NOT NULL,
  [Date] [datetime] NOT NULL,
  [VisibleCode] [varchar](30) NULL,
  [Code1C] [varchar](36) NOT NULL,
  [Name] [varchar](100) NULL,
  [OperationType] [tinyint] NOT NULL,
  [isActive] [bit] NULL,
  [ContractType] [varchar](50) NULL,
  [Status] [tinyint] NULL,
  [StatusError] [varchar](1000) NULL,
  [FCode1C] [varchar](36) NULL,
  [ModifyName] [varchar](100) NULL,
  [ModifyDate] [datetime] NULL,
  [Department1Code1C] [varchar](36) NULL,
  [Department1Name] [varchar](150) NULL,
  [Position1Code1C] [varchar](36) NULL,
  [Department2Code1C] [varchar](36) NULL,
  [Department2Name] [varchar](150) NULL,
  [Position2Code1C] [varchar](36) NULL,
  [RecDate2] [datetime] NULL,
  [DisDate2] [datetime] NULL,
  [Department3Code1C] [varchar](36) NULL,
  [Position3Code1C] [varchar](36) NULL,
  [RecDate3] [datetime] NULL,
  [DisDate3] [datetime] NULL,
  [WorkType] [varchar](51) NULL
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CEmployeesLog', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата', 'SCHEMA', N'sync', 'TABLE', N'1CEmployeesLog', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый пользователю код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CEmployeesLog', 'COLUMN', N'VisibleCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уникальный идентификатор 1с', 'SCHEMA', N'sync', 'TABLE', N'1CEmployeesLog', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Полное наименование', 'SCHEMA', N'sync', 'TABLE', N'1CEmployeesLog', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции (0-Insert, 1-Update, 2-Delete)', 'SCHEMA', N'sync', 'TABLE', N'1CEmployeesLog', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг активности', 'SCHEMA', N'sync', 'TABLE', N'1CEmployeesLog', 'COLUMN', N'isActive'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип контракта', 'SCHEMA', N'sync', 'TABLE', N'1CEmployeesLog', 'COLUMN', N'ContractType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние 0-успешно 1-ошибка', 'SCHEMA', N'sync', 'TABLE', N'1CEmployeesLog', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Если состояние ошибка - то текст ошибки', 'SCHEMA', N'sync', 'TABLE', N'1CEmployeesLog', 'COLUMN', N'StatusError'
GO