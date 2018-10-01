CREATE TABLE [dbo].[EquipmentEmployee] (
  [ID] [int] IDENTITY,
  [EquipmentID] [int] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  [XLeft] [int] NULL,
  [XTop] [int] NULL,
  CONSTRAINT [PK_EquipmentEmployee_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[EquipmentEmployee]
  ADD CONSTRAINT [FK_EquipmentEmployee_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[EquipmentEmployee]
  ADD CONSTRAINT [FK_EquipmentEmployee_Equipment_ID] FOREIGN KEY ([EquipmentID]) REFERENCES [dbo].[Equipment] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Фактически это получается таблица с доступом конкретных челов к конкретному оборудованию', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentEmployee'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentEmployee', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор оборудования', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentEmployee', 'COLUMN', N'EquipmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentEmployee', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Координата слева', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentEmployee', 'COLUMN', N'XLeft'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Координата справа', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentEmployee', 'COLUMN', N'XTop'
GO