CREATE TABLE [dbo].[ReportsAndChartsParams] (
  [ID] [int] IDENTITY,
  [ReportsChartsID] [int] NOT NULL,
  [ParamName] [varchar](50) NOT NULL,
  [Caption] [varchar](100) NOT NULL,
  [Type] [int] NOT NULL,
  [SQLText] [varchar](max) NULL,
  [PosLeft] [int] NULL,
  [PosTop] [int] NULL,
  [EditWidth] [int] NULL DEFAULT (70),
  [DefaultValueType] [tinyint] NULL,
  [DefaultValue] [varchar](max) NULL,
  [LinkedParamID] [int] NULL,
  [PanelIndex] [tinyint] NULL,
  CONSTRAINT [PK_ReportsAndChartsParams_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ReportsAndChartsParams]
  ADD CONSTRAINT [FK_ReportsAndChartsParams_ReportsAndCharts_ID] FOREIGN KEY ([ReportsChartsID]) REFERENCES [dbo].[ReportsAndCharts] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ReportsAndChartsParams]
  ADD CONSTRAINT [FK_ReportsAndChartsParams_ReportsAndChartsParams_ID] FOREIGN KEY ([LinkedParamID]) REFERENCES [dbo].[ReportsAndChartsParams] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsParams', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор графика', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsParams', 'COLUMN', N'ReportsChartsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя параметра в запросе', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsParams', 'COLUMN', N'ParamName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название параметра', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsParams', 'COLUMN', N'Caption'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип параметра', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsParams', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Текст запроса для параметра списка', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsParams', 'COLUMN', N'SQLText'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Расстояние слева до контейнера', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsParams', 'COLUMN', N'PosLeft'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Расстояние сверху до контейнера', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsParams', 'COLUMN', N'PosTop'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ширина компонента редактирования', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsParams', 'COLUMN', N'EditWidth'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип значения по умолчанию. 0-нет, 1-Запрос, 2-значение', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsParams', 'COLUMN', N'DefaultValueType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Значение', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsParams', 'COLUMN', N'DefaultValue'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Связаное значение (например дата начала и дата конца периода)', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsParams', 'COLUMN', N'LinkedParamID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Индекс панели с параметром (1 - top; 2 - left)', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsParams', 'COLUMN', N'PanelIndex'
GO