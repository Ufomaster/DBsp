CREATE TABLE [QualityControl].[Types] (
  [ID] [tinyint] NOT NULL,
  [Name] [varchar](255) NOT NULL,
  [CreateDate] [datetime] NOT NULL,
  [EndDate] [datetime] NULL,
  [SortOrder] [tinyint] NOT NULL,
  [ImageIndex] [smallint] NOT NULL,
  [isPCC] [bit] NOT NULL,
  [isMaterial] [bit] NOT NULL,
  [ResultCaption] [varchar](500) NULL,
  [ActTemplatesID] [smallint] NULL,
  [ActTestsEnabled] [bit] NULL,
  [SourceType] [tinyint] NULL,
  [ActTemplates2ID] [smallint] NULL,
  CONSTRAINT [PK_Types_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'QualityControl.Types.CreateDate'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.Types.isPCC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.Types.isMaterial'
GO

ALTER TABLE [QualityControl].[Types]
  ADD CONSTRAINT [FK_Types_ActTemplates (QualityControl)_ID] FOREIGN KEY ([ActTemplatesID]) REFERENCES [QualityControl].[ActTemplates] ([ID])
GO

ALTER TABLE [QualityControl].[Types]
  ADD CONSTRAINT [FK_Types_ActTemplates (QualityControl)_ID2] FOREIGN KEY ([ActTemplates2ID]) REFERENCES [QualityControl].[ActTemplates] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'Types', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование типа протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'Types', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания типа', 'SCHEMA', N'QualityControl', 'TABLE', N'Types', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата прекращения действия', 'SCHEMA', N'QualityControl', 'TABLE', N'Types', 'COLUMN', N'EndDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок следования в меню', 'SCHEMA', N'QualityControl', 'TABLE', N'Types', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор иконки', 'SCHEMA', N'QualityControl', 'TABLE', N'Types', 'COLUMN', N'ImageIndex'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'0 нет. 1 - протокол по ЗЛ.', 'SCHEMA', N'QualityControl', 'TABLE', N'Types', 'COLUMN', N'isPCC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'0-нет 1 - протокол по материалам', 'SCHEMA', N'QualityControl', 'TABLE', N'Types', 'COLUMN', N'isMaterial'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Текст поля вывода по протоколу', 'SCHEMA', N'QualityControl', 'TABLE', N'Types', 'COLUMN', N'ResultCaption'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор шаблона акта нс для автосоздания', 'SCHEMA', N'QualityControl', 'TABLE', N'Types', 'COLUMN', N'ActTemplatesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг. Разрешено использование актов отбора проб', 'SCHEMA', N'QualityControl', 'TABLE', N'Types', 'COLUMN', N'ActTestsEnabled'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип сырья из vw_ProductionPropertiesSourceType', 'SCHEMA', N'QualityControl', 'TABLE', N'Types', 'COLUMN', N'SourceType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор шаблона акта отклонения для автосоздания', 'SCHEMA', N'QualityControl', 'TABLE', N'Types', 'COLUMN', N'ActTemplates2ID'
GO