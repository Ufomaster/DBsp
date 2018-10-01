CREATE TABLE [manufacture].[PTmcOperationTypes] (
  [ID] [tinyint] NOT NULL,
  [Name] [varchar](50) NOT NULL,
  CONSTRAINT [PK_PTmcOperationTypes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperationTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperationTypes', 'COLUMN', N'Name'
GO