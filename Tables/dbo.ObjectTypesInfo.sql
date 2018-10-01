CREATE TABLE [dbo].[ObjectTypesInfo] (
  [ID] [int] IDENTITY,
  [UserID] [int] NOT NULL,
  [NodeState] [bit] NULL,
  [ObjectTypeID] [int] NOT NULL,
  CONSTRAINT [PK_ObjectTypesInfo_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ObjectTypesInfo_ObjectTypeID]
  ON [dbo].[ObjectTypesInfo] ([ObjectTypeID], [UserID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ObjectTypesInfo]
  ADD CONSTRAINT [FK_ObjectTypesInfo_ObjectTypes_ID] FOREIGN KEY ([ObjectTypeID]) REFERENCES [dbo].[ObjectTypes] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ObjectTypesInfo]
  ADD CONSTRAINT [FK_ObjectTypesInfo_Users_ID] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesInfo', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesInfo', 'COLUMN', N'UserID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние ноды дерева. Свёрнута - 0, развёрнута - 1', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesInfo', 'COLUMN', N'NodeState'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа объекта тмц', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesInfo', 'COLUMN', N'ObjectTypeID'
GO