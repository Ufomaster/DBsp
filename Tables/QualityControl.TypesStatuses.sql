CREATE TABLE [QualityControl].[TypesStatuses] (
  [ID] [tinyint] NOT NULL,
  [Name] [varchar](50) NULL,
  [ImageIndex] [tinyint] NULL,
  [IsFirst] [bit] NOT NULL,
  [EditingRightConst] [int] NULL,
  [StatusEditingRightConst] [int] NULL,
  [SortOrder] [tinyint] NULL,
  [AutoStatus] [bit] NOT NULL,
  [EnableMassSigning] [bit] NOT NULL,
  [CanEditSigners] [bit] NOT NULL,
  CONSTRAINT [PK_TypesStatuses_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesStatuses.IsFirst'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesStatuses.AutoStatus'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesStatuses.EnableMassSigning'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.TypesStatuses.CanEditSigners'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesStatuses', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesStatuses', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор иконки', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesStatuses', 'COLUMN', N'ImageIndex'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг, начальный ли статус. Может быть только 1', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesStatuses', 'COLUMN', N'IsFirst'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор права на редактирование', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesStatuses', 'COLUMN', N'EditingRightConst'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор права на редактирование поля "статус"', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesStatuses', 'COLUMN', N'StatusEditingRightConst'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок сортировки в списке процессов', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesStatuses', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг, указывабщий что в этот статут можно совершить автоматический переход, при наличии процесса прохождения', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesStatuses', 'COLUMN', N'AutoStatus'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Разрешает функцию подписания документа', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesStatuses', 'COLUMN', N'EnableMassSigning'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг, позволено ли редактирование списка подписантов', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesStatuses', 'COLUMN', N'CanEditSigners'
GO