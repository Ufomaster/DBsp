CREATE TABLE [QualityControl].[ActsCCIDs] (
  [ID] [int] IDENTITY,
  [ActsID] [int] NOT NULL,
  [CCID] [varchar](800) NULL,
  [Batch] [varchar](800) NULL,
  [Box] [varchar](800) NULL,
  [Description] [varchar](800) NULL,
  CONSTRAINT [PK_ActsCCIDs_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActsCCIDs]
  ADD CONSTRAINT [FK_ActsCCIDs_Acts (QualityControl)_ID] FOREIGN KEY ([ActsID]) REFERENCES [QualityControl].[Acts] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsCCIDs', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsCCIDs', 'COLUMN', N'ActsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер CCID', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsCCIDs', 'COLUMN', N'CCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Бач', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsCCIDs', 'COLUMN', N'Batch'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ящик', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsCCIDs', 'COLUMN', N'Box'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsCCIDs', 'COLUMN', N'Description'
GO