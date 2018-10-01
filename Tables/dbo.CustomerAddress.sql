CREATE TABLE [dbo].[CustomerAddress] (
  [ID] [int] IDENTITY,
  [CustomerID] [int] NOT NULL,
  [AddressTypeID] [int] NOT NULL,
  [ZipCode] [varchar](10) NULL,
  [Country] [varchar](255) NULL,
  [Region] [varchar](255) NULL,
  [City] [varchar](255) NULL,
  [Address] [varchar](255) NULL,
  [Description] [varchar](max) NULL,
  [CreateDate] [datetime] NULL,
  [ModifyEmployeeID] [int] NULL,
  [ModifyDate] [datetime] NULL,
  [CodeCRM] [varchar](36) NULL,
  [Deleted] [bit] NULL,
  [SyncCRM] [tinyint] NULL,
  CONSTRAINT [PK_CustomerAdresses] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomerAddress]
  ADD CONSTRAINT [FK_CustomerAddress_CustomerAddressTypes_ID] FOREIGN KEY ([AddressTypeID]) REFERENCES [dbo].[CustomerAddressTypes] ([ID])
GO

ALTER TABLE [dbo].[CustomerAddress]
  ADD CONSTRAINT [FK_CustomerAddress_Customers_ID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[CustomerAddress]
  ADD CONSTRAINT [FK_CustomerAddress_Employees_ID] FOREIGN KEY ([ModifyEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Адреса клиентов (формализованные)', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор клиента', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа адреса', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'AddressTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Индекс', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'ZipCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Страна', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'Country'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Область', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'Region'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Населенный пункт', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'City'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Адрес', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'Address'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания CRM', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя изменившего запись в Спеклер', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата изменений Спеклер', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код системы CRM', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'CodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг удалена ли запись', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'Deleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние синхронизации с CRM 0 не синхронизирован. 1 - синхронизирован', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddress', 'COLUMN', N'SyncCRM'
GO