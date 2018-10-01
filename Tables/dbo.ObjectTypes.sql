CREATE TABLE [dbo].[ObjectTypes] (
  [ID] [int] NOT NULL,
  [ParentID] [int] NULL,
  [Name] [varchar](100) NOT NULL,
  [NodeOrder] [int] NULL,
  [NodeImageIndex] [int] NULL,
  [XMLSchema] [xml] NULL,
  [Type] [int] NOT NULL,
  [Status] [int] NOT NULL CONSTRAINT [DF_ObjectType_Status] DEFAULT (0),
  [Level] [int] NOT NULL CONSTRAINT [DF_ObjectType_Level] DEFAULT (0),
  [ViewScheme] [nvarchar](4000) NULL,
  [tmp_Code] [int] NULL,
  [BackColor] [int] NULL,
  [FontBold] [bit] NULL,
  [FontItalic] [bit] NULL,
  [FontColor] [int] NULL,
  [Code1C] [varchar](36) NULL,
  [IsHidden] [bit] NULL,
  [UserCode1C] [varchar](30) NULL,
  [ParameterName] [varchar](50) NULL,
  [isStandart] [bit] NULL,
  CONSTRAINT [PK_ObjectTypes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_ObjectTypes_NodeOrder]
  ON [dbo].[ObjectTypes] ([NodeOrder])
  ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_ObjectTypes_ParameterName]
  ON [dbo].[ObjectTypes] ([ParameterName])
  WHERE ([ParameterName] IS NOT NULL)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ObjectTypes_ParentID]
  ON [dbo].[ObjectTypes] ([ParentID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ObjectTypes]
  ADD CONSTRAINT [FK_ObjectTypes_ObjectTypes_ID] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[ObjectTypes] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Таблица типов ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Родитель ветви', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'ParentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование типа', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок ветвей в дереве', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'NodeOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Индекс иконки в дереве', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'NodeImageIndex'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Схема свойств типа ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'XMLSchema'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип: 1-тип, 0-папка(группа)', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние типа: 0-в разработке, 1-Enabled, 2-Disabled', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уровень в дереве. Для корректной выборки д
данных в запросе', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'Level'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Схема отображения данных. Поля берутся в []', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'ViewScheme'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на код для импорта старых типов', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'tmp_Code'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Цвет фона. код', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'BackColor'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Шрифт жирный', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'FontBold'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Шрифт наклонный', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'FontItalic'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Шрифт цвет', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'FontColor'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1c', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг - спрятан ли объект с пользовательского интерфейса', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'IsHidden'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый пользователю код 1С', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'UserCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя параметра', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'ParameterName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Группа с пометкой "Cтандартный материал".', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypes', 'COLUMN', N'isStandart'
GO