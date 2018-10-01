CREATE TABLE [dbo].[PackTypes] (
  [ID] [tinyint] IDENTITY,
  [Name] [varchar](50) NULL,
  CONSTRAINT [PK_PackTypes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'PackTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'PackTypes', 'COLUMN', N'Name'
GO