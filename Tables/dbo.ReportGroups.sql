CREATE TABLE [dbo].[ReportGroups] (
  [ID] [int] NOT NULL,
  [ParentID] [int] NULL,
  [Name] [varchar](250) NOT NULL,
  CONSTRAINT [PK_ReportGroups_ID] PRIMARY KEY NONCLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ReportGroups]
  ADD CONSTRAINT [FK_ReportGroups_ReportGroups] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[ReportGroups] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ReportGroups', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор родительской группы', 'SCHEMA', N'dbo', 'TABLE', N'ReportGroups', 'COLUMN', N'ParentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'ReportGroups', 'COLUMN', N'Name'
GO