CREATE TABLE [sync].[1CCustomersContactsLog] (
  [ID] [int] IDENTITY,
  [CustomerCode1C] [varchar](36) NULL,
  [Code1C] [varchar](36) NULL,
  [FullName] [varchar](255) NULL,
  [Position] [varchar](500) NULL,
  [IsDeleted] [bit] NULL,
  [ErrorText] [varchar](2000) NULL,
  [ModifyDate] [datetime] NULL,
  [CustomerID] [int] NULL,
  CONSTRAINT [PK_1CCustomersContactsLog_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContactsLog', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с контрагента', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContactsLog', 'COLUMN', N'CustomerCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContactsLog', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ФИО', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContactsLog', 'COLUMN', N'FullName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Должность', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContactsLog', 'COLUMN', N'Position'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флг удаленности', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContactsLog', 'COLUMN', N'IsDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тккст ошибки', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContactsLog', 'COLUMN', N'ErrorText'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата модификации', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContactsLog', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Найденный контрагент', 'SCHEMA', N'sync', 'TABLE', N'1CCustomersContactsLog', 'COLUMN', N'CustomerID'
GO