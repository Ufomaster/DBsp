CREATE TABLE [manufacture].[ProductionTasksDocsDetailsHistory] (
  [ID] [int] IDENTITY,
  [DocHistoryID] [int] NULL,
  [TMCID] [int] NULL,
  [ProductionCardCustomizeID] [int] NULL,
  [Amount] [decimal](38, 10) NULL,
  [Name] [varchar](255) NULL,
  [MoveTypeID] [smallint] NULL,
  [isMajorTMC] [bit] NULL,
  [StatusID] [tinyint] NULL,
  [EmployeeID] [int] NULL,
  [CreateDate] [datetime] NULL,
  [RangeFrom] [varchar](36) NULL,
  [RangeTo] [varchar](36) NULL,
  [StatusFromID] [tinyint] NULL,
  [Comments] [varchar](8000) NULL,
  [ProductionCardCustomizeFromID] [int] NULL,
  [ReasonID] [tinyint] NULL,
  [FailTypeID] [tinyint] NULL,
  CONSTRAINT [PK_ProductionTasksDocsDetailsHistory_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [manufacture].[ProductionTasksDocsDetailsHistory] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasksDocsDetailsHistory_ProductionTasksDocsHistory (manufacture)_ID] FOREIGN KEY ([DocHistoryID]) REFERENCES [manufacture].[ProductionTasksDocsHistory] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор документа истории', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'DocHistoryID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'TMCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Количество', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование продукции если нет ТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1 приход, -1 уход', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'MoveTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг - основной полуфабрикат, продукция', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'isMajorTMC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус продукции', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника для фиксации выработки ГП', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Диапазон с', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'RangeFrom'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Диапазон по', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'RangeTo'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор начального статуса ', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'StatusFromID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'Comments'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ЗЛ из которого переведен материал', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'ProductionCardCustomizeFromID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор причины корректировки', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocsDetailsHistory', 'COLUMN', N'ReasonID'
GO