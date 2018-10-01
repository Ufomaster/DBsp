CREATE TABLE [manufacture].[FailTypes] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  CONSTRAINT [PK_FailTypes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'FailTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'manufacture', 'TABLE', N'FailTypes', 'COLUMN', N'Name'
GO