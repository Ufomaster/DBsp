CREATE TABLE [QualityControl].[ActsMainReason] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  CONSTRAINT [PK_ActsMainReason_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsMainReason', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsMainReason', 'COLUMN', N'Name'
GO