CREATE TABLE [dbo].[ProductionCardPropertiesHistoryDetails] (
  [ID] [int] IDENTITY,
  [ParentID] [int] NULL,
  [ProductionCardPropertiesHistoryID] [int] NOT NULL,
  [NodeLevel] [tinyint] NOT NULL,
  [NodeOrder] [tinyint] NOT NULL,
  [ObjectTypeID] [int] NOT NULL,
  [Required] [bit] NULL,
  [FixedEdit] [bit] NULL,
  CONSTRAINT [PK_ProductionCardPropertiesHistoryDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardPropertiesHistoryDetails_ObjectTypeID]
  ON [dbo].[ProductionCardPropertiesHistoryDetails] ([ObjectTypeID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardPropertiesHistoryDetails_ParentID]
  ON [dbo].[ProductionCardPropertiesHistoryDetails] ([ParentID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardPropertiesHistoryDetails_ProductionCardPropertiesHistoryID]
  ON [dbo].[ProductionCardPropertiesHistoryDetails] ([ProductionCardPropertiesHistoryID])
  INCLUDE ([ID], [ParentID], [NodeOrder], [ObjectTypeID], [Required], [FixedEdit])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardPropertiesHistoryDetails]
  ADD CONSTRAINT [FK_ProductionCardPropertiesHistoryDetails_ObjectTypes_ID] FOREIGN KEY ([ObjectTypeID]) REFERENCES [dbo].[ObjectTypes] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardPropertiesHistoryDetails]
  ADD CONSTRAINT [FK_ProductionCardPropertiesHistoryDetails_ProductionCardPropertiesHistory_ID] FOREIGN KEY ([ProductionCardPropertiesHistoryID]) REFERENCES [dbo].[ProductionCardPropertiesHistory] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardPropertiesHistoryDetails]
  ADD CONSTRAINT [FK_ProductionCardPropertiesHistoryDetails_ProductionCardPropertiesHistoryDetails_ID1] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[ProductionCardPropertiesHistoryDetails] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Таблица деталей опубликованніх взаимоисключений установок производства', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardPropertiesHistoryDetails'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardPropertiesHistoryDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор родительской ветви', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardPropertiesHistoryDetails', 'COLUMN', N'ParentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор шапки', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardPropertiesHistoryDetails', 'COLUMN', N'ProductionCardPropertiesHistoryID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уровень вложенности.Нужно для корректности построения дерева', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardPropertiesHistoryDetails', 'COLUMN', N'NodeLevel'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок следования записей ветки', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardPropertiesHistoryDetails', 'COLUMN', N'NodeOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа объекта', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardPropertiesHistoryDetails', 'COLUMN', N'ObjectTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Указание необходимости заполения, берется из атрибутов на момент публикации', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardPropertiesHistoryDetails', 'COLUMN', N'Required'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Установка комбобокса в состояние ручного редактирования, берется из атрибутов на момент публикации', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardPropertiesHistoryDetails', 'COLUMN', N'FixedEdit'
GO