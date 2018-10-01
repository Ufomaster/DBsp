CREATE TABLE [sync].[CRMCustomerTypes] (
  [ID] [bigint] IDENTITY,
  [CRMTransactionID] [nvarchar](36) NOT NULL,
  [CodeCRM] [nvarchar](36) NOT NULL,
  [CustomerCodeCRM] [nvarchar](36) NOT NULL,
  [Type] [nvarchar](50) NOT NULL,
  [IsPrimary] [bit] NOT NULL,
  CONSTRAINT [PK_CRMCustomerTypes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Содержит описание типов контрагентов, входящих в синхронизационные пакеты «Создание нового контрагента», «Обновление данных контрагента», «Удаление контрагента», «Слияние контрагентов»', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomerTypes'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Первичный ключ', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomerTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ID синхронизационного пакета (транзакции), к которому относится данная запись. Ссылается на запись таблицы Sync.CRMTransactions', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomerTypes', 'COLUMN', N'CRMTransactionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код типа контрагента (в системе SugarCRM)', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomerTypes', 'COLUMN', N'CodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код контрагента (в системе SugarCRM), к которому относится данный тип', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomerTypes', 'COLUMN', N'CustomerCodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип контрагента', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomerTypes', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1 – если тип является основным, 0 – в противном случае', 'SCHEMA', N'sync', 'TABLE', N'CRMCustomerTypes', 'COLUMN', N'IsPrimary'
GO