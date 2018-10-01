CREATE TABLE [dbo].[TransportBrands] (
  [ID] [int] IDENTITY,
  [Name] [varchar](30) NOT NULL,
  CONSTRAINT [PK_TransportBrands] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'TransportBrands', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'TransportBrands', 'COLUMN', N'Name'
GO