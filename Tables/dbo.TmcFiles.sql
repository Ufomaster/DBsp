CREATE TABLE [dbo].[TmcFiles] (
  [ID] [int] IDENTITY,
  [FileData] [varbinary](max) NULL,
  [FileType] [int] NOT NULL,
  [Comment] [varchar](255) NULL,
  [Date] [datetime] NOT NULL,
  [TmcID] [int] NULL,
  CONSTRAINT [PK_TmcFiles_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_TmcFiles_TmcID]
  ON [dbo].[TmcFiles] ([TmcID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[TmcFiles]
  ADD CONSTRAINT [FK_TmcFiles_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'TmcFiles', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Содержимое файла приложения к ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'TmcFiles', 'COLUMN', N'FileData'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип файла: 0-jpeg, 1-bmp, 2-png', 'SCHEMA', N'dbo', 'TABLE', N'TmcFiles', 'COLUMN', N'FileType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий к файлу', 'SCHEMA', N'dbo', 'TABLE', N'TmcFiles', 'COLUMN', N'Comment'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ДатаВремя изменения', 'SCHEMA', N'dbo', 'TABLE', N'TmcFiles', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'TmcFiles', 'COLUMN', N'TmcID'
GO