CREATE TABLE [shifts].[EmployeeGroupsPlan] (
  [ID] [int] IDENTITY,
  [Name] [varchar](100) NOT NULL,
  [StartDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [ShiftID] [int] NOT NULL,
  [EmployeeGroupsID] [int] NULL,
  CONSTRAINT [PK_EmployeeGroupsPlan_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [shifts].[EmployeeGroupsPlan]
  ADD CONSTRAINT [FK_EmployeeGroupsPlan_EmployeeGroups (shifts)_ID] FOREIGN KEY ([EmployeeGroupsID]) REFERENCES [shifts].[EmployeeGroups] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [shifts].[EmployeeGroupsPlan]
  ADD CONSTRAINT [FK_EmployeeGroupsPlan_Shifts (shifts)_ID] FOREIGN KEY ([ShiftID]) REFERENCES [shifts].[Shifts] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsPlan', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Плановое наименование бригады', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsPlan', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Плановая дата начала работы бригады', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsPlan', 'COLUMN', N'StartDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Плановая дата окончания работы бригады', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsPlan', 'COLUMN', N'EndDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифиатор запланированной смены', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsPlan', 'COLUMN', N'ShiftID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор шаблона бригады', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsPlan', 'COLUMN', N'EmployeeGroupsID'
GO