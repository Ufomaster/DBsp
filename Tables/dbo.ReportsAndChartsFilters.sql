CREATE TABLE [dbo].[ReportsAndChartsFilters] (
  [ID] [int] IDENTITY,
  [ReportsChartsID] [int] NOT NULL,
  [FilterFields] [varchar](255) NOT NULL,
  [Caption] [varchar](100) NOT NULL,
  [Type] [tinyint] NOT NULL,
  [SQLText] [varchar](max) NULL,
  [PosLeft] [int] NULL,
  [PosTop] [int] NULL,
  [Width] [smallint] NULL,
  [Height] [smallint] NULL,
  [CollWidth] [smallint] NULL,
  [PanelIndex] [tinyint] NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsFilters', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор отчета', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsFilters', 'COLUMN', N'ReportsChartsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имена полей запроса в кавычках если несколько', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsFilters', 'COLUMN', N'FilterFields'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название фильтра', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsFilters', 'COLUMN', N'Caption'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип фильтра 0-обычная таблица, 1-растягиваемая таблица, 2-комбобокс, 3-числовое условие', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsFilters', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Текст запроса для фильтра (ID, Name, Status)', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsFilters', 'COLUMN', N'SQLText'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Расстояние слева до контейнера', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsFilters', 'COLUMN', N'PosLeft'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Расстояние сверху до контейнера', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsFilters', 'COLUMN', N'PosTop'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ширина компонента редактирования', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsFilters', 'COLUMN', N'Width'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Высота компонента редактирования', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsFilters', 'COLUMN', N'Height'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ширина колонки в гриде', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsFilters', 'COLUMN', N'CollWidth'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Индекс панели с фильтром (1 - top; 2 - left)', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsFilters', 'COLUMN', N'PanelIndex'
GO