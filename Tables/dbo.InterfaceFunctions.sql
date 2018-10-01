CREATE TABLE [dbo].[InterfaceFunctions] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  [CallName] [varchar](30) NULL,
  [UseOkCancel] [bit] NULL,
  [FormWidth] [int] NULL,
  [FormHeight] [int] NULL,
  [Components] [xml] NULL,
  [ExecuteOkScript] [varchar](max) NULL,
  CONSTRAINT [PK__Interfac__3214EC27064E13D4] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'InterfaceFunctions', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'наименование фунцкции', 'SCHEMA', N'dbo', 'TABLE', N'InterfaceFunctions', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Англ наименование-константа для вызова из делфи', 'SCHEMA', N'dbo', 'TABLE', N'InterfaceFunctions', 'COLUMN', N'CallName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Использовать форму с Ок Отмена - 1, только отмена -0', 'SCHEMA', N'dbo', 'TABLE', N'InterfaceFunctions', 'COLUMN', N'UseOkCancel'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ширина', 'SCHEMA', N'dbo', 'TABLE', N'InterfaceFunctions', 'COLUMN', N'FormWidth'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Высота', 'SCHEMA', N'dbo', 'TABLE', N'InterfaceFunctions', 'COLUMN', N'FormHeight'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Компоненты и их настройки', 'SCHEMA', N'dbo', 'TABLE', N'InterfaceFunctions', 'COLUMN', N'Components'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Запрос для вызова после нажатия ОК', 'SCHEMA', N'dbo', 'TABLE', N'InterfaceFunctions', 'COLUMN', N'ExecuteOkScript'
GO