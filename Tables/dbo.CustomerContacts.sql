CREATE TABLE [dbo].[CustomerContacts] (
  [ID] [int] IDENTITY,
  [CustomerID] [int] NOT NULL,
  [Name] [varchar](300) NOT NULL,
  [Position] [varchar](100) NULL,
  [CellPhone] [varchar](50) NULL,
  [CellPhone2] [varchar](50) NULL,
  [WorkPhone] [varchar](50) NULL,
  [HomePhone] [varchar](50) NULL,
  [Fax] [varchar](50) NULL,
  [Email] [varchar](255) NULL,
  [InternalPhone] [varchar](5) NULL,
  [Skype] [varchar](100) NULL,
  [Comments] [varchar](max) NULL,
  [Category] [tinyint] NULL,
  [CodeCRM] [varchar](36) NULL,
  [Department] [varchar](255) NULL,
  [Deleted] [bit] NULL,
  [SyncCRM] [tinyint] NULL,
  [ModifyEmployeeID] [int] NULL,
  [ModifyDate] [datetime] NULL,
  [Code1C] [varchar](36) NULL,
  CONSTRAINT [PK_Contacts] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomerContacts]
  ADD CONSTRAINT [FK_Contacts_Customers] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[CustomerContacts]
  ADD CONSTRAINT [FK_CustomerContacts_Employees_ID] FOREIGN KEY ([ModifyEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Контактные лица', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор контрагента', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ФИО контакта', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Должность', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'Position'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Мобильный телефон', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'CellPhone'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Мобильный телефон 2', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'CellPhone2'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Рабочий телефон', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'WorkPhone'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Домашний телефон', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'HomePhone'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Факс', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'Fax'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Электронная почта', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'Email'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Внутренний телефон (для предприятий)', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'InternalPhone'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', 'Skype', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'Skype'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'Comments'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Категория должности (для документов): 1 - Директор, 2 - Бухгалтер', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'Category'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код контакта (в системе SugarCRM)', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'CodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Департамент', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'Department'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг удален ли контакт', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'Deleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние синхронизации с CRM 0 не синхронизирован. 1 - синхронизирован', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'SyncCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя изменившего запись в Спеклер', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата последних изменений в Спеклер', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с', 'SCHEMA', N'dbo', 'TABLE', N'CustomerContacts', 'COLUMN', N'Code1C'
GO