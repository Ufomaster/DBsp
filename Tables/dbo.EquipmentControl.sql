CREATE TABLE [dbo].[EquipmentControl] (
  [ID] [int] IDENTITY,
  [EquipmentID] [int] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  [StatusID] [int] NOT NULL,
  CONSTRAINT [PK_EquipmentControl_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[EquipmentControl]
  ADD CONSTRAINT [FK_EquipmentControl_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[EquipmentControl]
  ADD CONSTRAINT [FK_EquipmentControl_Equipment_ID] FOREIGN KEY ([EquipmentID]) REFERENCES [dbo].[Equipment] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControl', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор оборудования', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControl', 'COLUMN', N'EquipmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ответственного за оборудование сотрудника', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControl', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние 0-offline 1-online', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControl', 'COLUMN', N'StatusID'
GO