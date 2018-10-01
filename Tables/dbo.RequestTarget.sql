CREATE TABLE [dbo].[RequestTarget] (
  [ID] [tinyint] IDENTITY,
  [Name] [varchar](255) NULL,
  CONSTRAINT [PK_RequestTarget_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'RequestTarget', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'RequestTarget', 'COLUMN', N'Name'
GO