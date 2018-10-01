CREATE TABLE [dbo].[EquipmentPlaces] (
  [ID] [int] IDENTITY,
  [Name] [varchar](50) NOT NULL,
  CONSTRAINT [PK_EquipmentPlaces_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_EquipmentPlaces_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentPlaces', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название места', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentPlaces', 'COLUMN', N'Name'
GO