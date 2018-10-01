CREATE TABLE [dbo].[ProductionCardCustomizePropertiesHistory] (
  [ID] [int] IDENTITY,
  [PropHistoryValueID] [int] NULL,
  [HandMadeValue] [varchar](1000) NULL,
  [HandMadeValueOwnerID] [int] NULL,
  [ProductionCardCustomizeHistoryID] [int] NOT NULL,
  [SourceType] [int] NULL
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardCustomizePropertiesHistory]
  ADD CONSTRAINT [FK_ProductionCardCustomizePropertiesHistory_ProductionCardCustomizeHistory_ID] FOREIGN KEY ([ProductionCardCustomizeHistoryID]) REFERENCES [dbo].[ProductionCardCustomizeHistory] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ProductionCardCustomizePropertiesHistory]
  ADD CONSTRAINT [FK_ProductionCardCustomizePropertiesHistory_ProductionCardPropertiesHistoryDetails_ID] FOREIGN KEY ([PropHistoryValueID]) REFERENCES [dbo].[ProductionCardPropertiesHistoryDetails] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomizePropertiesHistory]
  ADD CONSTRAINT [FK_ProductionCardCustomizePropertiesHistory_ProductionCardPropertiesHistoryDetails_ID1] FOREIGN KEY ([HandMadeValueOwnerID]) REFERENCES [dbo].[ProductionCardPropertiesHistoryDetails] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizePropertiesHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор опубликованной ветви дерева взаимоствязей - значение', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizePropertiesHistory', 'COLUMN', N'PropHistoryValueID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ручное значение', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizePropertiesHistory', 'COLUMN', N'HandMadeValue'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор записи на историю дерева - на справочник', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizePropertiesHistory', 'COLUMN', N'HandMadeValueOwnerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор исторической записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizePropertiesHistory', 'COLUMN', N'ProductionCardCustomizeHistoryID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип сырья/материалов', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizePropertiesHistory', 'COLUMN', N'SourceType'
GO