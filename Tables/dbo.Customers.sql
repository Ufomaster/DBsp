CREATE TABLE [dbo].[Customers] (
  [ID] [int] IDENTITY,
  [Code1C] [varchar](36) NULL,
  [CodeCRM] [varchar](36) NULL,
  [SyncCRM] [tinyint] NULL,
  [ShortName] [varchar](255) NULL,
  [Name] [varchar](1000) NOT NULL,
  [TaxCode] [varchar](32) NULL,
  [EDRPOU] [varchar](32) NULL,
  [CreateDate] [datetime] NULL,
  [Phone] [varchar](50) NULL,
  [Fax] [varchar](50) NULL,
  [Website] [varchar](255) NULL,
  [CreatedByCode] [varchar](36) NULL,
  [CreatedBy] [varchar](90) NULL,
  [Deleted] [bit] NULL,
  [isClient] [bit] NULL,
  [isSupplier] [bit] NULL,
  [ModifyEmployeeID] [int] NULL,
  [ModifyDate] [datetime] NULL,
  [isTransporter] [bit] NULL,
  [ParentID] [int] NULL,
  [isFolder] [bit] NULL,
  [ATTIsDeleted] [bit] NULL,
  [ATTuqIsIgnored] [bit] NULL,
  CONSTRAINT [PK_Customers_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Customers]
  ADD CONSTRAINT [FK_Customers_Customers_ID] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[Customers] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1С', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код CRM', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'CodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние синхронизации с CRM 0 не синхронизирован. 1 - синхронизирован', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'SyncCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Короткое наименование', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'ShortName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование контрагента', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Налоговый номер (ИНН)', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'TaxCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код ЕГРПОУ', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'EDRPOU'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Телефон', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'Phone'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Факс', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'Fax'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сайт', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'Website'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код пользователя (в системе SugarCRM), создавшего запись', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'CreatedByCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ФИО пользователя (в системе SugarCRM), создавшего запись', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'CreatedBy'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Признак удаления контрагента', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'Deleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг клиент/не клиент', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'isClient'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг поставщик/не поставщик', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'isSupplier'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя изменившего запись в Спеклер', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата последних изменений в Спеклер', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг перевозчик или нет', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'isTransporter'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Родительская папка', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'ParentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг папки', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'isFolder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Устарело, данные не используются. Атрибут папки. Все вложенные контрагенты считаются удаленными - ', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'ATTIsDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Атрибут папки. Уникальность игнорируется. если 1 - Все вложенные контрагенты будут игнорировать проверку ИНН ЕДРПОУ', 'SCHEMA', N'dbo', 'TABLE', N'Customers', 'COLUMN', N'ATTuqIsIgnored'
GO