CREATE TABLE [dbo].[Units] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NOT NULL,
  [Code1C] [varchar](36) NULL,
  CONSTRAINT [PK_Units_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_Units_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Units', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'Units', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с', 'SCHEMA', N'dbo', 'TABLE', N'Units', 'COLUMN', N'Code1C'
GO