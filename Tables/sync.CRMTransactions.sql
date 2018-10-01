CREATE TABLE [sync].[CRMTransactions] (
  [ID] [nvarchar](36) NOT NULL,
  [Status] [nvarchar](50) NOT NULL,
  [OperationType] [nvarchar](50) NOT NULL,
  [EntityType] [nvarchar](50) NOT NULL,
  [PrimaryEntityCodeCRM] [nvarchar](36) NOT NULL,
  [SecondaryEntityCodeCRM] [nvarchar](36) NULL,
  [SortOrder] [bigint] NOT NULL,
  [RequestId] [nvarchar](36) NULL,
  [Data] [ntext] NULL,
  [ErrorMsg] [varchar](max) NULL,
  [ModifyDate] [datetime] NULL,
  CONSTRAINT [PK_CRMTransactions_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Таблица Sync.CRMTransactions содержит заголовки синхронизационных пакетов. Данные, содержащиеся в этой таблице, определяют тип синхронизационного пакета и состояние процесса синхронизации. ', 'SCHEMA', N'sync', 'TABLE', N'CRMTransactions'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Первичный ключ', 'SCHEMA', N'sync', 'TABLE', N'CRMTransactions', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус операции синхронизации. Может принимать одно из значений:
•	new
•	in process
•	error
•	processed', 'SCHEMA', N'sync', 'TABLE', N'CRMTransactions', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции. Может принимать одно из значений:
•	insert
•	update
•	delete
•	merge', 'SCHEMA', N'sync', 'TABLE', N'CRMTransactions', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип синхронизируемой сущности. Может принимать одно из значений:
•	account', 'SCHEMA', N'sync', 'TABLE', N'CRMTransactions', 'COLUMN', N'EntityType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код главной сущности в синхронизационном пакете', 'SCHEMA', N'sync', 'TABLE', N'CRMTransactions', 'COLUMN', N'PrimaryEntityCodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код дополнительной сущности, необходимой для некоторых операций (например, merge)', 'SCHEMA', N'sync', 'TABLE', N'CRMTransactions', 'COLUMN', N'SecondaryEntityCodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядковый номер транзакции', 'SCHEMA', N'sync', 'TABLE', N'CRMTransactions', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Зарезервировано для дальнейшего использования', 'SCHEMA', N'sync', 'TABLE', N'CRMTransactions', 'COLUMN', N'RequestId'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'XML документ, содержащий данные синхронизационного пакета', 'SCHEMA', N'sync', 'TABLE', N'CRMTransactions', 'COLUMN', N'Data'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Строка ошибки', 'SCHEMA', N'sync', 'TABLE', N'CRMTransactions', 'COLUMN', N'ErrorMsg'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата модификации', 'SCHEMA', N'sync', 'TABLE', N'CRMTransactions', 'COLUMN', N'ModifyDate'
GO