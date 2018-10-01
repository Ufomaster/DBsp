CREATE TABLE [manufacture].[ProductionTasksDocDetails] (
  [ID] [int] IDENTITY,
  [TMCID] [int] NOT NULL,
  [ProductionCardCustomizeID] [int] NULL,
  [Amount] [decimal](38, 10) NULL,
  [Name] [varchar](255) NULL,
  [MoveTypeID] [smallint] NULL,
  [isMajorTMC] [bit] NULL,
  [StatusID] [tinyint] NULL,
  [ProductionTasksDocsID] [int] NOT NULL,
  [EmployeeID] [int] NULL,
  [CreateDate] [datetime] NOT NULL,
  [RangeFrom] [varchar](36) NULL,
  [RangeTo] [varchar](36) NULL,
  [StatusFromID] [tinyint] NULL,
  [Comments] [varchar](8000) NULL,
  [ProductionCardCustomizeFromID] [int] NULL,
  [ReasonID] [tinyint] NULL,
  [FailTypeID] [tinyint] NULL,
  CONSTRAINT [PK_ProductionTasksDocsDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionTasksDocDetails_ProductionCardCustomizeID]
  ON [manufacture].[ProductionTasksDocDetails] ([ProductionCardCustomizeID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionTasksDocDetails_ProductionTasksDocsID]
  ON [manufacture].[ProductionTasksDocDetails] ([ProductionTasksDocsID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionTasksDocDetails_StatusID]
  ON [manufacture].[ProductionTasksDocDetails] ([StatusID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionTasksDocDetails_TMCID]
  ON [manufacture].[ProductionTasksDocDetails] ([TMCID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.ProductionTasksDocDetails.isMajorTMC'
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'manufacture.ProductionTasksDocDetails.CreateDate'
GO

ALTER TABLE [manufacture].[ProductionTasksDocDetails]
  ADD CONSTRAINT [FK_ProductionTasksDetails_ProductionTasksStatuses_ID] FOREIGN KEY ([StatusID]) REFERENCES [manufacture].[ProductionTasksStatuses] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasksDocDetails]
  ADD CONSTRAINT [FK_ProductionTasksDocDetails_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasksDocDetails]
  ADD CONSTRAINT [FK_ProductionTasksDocDetails_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasksDocDetails]
  ADD CONSTRAINT [FK_ProductionTasksDocDetails_ProductionCardCustomize_ID2] FOREIGN KEY ([ProductionCardCustomizeFromID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasksDocDetails] WITH NOCHECK
  ADD CONSTRAINT [FK_ProductionTasksDocDetails_ProductionTasksDocs_ID] FOREIGN KEY ([ProductionTasksDocsID]) REFERENCES [manufacture].[ProductionTasksDocs] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [manufacture].[ProductionTasksDocDetails]
  ADD CONSTRAINT [FK_ProductionTasksDocDetails_ProductionTasksStatuses (manufacture)_ID] FOREIGN KEY ([StatusFromID]) REFERENCES [manufacture].[ProductionTasksStatuses] ([ID])
GO

ALTER TABLE [manufacture].[ProductionTasksDocDetails]
  ADD CONSTRAINT [FK_ProductionTasksDocDetails_Tmc_ID] FOREIGN KEY ([TMCID]) REFERENCES [dbo].[Tmc] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'TMCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Количество', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование продукции если нет ТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1 приход, -1 уход', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'MoveTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг - основной полуфабрикат, продукция', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'isMajorTMC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус продукции', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор документа (шапки)', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'ProductionTasksDocsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника для фиксации выработки ГП', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Диапазон с', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'RangeFrom'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Диапазон по', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'RangeTo'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор начального статуса ', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'StatusFromID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'Comments'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ЗЛ, из-под которого были перенаправлены материалы на ProductionCardCustomizeID', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'ProductionCardCustomizeFromID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор причины корректировки manufacture.vw_AdvInsertReasons', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'ReasonID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа брака', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksDocDetails', 'COLUMN', N'FailTypeID'
GO