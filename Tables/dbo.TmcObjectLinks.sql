CREATE TABLE [dbo].[TmcObjectLinks] (
  [ObjectID] [int] NOT NULL,
  [TmcID] [int] NOT NULL
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_TmcObjectLinks_ObjectID]
  ON [dbo].[TmcObjectLinks] ([ObjectID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_TmcObjectLinks_TmcID]
  ON [dbo].[TmcObjectLinks] ([TmcID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[TmcObjectLinks]
  ADD CONSTRAINT [FK_TmcObjectLinks_ObjectTypes_ID] FOREIGN KEY ([ObjectID]) REFERENCES [dbo].[ObjectTypes] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[TmcObjectLinks]
  ADD CONSTRAINT [FK_TmcObjectLinks_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор гуппы, папки, объекта', 'SCHEMA', N'dbo', 'TABLE', N'TmcObjectLinks', 'COLUMN', N'ObjectID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'TmcObjectLinks', 'COLUMN', N'TmcID'
GO