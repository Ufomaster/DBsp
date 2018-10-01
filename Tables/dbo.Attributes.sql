CREATE TABLE [dbo].[Attributes] (
  [ID] [int] IDENTITY,
  [Name] [varchar](100) NOT NULL,
  [Description] [varchar](max) NULL,
  CONSTRAINT [PK_Attributes_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_Attributes_Name] UNIQUE ([Name])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Attributes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название', 'SCHEMA', N'dbo', 'TABLE', N'Attributes', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание', 'SCHEMA', N'dbo', 'TABLE', N'Attributes', 'COLUMN', N'Description'
GO