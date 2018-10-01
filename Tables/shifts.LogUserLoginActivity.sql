CREATE TABLE [shifts].[LogUserLoginActivity] (
  [ID] [bigint] IDENTITY,
  [SD] [datetime] NOT NULL,
  [LoginName] [varchar](50) NULL,
  [EmployeeID] [int] NULL,
  [HostName] [varchar](255) NULL,
  [IP] [varchar](50) NULL,
  [SPID] [int] NULL,
  [ED] [datetime] NULL,
  CONSTRAINT [PK_LogUserLoginActivity_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'LogUserLoginActivity', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата логина', 'SCHEMA', N'shifts', 'TABLE', N'LogUserLoginActivity', 'COLUMN', N'SD'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', 'SQL login Name', 'SCHEMA', N'shifts', 'TABLE', N'LogUserLoginActivity', 'COLUMN', N'LoginName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя', 'SCHEMA', N'shifts', 'TABLE', N'LogUserLoginActivity', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', 'Host Name', 'SCHEMA', N'shifts', 'TABLE', N'LogUserLoginActivity', 'COLUMN', N'HostName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', 'PC IP', 'SCHEMA', N'shifts', 'TABLE', N'LogUserLoginActivity', 'COLUMN', N'IP'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', '@@SPID', 'SCHEMA', N'shifts', 'TABLE', N'LogUserLoginActivity', 'COLUMN', N'SPID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата выхода при наличии', 'SCHEMA', N'shifts', 'TABLE', N'LogUserLoginActivity', 'COLUMN', N'ED'
GO