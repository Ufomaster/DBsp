CREATE TABLE [dbo].[UserReportsAndCharts] (
  [ID] [int] IDENTITY,
  [UserID] [int] NOT NULL,
  [ReportsAndChartsID] [int] NOT NULL,
  CONSTRAINT [PK_UserReportsAndCharts_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserReportsAndCharts]
  ADD CONSTRAINT [FK_UserReportsAndCharts_ReportsAndCharts_ID] FOREIGN KEY ([ReportsAndChartsID]) REFERENCES [dbo].[ReportsAndCharts] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UserReportsAndCharts]
  ADD CONSTRAINT [FK_UserReportsAndCharts_Users_ID] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'UserReportsAndCharts', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя', 'SCHEMA', N'dbo', 'TABLE', N'UserReportsAndCharts', 'COLUMN', N'UserID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор отчета', 'SCHEMA', N'dbo', 'TABLE', N'UserReportsAndCharts', 'COLUMN', N'ReportsAndChartsID'
GO