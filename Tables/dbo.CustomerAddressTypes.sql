CREATE TABLE [dbo].[CustomerAddressTypes] (
  [ID] [int] IDENTITY,
  [Name] [varchar](30) NOT NULL,
  CONSTRAINT [PK_AddressTypes] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Типы адресов клиентов', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddressTypes'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddressTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'CustomerAddressTypes', 'COLUMN', N'Name'
GO