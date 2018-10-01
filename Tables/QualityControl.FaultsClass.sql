CREATE TABLE [QualityControl].[FaultsClass] (
  [ID] [int] IDENTITY,
  [Code] [int] NOT NULL,
  [Name] [varchar](255) NULL,
  CONSTRAINT [PK_FaultsClass_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'FaultsClass', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код', 'SCHEMA', N'QualityControl', 'TABLE', N'FaultsClass', 'COLUMN', N'Code'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'FaultsClass', 'COLUMN', N'Name'
GO