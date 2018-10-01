CREATE TABLE [dbo].[TechSupportElements] (
  [ID] [int] IDENTITY,
  [Name] [varchar](1000) NOT NULL,
  [Comment] [varchar](max) NULL,
  CONSTRAINT [PK_TechSupportElements_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Фактически ТО 0 для операторов.', 'SCHEMA', N'dbo', 'TABLE', N'TechSupportElements'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'TechSupportElements', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание элемента контроля', 'SCHEMA', N'dbo', 'TABLE', N'TechSupportElements', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Инструкция к работе', 'SCHEMA', N'dbo', 'TABLE', N'TechSupportElements', 'COLUMN', N'Comment'
GO