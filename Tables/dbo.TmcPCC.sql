CREATE TABLE [dbo].[TmcPCC] (
  [ID] [int] IDENTITY,
  [TmcID] [int] NOT NULL,
  [ProductionCardCustomizeID] [int] NOT NULL,
  [CardCount] [int] NOT NULL CONSTRAINT [DF_TmcPCC_CardCount] DEFAULT (1),
  CONSTRAINT [PK_TmcPCC_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_TmcPCC_ProductionCardCustomizeID_TmcID] UNIQUE ([ProductionCardCustomizeID], [TmcID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[TmcPCC]
  ADD CONSTRAINT [FK_TmcPCC_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

ALTER TABLE [dbo].[TmcPCC]
  ADD CONSTRAINT [FK_TmcPCC_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'TmcPCC', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'TmcPCC', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'TmcPCC', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во карт на тиражном листе', 'SCHEMA', N'dbo', 'TABLE', N'TmcPCC', 'COLUMN', N'CardCount'
GO