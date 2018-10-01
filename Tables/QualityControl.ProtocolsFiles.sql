CREATE TABLE [QualityControl].[ProtocolsFiles] (
  [ID] [int] IDENTITY,
  [ProtocolID] [int] NOT NULL,
  [FileName] [varchar](255) NULL,
  [FileData] [varbinary](max) NULL,
  [FileDataThumb] [varbinary](max) NULL,
  CONSTRAINT [PK_ProtocolsFiles_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ProtocolsFiles]
  ADD CONSTRAINT [FK_ProtocolsFiles_Protocols (QualityControl)_ID] FOREIGN KEY ([ProtocolID]) REFERENCES [QualityControl].[Protocols] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsFiles', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsFiles', 'COLUMN', N'ProtocolID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя файла', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsFiles', 'COLUMN', N'FileName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Данные файла', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsFiles', 'COLUMN', N'FileData'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Превью', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsFiles', 'COLUMN', N'FileDataThumb'
GO