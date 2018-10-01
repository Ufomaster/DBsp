CREATE TABLE [QualityControl].[ActsZL] (
  [ID] [int] IDENTITY,
  [ActsID] [int] NOT NULL,
  [PCCID] [int] NULL,
  CONSTRAINT [PK_ActsZL_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActsZL]
  ADD CONSTRAINT [FK_ActsZL_Acts (QualityControl)_ID] FOREIGN KEY ([ActsID]) REFERENCES [QualityControl].[Acts] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [QualityControl].[ActsZL]
  ADD CONSTRAINT [FK_ActsZL_ProductionCardCustomize_ID] FOREIGN KEY ([PCCID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsZL', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsZL', 'COLUMN', N'ActsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ЗЛ', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsZL', 'COLUMN', N'PCCID'
GO