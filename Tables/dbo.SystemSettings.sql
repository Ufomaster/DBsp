CREATE TABLE [dbo].[SystemSettings] (
  [ID] [smallint] NOT NULL,
  [Name] [varchar](255) NOT NULL,
  [NumericValue] [decimal](24, 8) NULL,
  [StringValue] [varchar](255) NULL,
  [ValueType] [int] NOT NULL,
  CONSTRAINT [PK_SystemSettings_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'SystemSettings', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование настройки', 'SCHEMA', N'dbo', 'TABLE', N'SystemSettings', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Числовое значение', 'SCHEMA', N'dbo', 'TABLE', N'SystemSettings', 'COLUMN', N'NumericValue'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Строковое значение', 'SCHEMA', N'dbo', 'TABLE', N'SystemSettings', 'COLUMN', N'StringValue'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип результирующего значения 0 -число, 1 строка', 'SCHEMA', N'dbo', 'TABLE', N'SystemSettings', 'COLUMN', N'ValueType'
GO