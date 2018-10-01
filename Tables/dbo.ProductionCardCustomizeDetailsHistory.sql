CREATE TABLE [dbo].[ProductionCardCustomizeDetailsHistory] (
  [ID] [int] IDENTITY,
  [LinkedProductionCardCustomizeID] [int] NULL,
  [ProductionCardCustomizeHistoryID] [int] NOT NULL,
  [Norma] [decimal](18, 4) NULL,
  [TMCName] [varchar](255) NULL,
  [UnitName] [varchar](30) NULL,
  [Kind] [tinyint] NULL
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardCustomizeDetailsHistory]
  ADD CONSTRAINT [FK_ProductionCardCustomizeAssemblyDetailsHistory_ProductionCardCustomizeHistory_ID] FOREIGN KEY ([ProductionCardCustomizeHistoryID]) REFERENCES [dbo].[ProductionCardCustomizeHistory] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetailsHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ЗЛ составляющей', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetailsHistory', 'COLUMN', N'LinkedProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор исторической записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetailsHistory', 'COLUMN', N'ProductionCardCustomizeHistoryID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Норма', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetailsHistory', 'COLUMN', N'Norma'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ед. изм.', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetailsHistory', 'COLUMN', N'TMCName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'материала', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetailsHistory', 'COLUMN', N'UnitName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'№ этапа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetailsHistory', 'COLUMN', N'Kind'
GO