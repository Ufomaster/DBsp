CREATE TABLE [sync].[CRMContacts] (
  [ID] [bigint] IDENTITY,
  [CRMTransactionID] [nvarchar](36) NOT NULL,
  [CodeCRM] [nvarchar](36) NOT NULL,
  [CustomerCodeCRM] [nvarchar](36) NOT NULL,
  [LastName] [nvarchar](100) NULL,
  [FirstName] [nvarchar](100) NULL,
  [MiddleName] [nvarchar](100) NULL,
  [Department] [nvarchar](255) NULL,
  [Position] [nvarchar](100) NULL,
  [Mobile] [nvarchar](50) NULL,
  [WorkPhone] [nvarchar](50) NULL,
  [Phone] [nvarchar](50) NULL,
  [Fax] [nvarchar](50) NULL,
  [Email] [nvarchar](255) NULL,
  CONSTRAINT [PK_CRMContacts_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_CRMContacts_CRMTransactionID_CustomerCodeCRM]
  ON [sync].[CRMContacts] ([CRMTransactionID], [CustomerCodeCRM])
  ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Содержит описание контактов, принадлежащих контрагентам, которые входят в синхронизационные пакеты «Создание нового контрагента», «Обновление данных контрагента», «Удаление контрагента», «Слияние контрагентов». ', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Первичный ключ', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ID синхронизационного пакета (транзакции), к которому относится данная запись. Ссылается на запись таблицы Sync.CRMTransactions', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'CRMTransactionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код контакта (в системе SugarCRM)', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'CodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код контрагента (в системе SugarCRM), к которому относится контакт', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'CustomerCodeCRM'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Фамилия', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'LastName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'FirstName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Отчество', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'MiddleName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название отдела в указанном контрагенте', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'Department'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Должность контакта', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'Position'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Телефон мобильный', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'Mobile'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Телефон рабочий', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'WorkPhone'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Телефон другой', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'Phone'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Факс', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'Fax'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Основной email контакта', 'SCHEMA', N'sync', 'TABLE', N'CRMContacts', 'COLUMN', N'Email'
GO