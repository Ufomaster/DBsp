CREATE TABLE [dbo].[ObjectTypesSectors] (
  [ID] [int] IDENTITY,
  [ObjectTypeID] [int] NOT NULL,
  [SectorID] [tinyint] NOT NULL,
  CONSTRAINT [PK_ObjectTypesSectors_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_ObjectTypesSectors_ObjectTypeID_SectorID] UNIQUE ([ObjectTypeID], [SectorID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ObjectTypesSectors]
  ADD CONSTRAINT [FK_ObjectTypesSectors_ObjectTypes_ID] FOREIGN KEY ([ObjectTypeID]) REFERENCES [dbo].[ObjectTypes] ([ID])
GO

ALTER TABLE [dbo].[ObjectTypesSectors]
  ADD CONSTRAINT [FK_ObjectTypesSectors_StorageStructureSectors_ID] FOREIGN KEY ([SectorID]) REFERENCES [manufacture].[StorageStructureSectors] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesSectors', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор группы тмц', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesSectors', 'COLUMN', N'ObjectTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор участка', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesSectors', 'COLUMN', N'SectorID'
GO