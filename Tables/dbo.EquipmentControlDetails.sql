CREATE TABLE [dbo].[EquipmentControlDetails] (
  [ID] [int] IDENTITY,
  [TechSupportElementID] [int] NOT NULL,
  [Status] [bit] NOT NULL,
  [EquipmentControlID] [int] NOT NULL,
  CONSTRAINT [PK_EquipmentControlDetails] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_EquipmentControlDetails_TechSupportElementID_EquipmentControlID] UNIQUE ([TechSupportElementID], [EquipmentControlID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[EquipmentControlDetails]
  ADD CONSTRAINT [FK_EquipmentControlDetails_EquipmentControl_ID] FOREIGN KEY ([EquipmentControlID]) REFERENCES [dbo].[EquipmentControl] ([ID])
GO

ALTER TABLE [dbo].[EquipmentControlDetails]
  ADD CONSTRAINT [FK_EquipmentControlDetails_TechSupportElements_ID] FOREIGN KEY ([TechSupportElementID]) REFERENCES [dbo].[TechSupportElements] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControlDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТО оборудования', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControlDetails', 'COLUMN', N'TechSupportElementID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние 0-не пройдено, 1- пройдено', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControlDetails', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор точки контроля оборудования', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControlDetails', 'COLUMN', N'EquipmentControlID'
GO