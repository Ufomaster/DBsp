CREATE TABLE [dbo].[VideoCards] (
  [ID] [int] IDENTITY,
  [Name] [varchar](50) NOT NULL,
  CONSTRAINT [PK_VideoCards_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_VideoCards_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видеокарты', 'SCHEMA', N'dbo', 'TABLE', N'VideoCards'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'VideoCards', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'VideoCards', 'COLUMN', N'Name'
GO