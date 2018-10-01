CREATE TABLE [dbo].[ProductionCardCustomizeProperties] (
  [ID] [int] IDENTITY,
  [PropHistoryValueID] [int] NULL,
  [ProductionCardCustomizeID] [int] NOT NULL,
  [HandMadeValue] [varchar](1000) NULL,
  [HandMadeValueOwnerID] [int] NULL,
  [SourceType] [int] NULL,
  CONSTRAINT [PK_ProductionCardCustomizeProperties_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardCustomizeProperties_ProductionCardCustomizeID]
  ON [dbo].[ProductionCardCustomizeProperties] ([ProductionCardCustomizeID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardCustomizeProperties_SourceType]
  ON [dbo].[ProductionCardCustomizeProperties] ([SourceType])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardCustomizeProperties]
  ADD CONSTRAINT [FK_ProductionCardCustomizeProperties_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ProductionCardCustomizeProperties]
  ADD CONSTRAINT [FK_ProductionCardCustomizeProperties_ProductionCardPropertiesHistoryDetails_ID] FOREIGN KEY ([PropHistoryValueID]) REFERENCES [dbo].[ProductionCardPropertiesHistoryDetails] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomizeProperties]
  ADD CONSTRAINT [FK_ProductionCardCustomizeProperties_ProductionCardPropertiesHistoryDetails_ID1] FOREIGN KEY ([HandMadeValueOwnerID]) REFERENCES [dbo].[ProductionCardPropertiesHistoryDetails] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeProperties', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор опубликованной ветви дерева взаимоствязей - значение', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeProperties', 'COLUMN', N'PropHistoryValueID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeProperties', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ручное значение', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeProperties', 'COLUMN', N'HandMadeValue'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор записи на историю дерева - на справочник', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeProperties', 'COLUMN', N'HandMadeValueOwnerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип сырья/материалов', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeProperties', 'COLUMN', N'SourceType'
GO