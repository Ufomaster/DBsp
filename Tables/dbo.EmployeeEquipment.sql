CREATE TABLE [dbo].[EmployeeEquipment] (
  [ID] [int] IDENTITY,
  [EmployeeID] [int] NOT NULL,
  [EquipmentID] [int] NOT NULL,
  CONSTRAINT [PK_EmployeeEquipment_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_Employee_EquipmentID] UNIQUE ([EquipmentID], [EmployeeID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[EmployeeEquipment]
  ADD CONSTRAINT [FK_EmployeeEquipment_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[EmployeeEquipment]
  ADD CONSTRAINT [FK_EmployeeEquipment_Equipment_ID] FOREIGN KEY ([EquipmentID]) REFERENCES [dbo].[Equipment] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'EmployeeEquipment', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника', 'SCHEMA', N'dbo', 'TABLE', N'EmployeeEquipment', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ОС', 'SCHEMA', N'dbo', 'TABLE', N'EmployeeEquipment', 'COLUMN', N'EquipmentID'
GO