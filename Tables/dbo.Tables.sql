CREATE TABLE [dbo].[Tables] (
  [ID] [int] NOT NULL,
  [Name] [varchar](50) NOT NULL,
  [Description] [varchar](50) NULL,
  [MainField] [varchar](128) NOT NULL,
  [FilteringTables] [varchar](500) NULL,
  [VisibleFields] [varchar](5000) NULL,
  [ColumnWidths] [varchar](1000) NULL,
  [Type] [int] NULL,
  [OrderByClause] [varchar](255) NULL,
  CONSTRAINT [PK_Tables_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UQ_Tables_Name]
  ON [dbo].[Tables] ([Name])
  ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Tables', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя таблицы', 'SCHEMA', N'dbo', 'TABLE', N'Tables', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание', 'SCHEMA', N'dbo', 'TABLE', N'Tables', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Основное поле таблицы для отображения по внешнему ключу', 'SCHEMA', N'dbo', 'TABLE', N'Tables', 'COLUMN', N'MainField'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Поля с форейнкиейными определениями. Имя поля = Таблица. например "AccountID=Accounts"', 'SCHEMA', N'dbo', 'TABLE', N'Tables', 'COLUMN', N'FilteringTables'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимые и редактируемые поля', 'SCHEMA', N'dbo', 'TABLE', N'Tables', 'COLUMN', N'VisibleFields'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Через запятую ширины колонок. Авторазмер колонок - просто нулл.', 'SCHEMA', N'dbo', 'TABLE', N'Tables', 'COLUMN', N'ColumnWidths'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип справочника: 0-системный 1-пользовательский', 'SCHEMA', N'dbo', 'TABLE', N'Tables', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'При потребности сортировки основного вида - пишем тут ордер бай запрос', 'SCHEMA', N'dbo', 'TABLE', N'Tables', 'COLUMN', N'OrderByClause'
GO