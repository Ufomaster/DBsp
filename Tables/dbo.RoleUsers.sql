CREATE TABLE [dbo].[RoleUsers] (
  [ID] [int] IDENTITY,
  [RoleID] [int] NOT NULL,
  [UserID] [int] NOT NULL,
  CONSTRAINT [PK_RoleUsers_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_RoleUsers_RoleIDUserID] UNIQUE ([RoleID], [UserID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[RoleUsers]
  ADD CONSTRAINT [FK_RoleUsers_Roles] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Roles] ([ID])
GO

ALTER TABLE [dbo].[RoleUsers]
  ADD CONSTRAINT [FK_RoleUsers_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пользователи по ролям', 'SCHEMA', N'dbo', 'TABLE', N'RoleUsers'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'RoleUsers', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор роли', 'SCHEMA', N'dbo', 'TABLE', N'RoleUsers', 'COLUMN', N'RoleID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя', 'SCHEMA', N'dbo', 'TABLE', N'RoleUsers', 'COLUMN', N'UserID'
GO