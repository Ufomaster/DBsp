CREATE TABLE [dbo].[HDDFormat] (
  [ID] [int] IDENTITY,
  [Name] [varchar](20) NOT NULL,
  PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_HDDFormat_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'HDDFormat', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название', 'SCHEMA', N'dbo', 'TABLE', N'HDDFormat', 'COLUMN', N'Name'
GO