CREATE TABLE [dbo].[SolutionTmc] (
  [ID] [int] IDENTITY,
  [SolutionID] [int] NOT NULL,
  [TmcID] [int] NOT NULL,
  [Amount] [decimal](18, 4) NULL,
  [Price] [decimal](18, 4) NULL,
  CONSTRAINT [PK_SolutionTmc_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[SolutionTmc]
  ADD CONSTRAINT [FK_SolutionTmc_Solutions_ID] FOREIGN KEY ([SolutionID]) REFERENCES [dbo].[Solutions] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SolutionTmc]
  ADD CONSTRAINT [FK_SolutionTmc_TmcID_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Использованные в работе расходники', 'SCHEMA', N'dbo', 'TABLE', N'SolutionTmc'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'SolutionTmc', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор работы', 'SCHEMA', N'dbo', 'TABLE', N'SolutionTmc', 'COLUMN', N'SolutionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'SolutionTmc', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Списано, (кол-во, вес)', 'SCHEMA', N'dbo', 'TABLE', N'SolutionTmc', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сумма(для услуг)', 'SCHEMA', N'dbo', 'TABLE', N'SolutionTmc', 'COLUMN', N'Price'
GO