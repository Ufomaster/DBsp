CREATE TABLE [dbo].[Interfaces] (
  [ID] [int] IDENTITY,
  [Name] [varchar](10) NULL,
  PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_HDDInterface_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Interfaces', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название', 'SCHEMA', N'dbo', 'TABLE', N'Interfaces', 'COLUMN', N'Name'
GO