CREATE TABLE [manufacture].[PTmcImportColumns] (
  [ID] [int] IDENTITY,
  [ColumnName] [varchar](10) NOT NULL,
  [ImportTemplateColumnID] [int] NULL,
  [OperationID] [int] NOT NULL,
  CONSTRAINT [PK_PTmcImportColumns_ID_PTmcImportColumns] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [manufacture].[PTmcImportColumns]
  ADD CONSTRAINT [FK_PTmcImportColumns_PTmcOperations (manufacture)_ID] FOREIGN KEY ([OperationID]) REFERENCES [manufacture].[PTmcOperations] ([ID])
GO

ALTER TABLE [manufacture].[PTmcImportColumns]
  ADD CONSTRAINT [FK_PTmcImportColumns_Tmc_ID_PTmcImportColumns] FOREIGN KEY ([ImportTemplateColumnID]) REFERENCES [manufacture].[PTmcImportTemplateColumns] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Таблица нужна для того, чтобы понимать из каких колонок текущего файла мы производим импорт', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportColumns'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportColumns', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название столбца в импортируемом файле', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportColumns', 'COLUMN', N'ColumnName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на колонку шаблона', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportColumns', 'COLUMN', N'ImportTemplateColumnID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на идентификатор импорта', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportColumns', 'COLUMN', N'OperationID'
GO