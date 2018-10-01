CREATE TABLE [dod].[ImportTemplates] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  [CustomerID] [int] NULL,
  [Type] [tinyint] NULL,
  [Map] [varchar](max) NULL,
  [isDeleted] [bit] NULL,
  [Comma] [varchar](1) NULL,
  [QuoteChar] [varchar](3) NULL,
  [SkipRows] [int] NULL,
  [CharSet] [smallint] NULL,
  [CardRootName] [varchar](100) NULL,
  [CardRootFullPath] [varchar](100) NULL,
  CONSTRAINT [PK_ImportTemplates_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dod].[ImportTemplates]
  ADD CONSTRAINT [FK_ImportTemplates_Customers_ID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dod', 'TABLE', N'ImportTemplates', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dod', 'TABLE', N'ImportTemplates', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор контрагента', 'SCHEMA', N'dod', 'TABLE', N'ImportTemplates', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип импорта 1-csv, 2-folder ini, 3-xml, 4-xls, 5-txt, 6-dbf, 7-ini', 'SCHEMA', N'dod', 'TABLE', N'ImportTemplates', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Карта данных поле=колонка', 'SCHEMA', N'dod', 'TABLE', N'ImportTemplates', 'COLUMN', N'Map'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг удаленно', 'SCHEMA', N'dod', 'TABLE', N'ImportTemplates', 'COLUMN', N'isDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'символ разделителя', 'SCHEMA', N'dod', 'TABLE', N'ImportTemplates', 'COLUMN', N'Comma'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Символ квотирования', 'SCHEMA', N'dod', 'TABLE', N'ImportTemplates', 'COLUMN', N'QuoteChar'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пропустить строк', 'SCHEMA', N'dod', 'TABLE', N'ImportTemplates', 'COLUMN', N'SkipRows'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'узел с данными карты для xml', 'SCHEMA', N'dod', 'TABLE', N'ImportTemplates', 'COLUMN', N'CardRootName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Полный путь к данным карты (для xml) без учета самого верхнего root', 'SCHEMA', N'dod', 'TABLE', N'ImportTemplates', 'COLUMN', N'CardRootFullPath'
GO