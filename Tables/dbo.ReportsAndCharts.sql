CREATE TABLE [dbo].[ReportsAndCharts] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  [Caption] [varchar](50) NULL,
  [SQLText] [varchar](max) NULL,
  [Map] [varchar](5000) NULL,
  [Type] [int] NOT NULL,
  [GroupID] [int] NULL,
  [PanelHeight] [smallint] NULL,
  [XMLConfig] [varchar](max) NULL,
  [AutoExec] [bit] NOT NULL,
  [XMLStyles] [varchar](max) NULL,
  [IsDeleted] [bit] NULL,
  [PanelWidth] [smallint] NULL,
  [XMLStyleCond] [varchar](max) NULL,
  CONSTRAINT [PK_ReportsAndCharts_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ReportsAndCharts.AutoExec'
GO

ALTER TABLE [dbo].[ReportsAndCharts]
  ADD CONSTRAINT [FK_ReportsAndCharts_ReportsAndChartsGroup_ID] FOREIGN KEY ([GroupID]) REFERENCES [dbo].[ReportsAndChartsGroup] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование отчета/графика', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование отчета/графика в меню', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'Caption'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Текст запроса отчета/графика', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'SQLText'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Карта результирующих полей для серий графика', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'Map'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип : 0-табличный 1-графический', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Группа, к которой привязан график', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'GroupID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Высота верхней панели параметров ', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'PanelHeight'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ХМЛ данные настроек конфигурации грида', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'XMLConfig'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Автостарт отчета', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'AutoExec'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ХМЛ данные настроек стилей для грида', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'XMLStyles'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Удален', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'IsDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ширина левой панели параметров', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'PanelWidth'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ХМЛ данные условной раскраски с использованием стилей', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndCharts', 'COLUMN', N'XMLStyleCond'
GO