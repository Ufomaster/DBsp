CREATE TABLE [dbo].[ReportsAndChartsLaunchLog] (
  [ID] [int] IDENTITY,
  [ReportsAndChartsID] [int] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  [Date] [datetime] NOT NULL,
  CONSTRAINT [PK_ReportsAndChartsLaunchLog_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.ReportsAndChartsLaunchLog.Date'
GO

ALTER TABLE [dbo].[ReportsAndChartsLaunchLog]
  ADD CONSTRAINT [FK_ReportsAndChartsLaunchLog_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[ReportsAndChartsLaunchLog]
  ADD CONSTRAINT [FK_ReportsAndChartsLaunchLog_ReportsAndCharts_ID] FOREIGN KEY ([ReportsAndChartsID]) REFERENCES [dbo].[ReportsAndCharts] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsLaunchLog', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор запускаемого отчета', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsLaunchLog', 'COLUMN', N'ReportsAndChartsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника который запустил отчет', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsLaunchLog', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата запуска', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsLaunchLog', 'COLUMN', N'Date'
GO