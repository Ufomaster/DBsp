CREATE TABLE [dbo].[UserSectors] (
  [ID] [int] IDENTITY,
  [UserID] [int] NULL,
  [SectorID] [tinyint] NULL,
  CONSTRAINT [PK_UserSectors_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserSectors] WITH NOCHECK
  ADD CONSTRAINT [FK_UserSectors_StorageStructureSectors_ID] FOREIGN KEY ([SectorID]) REFERENCES [manufacture].[StorageStructureSectors] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UserSectors]
  ADD CONSTRAINT [FK_UserSectors_Users_ID] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'UserSectors', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя', 'SCHEMA', N'dbo', 'TABLE', N'UserSectors', 'COLUMN', N'UserID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сектора', 'SCHEMA', N'dbo', 'TABLE', N'UserSectors', 'COLUMN', N'SectorID'
GO