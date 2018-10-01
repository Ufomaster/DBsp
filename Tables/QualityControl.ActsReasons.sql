CREATE TABLE [QualityControl].[ActsReasons] (
  [ID] [smallint] IDENTITY,
  [Name] [varchar](800) NOT NULL,
  [ClassID] [int] NULL,
  [ActID] [int] NOT NULL,
  [FaultsReasonsClassID] [int] NULL,
  CONSTRAINT [PK_ActsReasons_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActsReasons]
  ADD CONSTRAINT [FK_ActsReasons_Acts (QualityControl)_ID] FOREIGN KEY ([ActID]) REFERENCES [QualityControl].[Acts] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [QualityControl].[ActsReasons]
  ADD CONSTRAINT [FK_ActsReasons_FaultsReasonsClass (QualityControl)_ID] FOREIGN KEY ([FaultsReasonsClassID]) REFERENCES [QualityControl].[FaultsReasonsClass] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsReasons', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsReasons', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор класса причины', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsReasons', 'COLUMN', N'ClassID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsReasons', 'COLUMN', N'ActID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор класса причины', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsReasons', 'COLUMN', N'FaultsReasonsClassID'
GO