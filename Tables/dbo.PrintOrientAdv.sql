CREATE TABLE [dbo].[PrintOrientAdv] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NOT NULL,
  [SortOrder] [tinyint] NULL,
  CONSTRAINT [PK_PrintOrientAdv_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'PrintOrientAdv', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'PrintOrientAdv', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок сортировки', 'SCHEMA', N'dbo', 'TABLE', N'PrintOrientAdv', 'COLUMN', N'SortOrder'
GO