CREATE TABLE [shifts].[EmployeeGroupsDetails] (
  [ID] [int] IDENTITY,
  [EmployeeGroupID] [int] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  [WorkPlaceID] [smallint] NULL,
  CONSTRAINT [PK_EmployeeGroupsDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [shifts].[EmployeeGroupsDetails]
  ADD CONSTRAINT [FK_EmployeeGroupsDetails_EmployeeGroups_ID] FOREIGN KEY ([EmployeeGroupID]) REFERENCES [shifts].[EmployeeGroups] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [shifts].[EmployeeGroupsDetails]
  ADD CONSTRAINT [FK_EmployeeGroupsDetails_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [shifts].[EmployeeGroupsDetails]
  ADD CONSTRAINT [FK_EmployeeGroupsDetails_StorageStructure (manufacture)_ID] FOREIGN KEY ([WorkPlaceID]) REFERENCES [manufacture].[StorageStructure] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор бригады', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsDetails', 'COLUMN', N'EmployeeGroupID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsDetails', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор рабочего места', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsDetails', 'COLUMN', N'WorkPlaceID'
GO