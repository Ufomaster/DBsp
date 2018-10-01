CREATE TABLE [manufacture].[JobStageChecksTypes] (
  [ID] [tinyint] IDENTITY,
  [Name] [varchar](50) NOT NULL,
  CONSTRAINT [PK_JobStageChecksTypes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksTypes', 'COLUMN', N'Name'
GO