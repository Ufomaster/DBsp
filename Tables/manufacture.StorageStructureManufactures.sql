CREATE TABLE [manufacture].[StorageStructureManufactures] (
  [ID] [int] IDENTITY,
  [StorageStructureID] [smallint] NOT NULL,
  [ManufactureStructureID] [smallint] NOT NULL,
  [ProductionTasksStatusID] [tinyint] NOT NULL,
  [isMainManufacture] [bit] NULL,
  CONSTRAINT [PK_StorageStructureManufactures_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [manufacture].[StorageStructureManufactures]
  ADD CONSTRAINT [FK_StorageStructureManufactures_ManufactureStructure (manufacture)_ID] FOREIGN KEY ([ManufactureStructureID]) REFERENCES [manufacture].[ManufactureStructure] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [manufacture].[StorageStructureManufactures]
  ADD CONSTRAINT [FK_StorageStructureManufactures_ProductionTasksStatuses (manufacture)_ID] FOREIGN KEY ([ProductionTasksStatusID]) REFERENCES [manufacture].[ProductionTasksStatuses] ([ID])
GO

ALTER TABLE [manufacture].[StorageStructureManufactures]
  ADD CONSTRAINT [FK_StorageStructureManufactures_StorageStructure (storage)_ID] FOREIGN KEY ([StorageStructureID]) REFERENCES [manufacture].[StorageStructure] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureManufactures', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор структуры склада', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureManufactures', 'COLUMN', N'StorageStructureID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор производства', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureManufactures', 'COLUMN', N'ManufactureStructureID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус для изготавливаемой продукции', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureManufactures', 'COLUMN', N'ProductionTasksStatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг является ли данная мануфактура главной', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureManufactures', 'COLUMN', N'isMainManufacture'
GO