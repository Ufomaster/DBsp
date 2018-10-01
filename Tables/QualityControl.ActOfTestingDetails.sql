CREATE TABLE [QualityControl].[ActOfTestingDetails] (
  [ID] [int] IDENTITY,
  [Amount] [decimal](18, 4) NULL,
  [UnitID] [int] NULL,
  [AmountUsed] [decimal](18, 4) NULL,
  [TmcID] [int] NOT NULL,
  [ProtocolID] [int] NULL,
  CONSTRAINT [PK_ActOfTestingDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActOfTestingDetails]
  ADD CONSTRAINT [FK_ActOfTestingDetails_Protocols (QualityControl)_ID] FOREIGN KEY ([ProtocolID]) REFERENCES [QualityControl].[Protocols] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [QualityControl].[ActOfTestingDetails]
  ADD CONSTRAINT [FK_ActOfTestingDetails_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

ALTER TABLE [QualityControl].[ActOfTestingDetails]
  ADD CONSTRAINT [FK_ActOfTestingDetails_Units_ID] FOREIGN KEY ([UnitID]) REFERENCES [dbo].[Units] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfTestingDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во полученного', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfTestingDetails', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ед. изм.', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfTestingDetails', 'COLUMN', N'UnitID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во использованного', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfTestingDetails', 'COLUMN', N'AmountUsed'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор материала', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfTestingDetails', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfTestingDetails', 'COLUMN', N'ProtocolID'
GO