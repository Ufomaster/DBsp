CREATE TABLE [dbo].[RoleStorageStructure] (
  [ID] [int] IDENTITY,
  [RoleID] [int] NOT NULL,
  [StorageStructureID] [int] NOT NULL,
  CONSTRAINT [PK_RoleStorageStructure_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'RoleStorageStructure', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор роли', 'SCHEMA', N'dbo', 'TABLE', N'RoleStorageStructure', 'COLUMN', N'RoleID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор склада', 'SCHEMA', N'dbo', 'TABLE', N'RoleStorageStructure', 'COLUMN', N'StorageStructureID'
GO