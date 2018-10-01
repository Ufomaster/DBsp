CREATE TABLE [manufacture].[StorageStructureSectorsDetails] (
  [ID] [int] IDENTITY,
  [StorageStructureSectorID] [tinyint] NULL,
  [StorageStructureID] [smallint] NULL,
  CONSTRAINT [PK_StorageStructureSectorsDetails_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_StorageStructureSectorsDetails_StorageStructureID] UNIQUE ([StorageStructureID])
)
ON [PRIMARY]
GO

ALTER TABLE [manufacture].[StorageStructureSectorsDetails]
  ADD CONSTRAINT [FK_StorageStructureSectorsDetails_StorageStructure (manufacture)_ID] FOREIGN KEY ([StorageStructureID]) REFERENCES [manufacture].[StorageStructure] ([ID])
GO

ALTER TABLE [manufacture].[StorageStructureSectorsDetails] WITH NOCHECK
  ADD CONSTRAINT [FK_StorageStructureSectorsDetails_StorageStructureSectors (manufacture)_ID] FOREIGN KEY ([StorageStructureSectorID]) REFERENCES [manufacture].[StorageStructureSectors] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorsDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор участка', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorsDetails', 'COLUMN', N'StorageStructureSectorID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор рабочего места в участке', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorsDetails', 'COLUMN', N'StorageStructureID'
GO