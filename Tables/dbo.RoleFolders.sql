CREATE TABLE [dbo].[RoleFolders] (
  [ID] [smallint] NOT NULL,
  [Name] [varchar](50) NULL,
  [ParentID] [smallint] NULL,
  CONSTRAINT [PK_RoleFolders_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'RoleFolders', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование папки', 'SCHEMA', N'dbo', 'TABLE', N'RoleFolders', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор родительского уровня', 'SCHEMA', N'dbo', 'TABLE', N'RoleFolders', 'COLUMN', N'ParentID'
GO