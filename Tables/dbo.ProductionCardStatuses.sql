CREATE TABLE [dbo].[ProductionCardStatuses] (
  [ID] [smallint] NOT NULL,
  [Name] [varchar](30) NULL,
  [EditingRightConst] [int] NULL,
  [StatusEditingRightConst] [int] NULL,
  [ImageID] [int] NOT NULL,
  [CanEditLayouts] [bit] NOT NULL,
  [IsAdaptingFunction] [bit] NOT NULL,
  [isDeletable] [bit] NOT NULL,
  [SortOrder] [int] NOT NULL,
  [CanEditReleaseDates] [bit] NOT NULL,
  [CanEditInstruction] [bit] NOT NULL,
  [CanEditDetails] [bit] NOT NULL,
  [CanEditTech] [bit] NOT NULL,
  [ExcludeSpecNumbering] [bit] NOT NULL,
  [isReplaceStatus] [bit] NOT NULL,
  CONSTRAINT [PK_ProductionCardStatuses_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_ProductionCardStatuses_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardStatuses.CanEditLayouts'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardStatuses.IsAdaptingFunction'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardStatuses.isDeletable'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardStatuses.CanEditReleaseDates'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardStatuses.CanEditInstruction'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardStatuses.CanEditDetails'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardStatuses.CanEditTech'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardStatuses.ExcludeSpecNumbering'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardStatuses.isReplaceStatus'
GO

ALTER TABLE [dbo].[ProductionCardStatuses]
  ADD CONSTRAINT [FK_ProductionCardStatuses_UserRightsObjects_ID1] FOREIGN KEY ([StatusEditingRightConst]) REFERENCES [dbo].[UserRightsObjects] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardStatuses]
  ADD CONSTRAINT [FK_ProductionCardStatuses_UserRightsObjects_ID2] FOREIGN KEY ([EditingRightConst]) REFERENCES [dbo].[UserRightsObjects] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статусы заказных', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название статуса производства', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на право, которое дает возможность на редактирование пользователю в этом статусе', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'EditingRightConst'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на право, которое дает возможность на редактирования комбика статусы пользователю в этом статусе', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'StatusEditingRightConst'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор изображения', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'ImageID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Можно ли редактировать макеты', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'CanEditLayouts'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг - является ли статус разрешающим функции согласования', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'IsAdaptingFunction'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг - заказной лист удаляемый в таком статусе', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'isDeletable'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок следования статусов', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Редактируемые даты сдачи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'CanEditReleaseDates'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Можно ли редактировать инструкцию', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'CanEditInstruction'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Редактируемые комплекты/заготовки', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'CanEditDetails'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Редактируемое ли дерево технологии', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'CanEditTech'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1-Исключить ЗЛ из нумерации спецификации', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'ExcludeSpecNumbering'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Является статусом замены, статус выбирается как  статус ЗЛ для пометки "Заменен"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatuses', 'COLUMN', N'isReplaceStatus'
GO