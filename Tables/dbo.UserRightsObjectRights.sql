CREATE TABLE [dbo].[UserRightsObjectRights] (
  [ID] [int] IDENTITY,
  [ObjectID] [int] NOT NULL,
  [RightValue] [int] NOT NULL,
  [RoleID] [int] NOT NULL,
  CONSTRAINT [PK_UserRightsObjectRights_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_UserRightsObjectRights_ObjectID_RoleID]
  ON [dbo].[UserRightsObjectRights] ([ObjectID], [RoleID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_UserRightsObjectRights_RoleID]
  ON [dbo].[UserRightsObjectRights] ([RoleID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserRightsObjectRights]
  ADD CONSTRAINT [FK_UserRightsObjectRights_Objects] FOREIGN KEY ([ObjectID]) REFERENCES [dbo].[UserRightsObjects] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UserRightsObjectRights]
  ADD CONSTRAINT [FK_UserRightsObjectRights_Roles_ID] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Roles] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[UserRightsObjectRights]
  ADD CONSTRAINT [FK_UserRightsObjectRights_UserRightsValues_ID] FOREIGN KEY ([RightValue]) REFERENCES [dbo].[UserRightsValues] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Права на объекты', 'SCHEMA', N'dbo', 'TABLE', N'UserRightsObjectRights'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'UserRightsObjectRights', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор объекта', 'SCHEMA', N'dbo', 'TABLE', N'UserRightsObjectRights', 'COLUMN', N'ObjectID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор значения права доступа', 'SCHEMA', N'dbo', 'TABLE', N'UserRightsObjectRights', 'COLUMN', N'RightValue'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор роли', 'SCHEMA', N'dbo', 'TABLE', N'UserRightsObjectRights', 'COLUMN', N'RoleID'
GO