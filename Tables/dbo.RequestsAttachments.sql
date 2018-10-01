CREATE TABLE [dbo].[RequestsAttachments] (
  [ID] [int] IDENTITY,
  [Attachment] [varbinary](max) NOT NULL,
  [RequestID] [int] NOT NULL,
  [Description] [varchar](1000) NULL,
  [FileName] [varchar](255) NULL,
  [FileType] [int] NULL,
  CONSTRAINT [PK_RequestsAttachments_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[RequestsAttachments]
  ADD CONSTRAINT [FK_RequestsAttachemnts_Requests_ID] FOREIGN KEY ([RequestID]) REFERENCES [dbo].[Requests] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'RequestsAttachments', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тело вложения', 'SCHEMA', N'dbo', 'TABLE', N'RequestsAttachments', 'COLUMN', N'Attachment'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заявки', 'SCHEMA', N'dbo', 'TABLE', N'RequestsAttachments', 'COLUMN', N'RequestID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание', 'SCHEMA', N'dbo', 'TABLE', N'RequestsAttachments', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя файла', 'SCHEMA', N'dbo', 'TABLE', N'RequestsAttachments', 'COLUMN', N'FileName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип файла', 'SCHEMA', N'dbo', 'TABLE', N'RequestsAttachments', 'COLUMN', N'FileType'
GO