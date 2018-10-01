CREATE TABLE [dbo].[ProductionCardProperties] (
  [ID] [int] IDENTITY,
  [ParentID] [int] NULL,
  [ObjectTypeID] [int] NOT NULL,
  [NodeExpanded] [bit] NULL DEFAULT (1),
  [NodeLevel] [tinyint] NOT NULL,
  [NodeOrder] [tinyint] NOT NULL,
  PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardProperties_NodeOrder]
  ON [dbo].[ProductionCardProperties] ([NodeOrder])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardProperties_ObjectTypeID]
  ON [dbo].[ProductionCardProperties] ([ObjectTypeID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardProperties_ParentID]
  ON [dbo].[ProductionCardProperties] ([ParentID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardProperties]
  ADD CONSTRAINT [FK_ProductionPCardProperties_ObjectTypes_ID] FOREIGN KEY ([ObjectTypeID]) REFERENCES [dbo].[ObjectTypes] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardProperties]
  ADD CONSTRAINT [FK_ProductionPCardProperties_ProductionPCardProperties_ID] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[ProductionCardProperties] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Таблица взаимоисключений установок производства', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProperties'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProperties', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор родительской ветви', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProperties', 'COLUMN', N'ParentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор свойства справочника объекта или значения', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProperties', 'COLUMN', N'ObjectTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние ноды 0 коллапсед 1 експандед', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProperties', 'COLUMN', N'NodeExpanded'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уровень вложенности.Нужно для корректности построения дерева', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProperties', 'COLUMN', N'NodeLevel'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок следования записей ветки', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProperties', 'COLUMN', N'NodeOrder'
GO