CREATE TABLE [dbo].[Roles] (
  [ID] [int] IDENTITY,
  [Name] [varchar](50) NOT NULL,
  [isFolder] [bit] NULL,
  [ParentID] [int] NULL,
  CONSTRAINT [PK_Roles_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Roles]
  ADD CONSTRAINT [FK_Roles_Roles_ID] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[Roles] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Роли', 'SCHEMA', N'dbo', 'TABLE', N'Roles'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Roles', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'Roles', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг папки ролей 1 - папка 0 - роль', 'SCHEMA', N'dbo', 'TABLE', N'Roles', 'COLUMN', N'isFolder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на предка в иерархии объектов', 'SCHEMA', N'dbo', 'TABLE', N'Roles', 'COLUMN', N'ParentID'
GO