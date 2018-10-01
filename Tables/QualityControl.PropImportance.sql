CREATE TABLE [QualityControl].[PropImportance] (
  [ID] [tinyint] IDENTITY,
  [Name] [varchar](30) NOT NULL,
  [AttributeID] [int] NOT NULL,
  CONSTRAINT [PK_PropImportance_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[PropImportance]
  ADD CONSTRAINT [FK_PropImportance_Attributes_ID] FOREIGN KEY ([AttributeID]) REFERENCES [dbo].[Attributes] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'PropImportance', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'PropImportance', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор атрибута', 'SCHEMA', N'QualityControl', 'TABLE', N'PropImportance', 'COLUMN', N'AttributeID'
GO