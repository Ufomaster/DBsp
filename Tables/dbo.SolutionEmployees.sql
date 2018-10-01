CREATE TABLE [dbo].[SolutionEmployees] (
  [ID] [int] IDENTITY,
  [SolutionID] [int] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  CONSTRAINT [PK_SolutionEmployees_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[SolutionEmployees]
  ADD CONSTRAINT [FK_SolutionEmployees_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SolutionEmployees]
  ADD CONSTRAINT [FK_SolutionEmployees_Solutions_ID] FOREIGN KEY ([SolutionID]) REFERENCES [dbo].[Solutions] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'SolutionEmployees', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор работы', 'SCHEMA', N'dbo', 'TABLE', N'SolutionEmployees', 'COLUMN', N'SolutionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника', 'SCHEMA', N'dbo', 'TABLE', N'SolutionEmployees', 'COLUMN', N'EmployeeID'
GO