CREATE TABLE [dbo].[PrintOrient] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NOT NULL,
  [isDeleted] [bit] NULL,
  [PCCIDInputEnabled] [bit] NULL,
  [SortOrder] [tinyint] NULL,
  CONSTRAINT [PK_PrintOrient_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'PrintOrient', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'PrintOrient', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1- Удалено, иначе используется', 'SCHEMA', N'dbo', 'TABLE', N'PrintOrient', 'COLUMN', N'isDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1-Доступен ввод № ЗЛ', 'SCHEMA', N'dbo', 'TABLE', N'PrintOrient', 'COLUMN', N'PCCIDInputEnabled'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок сортировки', 'SCHEMA', N'dbo', 'TABLE', N'PrintOrient', 'COLUMN', N'SortOrder'
GO