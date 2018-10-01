CREATE TABLE [sync].[1CCustomersLog] (
  [ID] [int] IDENTITY,
  [ModifyDate] [datetime] NOT NULL,
  [Code1C] [varchar](36) NOT NULL,
  [FullName] [varchar](600) NULL,
  [EDRPOU] [varchar](30) NULL,
  [TIN] [varchar](30) NULL,
  [isDeleted] [bit] NULL,
  [isClient] [bit] NULL,
  [isSupplier] [bit] NULL,
  [isFolder] [bit] NULL,
  [ParentCode1C] [varchar](36) NULL,
  [ErrorText] [varchar](8000) NULL,
  [CustomerID] [int] NULL,
  CONSTRAINT [PK_1CCustomersLog_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersLog', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата изменений', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersLog', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Гуид 1с', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersLog', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersLog', 'COLUMN', N'FullName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ЕДРПОУ', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersLog', 'COLUMN', N'EDRPOU'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ИНН', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersLog', 'COLUMN', N'TIN'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг Удален', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersLog', 'COLUMN', N'isDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг клиент', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersLog', 'COLUMN', N'isClient'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг поставщика', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersLog', 'COLUMN', N'isSupplier'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг папки', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersLog', 'COLUMN', N'isFolder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'код папки 1с', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersLog', 'COLUMN', N'ParentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'текст ошибки', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersLog', 'COLUMN', N'ErrorText'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор найденной записи при поиске - null при инсерте', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersLog', 'COLUMN', N'CustomerID'
GO