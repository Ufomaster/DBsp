CREATE TABLE [dbo].[SolutionsDeclaredGroups] (
  [ID] [int] IDENTITY,
  [Name] [varchar](100) NOT NULL,
  [DepartmentID] [int] NOT NULL,
  CONSTRAINT [PK_SolutionDeclaredGroups_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[SolutionsDeclaredGroups]
  ADD CONSTRAINT [FK_SolutionsDeclaredGroups_Departments_ID] FOREIGN KEY ([DepartmentID]) REFERENCES [dbo].[Departments] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclaredGroups', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование группы работ', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclaredGroups', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор технического подразделения к которому относится ТО', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclaredGroups', 'COLUMN', N'DepartmentID'
GO