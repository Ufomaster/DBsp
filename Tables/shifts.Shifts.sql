CREATE TABLE [shifts].[Shifts] (
  [ID] [int] IDENTITY,
  [ShiftTypeID] [tinyint] NOT NULL,
  [PlanStartDate] [datetime] NULL,
  [PlanEndDate] [datetime] NULL,
  [FactStartDate] [datetime] NULL,
  [FactEndDate] [datetime] NULL,
  [IsDeleted] [bit] NULL,
  [Sign1EmployeeID] [int] NULL,
  [Sign2EmployeeID] [int] NULL,
  [Sign1Date] [datetime] NULL,
  [Sign2Date] [datetime] NULL,
  [isBlocked] [bit] NULL,
  CONSTRAINT [PK_Shifts_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_Shifts_FactEndDate]
  ON [shifts].[Shifts] ([FactEndDate])
  ON [PRIMARY]
GO

ALTER INDEX [IDX_Shifts_FactEndDate] ON [shifts].[Shifts] DISABLE
GO

CREATE INDEX [IDX_Shifts_FactStartDate]
  ON [shifts].[Shifts] ([FactStartDate])
  ON [PRIMARY]
GO

ALTER INDEX [IDX_Shifts_FactStartDate] ON [shifts].[Shifts] DISABLE
GO

CREATE INDEX [IDX_Shifts_FactStartDate_FactEndDate_IsDeleted]
  ON [shifts].[Shifts] ([FactStartDate], [FactEndDate], [IsDeleted])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Shifts_PlanEndDate]
  ON [shifts].[Shifts] ([PlanEndDate])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Shifts_PlanStartDate]
  ON [shifts].[Shifts] ([PlanStartDate])
  ON [PRIMARY]
GO

ALTER TABLE [shifts].[Shifts]
  ADD CONSTRAINT [FK_Shifts_Employees_ID1] FOREIGN KEY ([Sign1EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [shifts].[Shifts]
  ADD CONSTRAINT [FK_Shifts_Employees_ID2] FOREIGN KEY ([Sign2EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [shifts].[Shifts]
  ADD CONSTRAINT [FK_Shifts_ShiftsTypes (shifts)_ID] FOREIGN KEY ([ShiftTypeID]) REFERENCES [shifts].[ShiftsTypes] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'Shifts', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа смены', 'SCHEMA', N'shifts', 'TABLE', N'Shifts', 'COLUMN', N'ShiftTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Плановая дата начала выхода смены', 'SCHEMA', N'shifts', 'TABLE', N'Shifts', 'COLUMN', N'PlanStartDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Плановая дата окончания выхода смены', 'SCHEMA', N'shifts', 'TABLE', N'Shifts', 'COLUMN', N'PlanEndDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Фактическая дата начала выхода смены', 'SCHEMA', N'shifts', 'TABLE', N'Shifts', 'COLUMN', N'FactStartDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Фактическая дата окончания выхода смены', 'SCHEMA', N'shifts', 'TABLE', N'Shifts', 'COLUMN', N'FactEndDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ПОметка удаления', 'SCHEMA', N'shifts', 'TABLE', N'Shifts', 'COLUMN', N'IsDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника подписи 1', 'SCHEMA', N'shifts', 'TABLE', N'Shifts', 'COLUMN', N'Sign1EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника подписи 2', 'SCHEMA', N'shifts', 'TABLE', N'Shifts', 'COLUMN', N'Sign2EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата подписи 1', 'SCHEMA', N'shifts', 'TABLE', N'Shifts', 'COLUMN', N'Sign1Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата подписи 2', 'SCHEMA', N'shifts', 'TABLE', N'Shifts', 'COLUMN', N'Sign2Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг блокировки смены 0 не заблокирована, 1 -заблокирована', 'SCHEMA', N'shifts', 'TABLE', N'Shifts', 'COLUMN', N'isBlocked'
GO