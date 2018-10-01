CREATE TABLE [dbo].[TmcPlaces] (
  [ID] [smallint] IDENTITY,
  [ParentID] [smallint] NULL,
  [Name] [varchar](50) NULL,
  CONSTRAINT [PK_TmcPlaces_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[TmcPlaces]
  ADD CONSTRAINT [FK_TmcPlaces_TmcPlaces_ID] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[TmcPlaces] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'TmcPlaces', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор родительской записи', 'SCHEMA', N'dbo', 'TABLE', N'TmcPlaces', 'COLUMN', N'ParentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'TmcPlaces', 'COLUMN', N'Name'
GO