CREATE TABLE [dbo].[RollsType] (
  [ID] [int] IDENTITY,
  [Name] [varchar](100) NULL,
  CONSTRAINT [PK_RollsType_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'RollsType', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'RollsType', 'COLUMN', N'Name'
GO