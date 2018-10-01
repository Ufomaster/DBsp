CREATE TABLE [dbo].[ProductionCardSourceKind] (
  [ID] [tinyint] IDENTITY,
  [Name] [varchar](60) NOT NULL,
  CONSTRAINT [PK_ProductionCardSourceKind_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardSourceKind', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardSourceKind', 'COLUMN', N'Name'
GO