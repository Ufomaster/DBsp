CREATE TABLE [dbo].[RequestTargetEmployees] (
  [ID] [smallint] IDENTITY,
  [EmployeeID] [int] NOT NULL,
  [RequestTargetID] [tinyint] NOT NULL,
  CONSTRAINT [PK_RequestTargetEmployees_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[RequestTargetEmployees]
  ADD CONSTRAINT [FK_RequestTargetEmployees_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[RequestTargetEmployees]
  ADD CONSTRAINT [FK_RequestTargetEmployees_RequestTarget_ID] FOREIGN KEY ([RequestTargetID]) REFERENCES [dbo].[RequestTarget] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'RequestTargetEmployees', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника', 'SCHEMA', N'dbo', 'TABLE', N'RequestTargetEmployees', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор целевого департамента заявки', 'SCHEMA', N'dbo', 'TABLE', N'RequestTargetEmployees', 'COLUMN', N'RequestTargetID'
GO