CREATE TABLE [dod].[CardStatuses] (
  [ID] [tinyint] NOT NULL,
  [Name] [varchar](100) NOT NULL,
  CONSTRAINT [PK_CardStatuses_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dod', 'TABLE', N'CardStatuses', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование статуса', 'SCHEMA', N'dod', 'TABLE', N'CardStatuses', 'COLUMN', N'Name'
GO