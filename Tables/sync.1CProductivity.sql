CREATE TABLE [sync].[1CProductivity] (
  [ID] [int] IDENTITY,
  [Status] [int] NOT NULL,
  [DocNumber] [varchar](20) NULL,
  [ModifyDate] [datetime] NOT NULL,
  [DocDate] [datetime] NULL,
  [ErrorText] [varchar](800) NULL,
  [DepartmentCode1C] [varchar](36) NULL,
  [Comments] [varchar](800) NULL,
  CONSTRAINT [PK_1CProductivity_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.[1CProductivity].ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CProductivity', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'0-загружается, 1-готово к обработке1с, 2-обработано, 3-ошибка.', 'SCHEMA', N'sync', 'TABLE', N'1CProductivity', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'номер документа  в 1с', 'SCHEMA', N'sync', 'TABLE', N'1CProductivity', 'COLUMN', N'DocNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата последних изменений', 'SCHEMA', N'sync', 'TABLE', N'1CProductivity', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'дата документа  в 1с', 'SCHEMA', N'sync', 'TABLE', N'1CProductivity', 'COLUMN', N'DocDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'текст ошибки', 'SCHEMA', N'sync', 'TABLE', N'1CProductivity', 'COLUMN', N'ErrorText'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Гуид 1с для поля производство', 'SCHEMA', N'sync', 'TABLE', N'1CProductivity', 'COLUMN', N'DepartmentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'sync', 'TABLE', N'1CProductivity', 'COLUMN', N'Comments'
GO