CREATE TABLE [dbo].[ProductionCardStatusesFields] (
  [ID] [int] IDENTITY,
  [ProductionCardStatusesID] [smallint] NOT NULL,
  [ColumnID] [int] NOT NULL,
  CONSTRAINT [PK_ProductionCardStatusesFields_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardStatusesFields]
  ADD CONSTRAINT [FK_ProductionCardStatusesFields_ProductionCardFields_colid] FOREIGN KEY ([ColumnID]) REFERENCES [dbo].[ProductionCardFields] ([colid]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ProductionCardStatusesFields]
  ADD CONSTRAINT [FK_ProductionCardStatusesFields_ProductionCardStatuses_ID] FOREIGN KEY ([ProductionCardStatusesID]) REFERENCES [dbo].[ProductionCardStatuses] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatusesFields', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatusesFields', 'COLUMN', N'ProductionCardStatusesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор колонки таблицы', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardStatusesFields', 'COLUMN', N'ColumnID'
GO