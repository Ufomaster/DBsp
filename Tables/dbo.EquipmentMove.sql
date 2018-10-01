CREATE TABLE [dbo].[EquipmentMove] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  [EquipmentID] [int] NOT NULL,
  [DepartmentName] [varchar](100) NULL,
  [PositionName] [varchar](100) NULL,
  [FromPlace] [varchar](50) NULL,
  [ToPlace] [varchar](50) NULL,
  [FromEmployee] [varchar](100) NULL,
  [ToEmployee] [varchar](100) NULL,
  CONSTRAINT [PK_EquipmentMove_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[EquipmentMove]
  ADD CONSTRAINT [FK_DepartmentPositionsEquipment_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[EquipmentMove]
  ADD CONSTRAINT [FK_DepartmentPositionsEquipment_Equipment_ID] FOREIGN KEY ([EquipmentID]) REFERENCES [dbo].[Equipment] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentMove', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата события', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentMove', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника выполнившего перемещение', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentMove', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор оборудования', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentMove', 'COLUMN', N'EquipmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Департамент с которого выполнилось перемещение', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentMove', 'COLUMN', N'DepartmentName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Должность с которой выполнилось перемещение', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentMove', 'COLUMN', N'PositionName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'местоположения откуда переместили', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentMove', 'COLUMN', N'FromPlace'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'местоположения куда переместили', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentMove', 'COLUMN', N'ToPlace'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'сотрудник, который был назначен на исходную должность в момент перемещения', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentMove', 'COLUMN', N'FromEmployee'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'сотрудник, который был назначен на исходную должность в момент перемещения', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentMove', 'COLUMN', N'ToEmployee'
GO