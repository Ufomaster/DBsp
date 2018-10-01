CREATE TABLE [dbo].[AgreementsTypes] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NOT NULL,
  CONSTRAINT [PK_AgreementsTypes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'AgreementsTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип договора', 'SCHEMA', N'dbo', 'TABLE', N'AgreementsTypes', 'COLUMN', N'Name'
GO