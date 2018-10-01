CREATE TABLE [QualityControl].[ActsHistoryReasons] (
  [ID] [int] IDENTITY,
  [ActsHistoryID] [int] NULL,
  [Name] [varchar](800) NOT NULL,
  [ClassID] [int] NULL,
  [FaultsReasonsClassID] [int] NULL,
  CONSTRAINT [PK_ActsHistoryReasons_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActsHistoryReasons]
  ADD CONSTRAINT [FK_ActsHistoryReasons_ActsHistory (QualityControl)_ID] FOREIGN KEY ([ActsHistoryID]) REFERENCES [QualityControl].[ActsHistory] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryReasons', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryReasons', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор класса причины', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryReasons', 'COLUMN', N'ClassID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор класса причины', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryReasons', 'COLUMN', N'FaultsReasonsClassID'
GO