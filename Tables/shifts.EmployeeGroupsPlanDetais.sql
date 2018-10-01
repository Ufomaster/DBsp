CREATE TABLE [shifts].[EmployeeGroupsPlanDetais] (
  [ID] [int] IDENTITY,
  [EmployeeGroupID] [int] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  CONSTRAINT [PK_EmployeeGroupsPlanDetais_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [shifts].[EmployeeGroupsPlanDetais]
  ADD CONSTRAINT [FK_EmployeeGroupsPlanDetais_EmployeeGroups_ID] FOREIGN KEY ([EmployeeGroupID]) REFERENCES [shifts].[EmployeeGroupsPlan] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [shifts].[EmployeeGroupsPlanDetais]
  ADD CONSTRAINT [FK_EmployeeGroupsPlanDetais_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsPlanDetais', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор бригады', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsPlanDetais', 'COLUMN', N'EmployeeGroupID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор сотрудника', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsPlanDetais', 'COLUMN', N'EmployeeID'
GO