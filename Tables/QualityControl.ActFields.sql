CREATE TABLE [QualityControl].[ActFields] (
  [ID] [smallint] IDENTITY,
  [Name] [varchar](65) NOT NULL,
  [Type] [tinyint] NOT NULL,
  CONSTRAINT [PK_ActFields_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActFields', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'ActFields', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вид данных поля: 
0 - произвольный текст, 
1 - справочник решений,
2 - справочник причин,
3 - дата подписи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActFields', 'COLUMN', N'Type'
GO