CREATE TABLE [shifts].[EmployeeGroupsFactDetais] (
  [ID] [int] IDENTITY,
  [EmployeeGroupsFactID] [int] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  [IsDeleted] [bit] NULL,
  CONSTRAINT [PK_EmployeeGroupsFactDetais_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_EmployeeGroupsFactDetais_EmployeeGroupsFactID]
  ON [shifts].[EmployeeGroupsFactDetais] ([EmployeeGroupsFactID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_EmployeeGroupsFactDetais_EmployeeID]
  ON [shifts].[EmployeeGroupsFactDetais] ([EmployeeID])
  ON [PRIMARY]
GO

ALTER TABLE [shifts].[EmployeeGroupsFactDetais]
  ADD CONSTRAINT [FK_EmployeeGroupsFactDetais_EmployeeGroupsFact (shifts)_ID] FOREIGN KEY ([EmployeeGroupsFactID]) REFERENCES [shifts].[EmployeeGroupsFact] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [shifts].[EmployeeGroupsFactDetais]
  ADD CONSTRAINT [FK_EmployeeGroupsFactDetais_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsFactDetais', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор группы-бригады', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsFactDetais', 'COLUMN', N'EmployeeGroupsFactID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsFactDetais', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пометка удаления', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsFactDetais', 'COLUMN', N'IsDeleted'
GO