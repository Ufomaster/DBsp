CREATE TABLE [dbo].[ProductionCardCustomizeReleaseDates] (
  [ID] [int] IDENTITY,
  [ReleaseDate] [datetime] NOT NULL,
  [ReleaseCount] [int] NOT NULL,
  [ProductionCardCustomizeID] [int] NOT NULL,
  CONSTRAINT [PK_ProductionCardCustomizeReleaseDates_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardCustomizeReleaseDates]
  ADD CONSTRAINT [FK_ProductionCardCustomizeReleaseDates_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeReleaseDates', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeReleaseDates', 'COLUMN', N'ReleaseDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во для сдачи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeReleaseDates', 'COLUMN', N'ReleaseCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeReleaseDates', 'COLUMN', N'ProductionCardCustomizeID'
GO