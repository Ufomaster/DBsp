CREATE TABLE [dbo].[Packings] (
  [ID] [tinyint] IDENTITY,
  [Name] [varchar](255) NULL,
  [NameEng] [varchar](255) NULL,
  CONSTRAINT [PK_Packings_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Packings', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'Packings', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование english', 'SCHEMA', N'dbo', 'TABLE', N'Packings', 'COLUMN', N'NameEng'
GO