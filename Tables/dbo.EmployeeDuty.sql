CREATE TABLE [dbo].[EmployeeDuty] (
  [ID] [int] IDENTITY,
  [EmployeeID] [int] NOT NULL,
  [Date] [datetime] NOT NULL,
  CONSTRAINT [PK_EmployeeDuty_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UQ_EmployeeDuty_EmployeeID_Date]
  ON [dbo].[EmployeeDuty] ([EmployeeID], [Date])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[EmployeeDuty]
  ADD CONSTRAINT [FK_EmployeeDuty_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'EmployeeDuty', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника', 'SCHEMA', N'dbo', 'TABLE', N'EmployeeDuty', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата дежурства', 'SCHEMA', N'dbo', 'TABLE', N'EmployeeDuty', 'COLUMN', N'Date'
GO