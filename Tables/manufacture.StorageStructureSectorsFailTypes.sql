CREATE TABLE [manufacture].[StorageStructureSectorsFailTypes] (
  [ID] [int] IDENTITY,
  [StorageStructureSectorID] [tinyint] NULL,
  [FailTypeID] [int] NULL,
  CONSTRAINT [PK_StorageStructureSectorsFailTypes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [manufacture].[StorageStructureSectorsFailTypes]
  ADD CONSTRAINT [FK_StorageStructureSectorsFailTypes_FailTypes (manufacture)_ID] FOREIGN KEY ([FailTypeID]) REFERENCES [manufacture].[FailTypes] ([ID])
GO

ALTER TABLE [manufacture].[StorageStructureSectorsFailTypes] WITH NOCHECK
  ADD CONSTRAINT [FK_StorageStructureSectorsFailTypes_StorageStructureSectors (manufacture)_ID] FOREIGN KEY ([StorageStructureSectorID]) REFERENCES [manufacture].[StorageStructureSectors] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorsFailTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор участка', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorsFailTypes', 'COLUMN', N'StorageStructureSectorID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор Типа брака', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorsFailTypes', 'COLUMN', N'FailTypeID'
GO