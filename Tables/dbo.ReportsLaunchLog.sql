CREATE TABLE [dbo].[ReportsLaunchLog] (
  [ID] [int] IDENTITY,
  [ReportID] [int] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  [Date] [datetime] NOT NULL,
  CONSTRAINT [PK_ReportsLaunchLog_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.ReportsLaunchLog.Date'
GO

ALTER TABLE [dbo].[ReportsLaunchLog]
  ADD CONSTRAINT [FK_ReportsLaunchLog_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[ReportsLaunchLog]
  ADD CONSTRAINT [FK_ReportsLaunchLog_Report_ID] FOREIGN KEY ([ReportID]) REFERENCES [dbo].[Reports] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ReportsLaunchLog', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор запускаемого отчета', 'SCHEMA', N'dbo', 'TABLE', N'ReportsLaunchLog', 'COLUMN', N'ReportID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника который запустил отчет', 'SCHEMA', N'dbo', 'TABLE', N'ReportsLaunchLog', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата запуска', 'SCHEMA', N'dbo', 'TABLE', N'ReportsLaunchLog', 'COLUMN', N'Date'
GO