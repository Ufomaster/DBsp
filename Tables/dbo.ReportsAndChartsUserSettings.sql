CREATE TABLE [dbo].[ReportsAndChartsUserSettings] (
  [ID] [int] IDENTITY,
  [ReportsChartsID] [int] NOT NULL,
  [UserID] [int] NOT NULL,
  [XMLUserConfig] [varchar](max) NULL,
  CONSTRAINT [PK_ReportsAndChartsUserSettings_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsUserSettings', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор отчета', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsUserSettings', 'COLUMN', N'ReportsChartsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsUserSettings', 'COLUMN', N'UserID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ХМЛ данные настроек конфигурации грида', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsUserSettings', 'COLUMN', N'XMLUserConfig'
GO