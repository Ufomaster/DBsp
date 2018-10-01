CREATE TABLE [dbo].[Reports] (
  [ID] [int] NOT NULL,
  [ReportGroupID] [int] NOT NULL,
  [SysName] [varchar](50) NULL,
  [Name] [varchar](250) NOT NULL,
  [CreateDate] [datetime] NOT NULL CONSTRAINT [DF_Report_DateCreated] DEFAULT (getdate()),
  [ChangeDate] [datetime] NOT NULL CONSTRAINT [DF_Report_DateUpdate] DEFAULT (getdate()),
  [VersionMajor] [int] NOT NULL CONSTRAINT [DF_Report_VersionMajor] DEFAULT (1),
  [VersionMinor] [int] NOT NULL CONSTRAINT [DF_Report_VersionMinor] DEFAULT (0),
  [Description] [varchar](2048) NULL,
  [Params] [varchar](2048) NULL,
  [Report] [varbinary](max) NULL,
  CONSTRAINT [PK_Report_ID] PRIMARY KEY NONCLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Reports]
  ADD CONSTRAINT [FK_Report_ReportGroups] FOREIGN KEY ([ReportGroupID]) REFERENCES [dbo].[ReportGroups] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Reports', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор группы отчетов', 'SCHEMA', N'dbo', 'TABLE', N'Reports', 'COLUMN', N'ReportGroupID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Системное имя', 'SCHEMA', N'dbo', 'TABLE', N'Reports', 'COLUMN', N'SysName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'Reports', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'dbo', 'TABLE', N'Reports', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата изменения', 'SCHEMA', N'dbo', 'TABLE', N'Reports', 'COLUMN', N'ChangeDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Версия мажорная', 'SCHEMA', N'dbo', 'TABLE', N'Reports', 'COLUMN', N'VersionMajor'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Версия минорная', 'SCHEMA', N'dbo', 'TABLE', N'Reports', 'COLUMN', N'VersionMinor'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание', 'SCHEMA', N'dbo', 'TABLE', N'Reports', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Входные параметры', 'SCHEMA', N'dbo', 'TABLE', N'Reports', 'COLUMN', N'Params'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Отчет', 'SCHEMA', N'dbo', 'TABLE', N'Reports', 'COLUMN', N'Report'
GO