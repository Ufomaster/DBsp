CREATE TABLE [dbo].[Brands] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  CONSTRAINT [PK_Brands_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_Brands_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Brands', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'Brands', 'COLUMN', N'Name'
GO