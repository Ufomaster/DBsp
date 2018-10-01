CREATE TABLE [sync].[CRMCustomers] (
  [ID] [bigint] IDENTITY,
  [CRMTransactionID] [nvarchar](36) NOT NULL,
  [CodeCRM] [nvarchar](36) NOT NULL,
  [ShortName] [nvarchar](150) NULL,
  [Name] [nvarchar](128) NULL,
  [Phone] [nvarchar](50) NULL,
  [Fax] [nvarchar](50) NULL,
  [Website] [nvarchar](255) NULL,
  [CreateDate] [datetime] NOT NULL,
  [CreatedByCode] [nvarchar](36) NOT NULL,
  [CreatedBy] [nvarchar](90) NOT NULL,
  [EDRPOU] [nvarchar](32) NULL,
  [TIN] [nvarchar](32) NULL,
  CONSTRAINT [PK_CRMCustomers_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Первичный ключ', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomers', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ID синхронизационного пакета (транзакции), к которому относится данная запись. Ссылается на запись таблицы Sync.CRMTransactions ', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomers', 'COLUMN', N'CRMTransactionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код контрагента (в системе SugarCRM)', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomers', 'COLUMN', N'CodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сокращенное наименование контрагента', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomers', 'COLUMN', N'ShortName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Полное название контрагента', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomers', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Телефон', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomers', 'COLUMN', N'Phone'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Факс', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomers', 'COLUMN', N'Fax'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сайт', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomers', 'COLUMN', N'Website'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания записи о контрагенте', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomers', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код пользователя (в системе SugarCRM), создавшего запись', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomers', 'COLUMN', N'CreatedByCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ФИО пользователя, создавшего запись', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomers', 'COLUMN', N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код ЕГРПОУ', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomers', 'COLUMN', N'EDRPOU'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ИНН', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomers', 'COLUMN', N'TIN'
GO