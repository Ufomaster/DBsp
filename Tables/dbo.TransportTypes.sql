CREATE TABLE [dbo].[TransportTypes] (
  [ID] [smallint] IDENTITY,
  [Name] [varchar](30) NOT NULL,
  CONSTRAINT [pk_TransportTypes] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'TransportTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'TransportTypes', 'COLUMN', N'Name'
GO