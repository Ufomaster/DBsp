CREATE TABLE [sync].[CRMAddresses] (
  [ID] [bigint] IDENTITY,
  [CRMTransactionID] [nvarchar](36) NOT NULL,
  [CodeCRM] [nvarchar](36) NOT NULL,
  [CustomerCodeCRM] [nvarchar](36) NOT NULL,
  [Type] [nvarchar](100) NOT NULL,
  [IsPrimary] [bit] NULL,
  [ZipCode] [nvarchar](32) NULL,
  [СountryCodeCRM] [nvarchar](36) NULL,
  [Country] [nvarchar](255) NULL,
  [RegionCodeCRM] [nvarchar](36) NULL,
  [Region] [nvarchar](255) NULL,
  [CityCodeCRM] [nvarchar](36) NULL,
  [City] [nvarchar](255) NULL,
  [Address] [nvarchar](255) NULL,
  [Description] [nvarchar](max) NULL,
  [CreateDate] [datetime] NOT NULL,
  [CreatedByCode] [nvarchar](36) NOT NULL,
  [CreatedBy] [nvarchar](90) NOT NULL,
  CONSTRAINT [PK_CRMAddresses_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_CRMAddresses_CRMTransactionID_CustomerCodeCRM]
  ON [sync].[CRMAddresses] ([CRMTransactionID], [CustomerCodeCRM])
  ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Таблица Sync.CRMAddresses содержит описание адресов контрагентов, входящих в синхронизационные пакеты «Создание нового контрагента», «Обновление данных контрагента», «Удаление контрагента», «Слияние контрагентов». ', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Первичный ключ', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ID синхронизационного пакета (транзакции), к которому относится данная запись. Ссылается на запись таблицы Sync.CRMTransactions', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'CRMTransactionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код адреса контрагента (в системе SugarCRM)', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'CodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код контрагента (в системе SugarCRM), к которому относится адрес', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'CustomerCodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип адреса', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1 – если адрес является основным
0 – в противном случае', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'IsPrimary'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Индекс', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'ZipCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код страны (в системе SugarCRM)', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'СountryCodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Страна', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'Country'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код области (в системе SugarCRM)', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'RegionCodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Область', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'Region'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код города (в системе SugarCRM)', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'CityCodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Город', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'City'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Адрес (улица)', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'Address'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания записи об адресе', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код пользователя (в системе SugarCRM), создавшего запись', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'CreatedByCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ФИО пользователя, создавшего запись', 'SCHEMA', N'sync', 'TABLE', N'CRMAddresses', 'COLUMN', N'CreatedBy'
GO