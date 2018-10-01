CREATE TABLE [QualityControl].[ActsHistoryCCIDs] (
  [ID] [int] IDENTITY,
  [ActsHistoryID] [int] NOT NULL,
  [CCID] [varchar](800) NULL,
  [Batch] [varchar](800) NULL,
  [Box] [varchar](800) NULL,
  [Description] [varchar](800) NULL,
  CONSTRAINT [PK_ActsHistoryCCIDs_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActsHistoryCCIDs]
  ADD CONSTRAINT [FK_ActsHistoryCCIDs_ActsHistory (QualityControl)_ID] FOREIGN KEY ([ActsHistoryID]) REFERENCES [QualityControl].[ActsHistory] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryCCIDs', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор истории', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryCCIDs', 'COLUMN', N'ActsHistoryID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер CCID', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryCCIDs', 'COLUMN', N'CCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Бач', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryCCIDs', 'COLUMN', N'Batch'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ящик', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryCCIDs', 'COLUMN', N'Box'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryCCIDs', 'COLUMN', N'Description'
GO