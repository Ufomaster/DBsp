CREATE TABLE [QualityControl].[ReasonsClasses] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  CONSTRAINT [PK_ReasonsClasses_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ReasonsClasses', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'ReasonsClasses', 'COLUMN', N'Name'
GO