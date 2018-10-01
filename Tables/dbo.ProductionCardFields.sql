CREATE TABLE [dbo].[ProductionCardFields] (
  [colid] [int] NOT NULL,
  [Name] [varchar](50) NULL,
  [Value] [varchar](255) NULL,
  [BlockID] [smallint] NULL,
  [QCOnly] [bit] NULL,
  [DataTypeCastToText] [varchar](255) NULL,
  CONSTRAINT [PK_ProductionCardFields_colid] PRIMARY KEY CLUSTERED ([colid])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', 'select * from sys.columns where object_id = (select object_ID from sys.objects where name = ''ProductionCardCustomize'')', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardFields', 'COLUMN', N'colid'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'имя поля бд', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardFields', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardFields', 'COLUMN', N'Value'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Условная группировка для сортировки списка полей', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardFields', 'COLUMN', N'BlockID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Только для видимости в настройках протоколов ОКК', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardFields', 'COLUMN', N'QCOnly'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Запрос для конвертации данных этого поля в текст', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardFields', 'COLUMN', N'DataTypeCastToText'
GO