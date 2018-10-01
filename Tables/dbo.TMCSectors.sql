CREATE TABLE [dbo].[TMCSectors] (
  [ID] [int] IDENTITY,
  [SectorID] [tinyint] NOT NULL,
  [TMCID] [int] NOT NULL,
  CONSTRAINT [PK_TMCSectors_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_TMCSectors_SectorID_TMCID] UNIQUE ([SectorID], [TMCID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[TMCSectors]
  ADD CONSTRAINT [FK_TMCSectors_StorageStructureSectors_ID] FOREIGN KEY ([SectorID]) REFERENCES [manufacture].[StorageStructureSectors] ([ID])
GO

ALTER TABLE [dbo].[TMCSectors]
  ADD CONSTRAINT [FK_TMCSectors_Tmc_ID] FOREIGN KEY ([TMCID]) REFERENCES [dbo].[Tmc] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'TMCSectors', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор участка', 'SCHEMA', N'dbo', 'TABLE', N'TMCSectors', 'COLUMN', N'SectorID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'TMCSectors', 'COLUMN', N'TMCID'
GO