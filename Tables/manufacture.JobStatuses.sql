CREATE TABLE [manufacture].[JobStatuses] (
  [ID] [tinyint] IDENTITY,
  [Name] [varchar](255) NOT NULL,
  CONSTRAINT [PK_JobStatuses_ID_JobStatuses] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'manufacture', 'TABLE', N'JobStatuses', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'manufacture', 'TABLE', N'JobStatuses', 'COLUMN', N'Name'
GO