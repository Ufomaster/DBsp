CREATE TABLE [QualityControl].[ActStatuses] (
  [ID] [tinyint] NOT NULL,
  [Name] [varchar](50) NULL,
  [ImageIndex] [tinyint] NULL,
  [IsFirst] [bit] NOT NULL,
  [EditingRightConst] [int] NULL,
  [StatusEditingRightConst] [int] NULL,
  [EnableMassSigning] [bit] NOT NULL,
  [CanEditSigners] [bit] NOT NULL,
  [SortOrder] [tinyint] NULL,
  [isAfterSign] [bit] NULL,
  CONSTRAINT [PK_ActStatuses_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.ActStatuses.IsFirst'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.ActStatuses.EnableMassSigning'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.ActStatuses.CanEditSigners'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActStatuses', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'ActStatuses', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор иконки', 'SCHEMA', N'QualityControl', 'TABLE', N'ActStatuses', 'COLUMN', N'ImageIndex'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг, начальный ли статус. Может быть только 1', 'SCHEMA', N'QualityControl', 'TABLE', N'ActStatuses', 'COLUMN', N'IsFirst'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор права на редактирование', 'SCHEMA', N'QualityControl', 'TABLE', N'ActStatuses', 'COLUMN', N'EditingRightConst'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор права на редактирование поля "статус"', 'SCHEMA', N'QualityControl', 'TABLE', N'ActStatuses', 'COLUMN', N'StatusEditingRightConst'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Разрешает функцию подписания документа', 'SCHEMA', N'QualityControl', 'TABLE', N'ActStatuses', 'COLUMN', N'EnableMassSigning'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг, позволено ли редактирование списка подписантов', 'SCHEMA', N'QualityControl', 'TABLE', N'ActStatuses', 'COLUMN', N'CanEditSigners'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'№ пп', 'SCHEMA', N'QualityControl', 'TABLE', N'ActStatuses', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус в который атоматически переходит акт после подписания последнего комментария', 'SCHEMA', N'QualityControl', 'TABLE', N'ActStatuses', 'COLUMN', N'isAfterSign'
GO