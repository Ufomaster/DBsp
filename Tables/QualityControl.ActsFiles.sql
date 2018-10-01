CREATE TABLE [QualityControl].[ActsFiles] (
  [ID] [int] IDENTITY,
  [ActsID] [int] NOT NULL,
  [FileName] [varchar](255) NULL,
  [FileData] [varbinary](max) NULL,
  [FileDataThumb] [varbinary](max) NULL,
  CONSTRAINT [PK_ActsFiles_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActsFiles]
  ADD CONSTRAINT [FK_ActsFiles_Acts (QualityControl)_ID] FOREIGN KEY ([ActsID]) REFERENCES [QualityControl].[Acts] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsFiles', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsFiles', 'COLUMN', N'ActsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя файла', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsFiles', 'COLUMN', N'FileName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Данные файла', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsFiles', 'COLUMN', N'FileData'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Превью', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsFiles', 'COLUMN', N'FileDataThumb'
GO