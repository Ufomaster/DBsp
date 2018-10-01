CREATE TABLE [dbo].[EquipmentTechSupportList] (
  [ID] [int] IDENTITY,
  [EquipmentID] [int] NOT NULL,
  [TechSupportElementID] [int] NOT NULL,
  CONSTRAINT [PK_EquipmentTSList_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_EquipmentTechSupportList_EquipmentID_TechSupportElementID] UNIQUE ([EquipmentID], [TechSupportElementID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[EquipmentTechSupportList]
  ADD CONSTRAINT [FK_EquipmentTSList_Equipment_ID] FOREIGN KEY ([EquipmentID]) REFERENCES [dbo].[Equipment] ([ID])
GO

ALTER TABLE [dbo].[EquipmentTechSupportList]
  ADD CONSTRAINT [FK_EquipmentTSList_TechSupportElements_ID] FOREIGN KEY ([TechSupportElementID]) REFERENCES [dbo].[TechSupportElements] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentTechSupportList', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор оборудования', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentTechSupportList', 'COLUMN', N'EquipmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор элемента контроля', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentTechSupportList', 'COLUMN', N'TechSupportElementID'
GO