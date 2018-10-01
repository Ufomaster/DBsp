CREATE TABLE [dbo].[ProductionOrdersProdCardCustomize] (
  [ID] [int] IDENTITY,
  [ProductionOrdersID] [int] NOT NULL,
  [ProductionCardCustomizeID] [int] NOT NULL,
  [SortOrder] [tinyint] NULL,
  CONSTRAINT [PK_ProductionOrdersProdCardCustomize_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UQ_ProductionOrdersProdCardCustomize_ProductionOrdersID_ProductionCardCustomizeID]
  ON [dbo].[ProductionOrdersProdCardCustomize] ([ProductionOrdersID], [ProductionCardCustomizeID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionOrdersProdCardCustomize]
  ADD CONSTRAINT [FK_ProductionOrdersProdCardCustomize_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ProductionOrdersProdCardCustomize]
  ADD CONSTRAINT [FK_ProductionOrdersProdCardCustomize_ProductionOrders_ID] FOREIGN KEY ([ProductionOrdersID]) REFERENCES [dbo].[ProductionOrders] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrdersProdCardCustomize', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrdersProdCardCustomize', 'COLUMN', N'ProductionOrdersID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ЗЛ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrdersProdCardCustomize', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок сортировки', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrdersProdCardCustomize', 'COLUMN', N'SortOrder'
GO