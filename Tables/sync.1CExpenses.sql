CREATE TABLE [sync].[1CExpenses] (
  [ID] [int] IDENTITY,
  [DocDate] [datetime] NOT NULL,
  [DocNumber] [varchar](11) NULL,
  [Code1c] [varchar](36) NULL,
  [DepartmentCode1C] [varchar](36) NULL,
  [StorageCode1C] [varchar](36) NULL,
  [ModifyName1C] [varchar](100) NULL,
  [ModifyDate1C] [datetime] NULL,
  [Status] [tinyint] NULL,
  [ManufactureID] [smallint] NULL,
  [Date] [datetime] NULL,
  [ErrorMessage] [varchar](max) NULL,
  [EmployeeFysCode1C] [varchar](36) NULL,
  CONSTRAINT [PK__1CExpens__3214EC2700059B38] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.[1CExpenses].DocDate'
GO

ALTER TABLE [sync].[1CExpenses]
  ADD CONSTRAINT [FK_1CExpenses_ManufactureStructure (manufacture)_ID] FOREIGN KEY ([ManufactureID]) REFERENCES [manufacture].[ManufactureStructure] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CExpenses', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата документа', 'SCHEMA', N'sync', 'TABLE', N'1CExpenses', 'COLUMN', N'DocDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Присваивается в 1с', 'SCHEMA', N'sync', 'TABLE', N'1CExpenses', 'COLUMN', N'DocNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CExpenses', 'COLUMN', N'Code1c'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код подразделения. Передает Спеклер', 'SCHEMA', N'sync', 'TABLE', N'1CExpenses', 'COLUMN', N'DepartmentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор склада. Вносится в спеклере, может быть пусто', 'SCHEMA', N'sync', 'TABLE', N'1CExpenses', 'COLUMN', N'StorageCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя редактора. Присваивается в 1С, передаётся  в Спеклер', 'SCHEMA', N'sync', 'TABLE', N'1CExpenses', 'COLUMN', N'ModifyName1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата последнего изменения. Присваивается в 1С, передаётся  в Спеклер', 'SCHEMA', N'sync', 'TABLE', N'1CExpenses', 'COLUMN', N'ModifyDate1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'0-не готово к обработке, 1-запись готова к загрузке в 1С, 2-документ записан и не проведен в 1С, 3-документ проведен в 1С, 4-документ помечен на удаление в 1С, 5-ошибка', 'SCHEMA', N'sync', 'TABLE', N'1CExpenses', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на производство', 'SCHEMA', N'sync', 'TABLE', N'1CExpenses', 'COLUMN', N'ManufactureID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата, на которую был сформирован документ', 'SCHEMA', N'sync', 'TABLE', N'1CExpenses', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Текст ошибки', 'SCHEMA', N'sync', 'TABLE', N'1CExpenses', 'COLUMN', N'ErrorMessage'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код физлица для 1с. для поиска пользователя который ставиться в графу ответственный', 'SCHEMA', N'sync', 'TABLE', N'1CExpenses', 'COLUMN', N'EmployeeFysCode1C'
GO