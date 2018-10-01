CREATE TABLE [dbo].[Agreements] (
  [ID] [int] IDENTITY,
  [CustomerID] [int] NOT NULL,
  [ContactID] [int] NULL,
  [IsPermanent] [bit] NULL,
  [Number] [varchar](15) NOT NULL,
  [Date] [datetime] NOT NULL,
  [ExpirationDate] [datetime] NULL,
  [TypeID] [int] NULL,
  [Comments] [varchar](255) NULL,
  [ModifyEmployeeID] [int] NULL,
  [ModifyDate] [datetime] NULL,
  [SyncCRM] [tinyint] NULL,
  CONSTRAINT [PK_Agreements_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Agreements]
  ADD CONSTRAINT [FK_Agreements_AgreementsTypes_ID] FOREIGN KEY ([TypeID]) REFERENCES [dbo].[AgreementsTypes] ([ID])
GO

ALTER TABLE [dbo].[Agreements]
  ADD CONSTRAINT [FK_Agreements_CustomerContacts_ID] FOREIGN KEY ([ContactID]) REFERENCES [dbo].[CustomerContacts] ([ID])
GO

ALTER TABLE [dbo].[Agreements]
  ADD CONSTRAINT [FK_Agreements_Customers_ID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Agreements]
  ADD CONSTRAINT [FK_Agreements_Employees_ID] FOREIGN KEY ([ModifyEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Договора с клиентами', 'SCHEMA', N'dbo', 'TABLE', N'Agreements'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Agreements', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор клиента', 'SCHEMA', N'dbo', 'TABLE', N'Agreements', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор контакта (руководителя)', 'SCHEMA', N'dbo', 'TABLE', N'Agreements', 'COLUMN', N'ContactID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'0 - разовый, 1 - постоянный', 'SCHEMA', N'dbo', 'TABLE', N'Agreements', 'COLUMN', N'IsPermanent'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер', 'SCHEMA', N'dbo', 'TABLE', N'Agreements', 'COLUMN', N'Number'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата', 'SCHEMA', N'dbo', 'TABLE', N'Agreements', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата истечения срока действия', 'SCHEMA', N'dbo', 'TABLE', N'Agreements', 'COLUMN', N'ExpirationDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа договора', 'SCHEMA', N'dbo', 'TABLE', N'Agreements', 'COLUMN', N'TypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'dbo', 'TABLE', N'Agreements', 'COLUMN', N'Comments'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сотрудник, модифицировавший запись', 'SCHEMA', N'dbo', 'TABLE', N'Agreements', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата последних изменений', 'SCHEMA', N'dbo', 'TABLE', N'Agreements', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние синхронизации с CRM 0 не синхронизирован. 1 - синхронизирован', 'SCHEMA', N'dbo', 'TABLE', N'Agreements', 'COLUMN', N'SyncCRM'
GO