CREATE TABLE [QualityControl].[TypesBlocks] (
  [ID] [smallint] NOT NULL,
  [Name] [varchar](1000) NOT NULL,
  [VisibleCaption] [bit] NOT NULL,
  [TypesID] [tinyint] NOT NULL,
  [TreeValues] [bit] NOT NULL,
  [SortOrder] [tinyint] NULL,
  [FontBold] [bit] NOT NULL,
  [FontUnderline] [bit] NOT NULL,
  [AuthorEditable] [bit] NOT NULL,
  [SpecialistEditable] [bit] NOT NULL,
  [SchemaValues] [bit] NOT NULL,
  [TmcValues] [bit] NOT NULL,
  [DetailsValues] [bit] NOT NULL,
  [NormEditable] [bit] NOT NULL,
  [TmcValuesTest] [bit] NOT NULL,
  CONSTRAINT [PK_TypesBocks_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesBlocks.VisibleCaption'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesBlocks.TreeValues'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesBlocks.FontBold'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesBlocks.FontUnderline'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesBlocks.AuthorEditable'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesBlocks.SpecialistEditable'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesBlocks.SchemaValues'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesBlocks.TmcValues'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesBlocks.DetailsValues'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesBlocks.NormEditable'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesBlocks.TmcValuesTest'
GO

ALTER TABLE [QualityControl].[TypesBlocks]
  ADD CONSTRAINT [FK_TypesBlocks_Types (QualityControl)_ID] FOREIGN KEY ([TypesID]) REFERENCES [QualityControl].[Types] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование блока', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Отображать заголовок при печати', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'VisibleCaption'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'TypesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Включает значения из дерева технологий ЗЛ', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'TreeValues'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок следования блоков', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1 Жирный шрифт 0 нет', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'FontBold'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1 подчеркнутый шрифт 0 нет', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'FontUnderline'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Блок редактируется автором документа', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'AuthorEditable'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Блок редактируется специалистом КК', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'SpecialistEditable'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Включает только схемы к ЗЛ', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'SchemaValues'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Включает только Значения ТМЦ', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'TmcValues'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Включает комплекты ЗЛ', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'DetailsValues'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Редактируемая колонка нормативов', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'NormEditable'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Включает только значения материала с пометкой для тестирования', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesBlocks', 'COLUMN', N'TmcValuesTest'
GO