CREATE TABLE [dbo].[TmcSurrogateDetails] (
  [ID] [int] IDENTITY,
  [MasterTmcID] [int] NOT NULL,
  [TmcID] [int] NOT NULL,
  CONSTRAINT [PK_TmcSurrogateDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[TmcSurrogateDetails]
  ADD CONSTRAINT [FK_TmcSurrogateDetails_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

ALTER TABLE [dbo].[TmcSurrogateDetails]
  ADD CONSTRAINT [FK_TmcSurrogateDetails_Tmc_ID2] FOREIGN KEY ([MasterTmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'TmcSurrogateDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор мастера сурогата', 'SCHEMA', N'dbo', 'TABLE', N'TmcSurrogateDetails', 'COLUMN', N'MasterTmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор входящего в сурогат ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'TmcSurrogateDetails', 'COLUMN', N'TmcID'
GO