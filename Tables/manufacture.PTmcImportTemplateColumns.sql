CREATE TABLE [manufacture].[PTmcImportTemplateColumns] (
  [ID] [int] IDENTITY,
  [GroupColumnName] [varchar](18) NOT NULL,
  [TmcID] [int] NOT NULL,
  [TemplateImportID] [int] NOT NULL,
  CONSTRAINT [PK_PTmcImportColumns_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [manufacture].[PTmcImportTemplateColumns]
  ADD CONSTRAINT [FK_PTmcImportColumns_PTmcImports (manufacture)_ID] FOREIGN KEY ([TemplateImportID]) REFERENCES [manufacture].[PTmcImportTemplates] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [manufacture].[PTmcImportTemplateColumns]
  ADD CONSTRAINT [FK_PTmcImportColumns_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Примечание. По факт создаем связь много колонок файла - к одному ТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportTemplateColumns'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportTemplateColumns', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название столбца в группирующей таблице', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportTemplateColumns', 'COLUMN', N'GroupColumnName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на материал', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportTemplateColumns', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на идентификатор импорта', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcImportTemplateColumns', 'COLUMN', N'TemplateImportID'
GO