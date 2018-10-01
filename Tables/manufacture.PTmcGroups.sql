CREATE TABLE [manufacture].[PTmcGroups] (
  [ID] [int] IDENTITY,
  [StorageStructureID] [smallint] NULL,
  [TmcID] [int] NOT NULL,
  [Count] [int] NULL,
  [Min] [varchar](255) NULL,
  [Max] [varchar](255) NULL,
  [StatusID] [tinyint] NOT NULL,
  [isPacked] [bit] NULL,
  [JobStageID] [int] NULL,
  [GroupColumnName] [varchar](18) NULL,
  [Batch] [varchar](255) NULL,
  CONSTRAINT [PK_PTmcGroups_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_PTmcGroups_TmcID_isPacked]
  ON [manufacture].[PTmcGroups] ([TmcID], [isPacked])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.PTmcGroups.isPacked'
GO

ALTER TABLE [manufacture].[PTmcGroups]
  ADD CONSTRAINT [FK_PTmcGroups_JobStages (manufacture)_ID] FOREIGN KEY ([JobStageID]) REFERENCES [manufacture].[JobStages] ([ID])
GO

ALTER TABLE [manufacture].[PTmcGroups]
  ADD CONSTRAINT [FK_PTmcGroups_PTmcStatuses (storage)_ID] FOREIGN KEY ([StatusID]) REFERENCES [manufacture].[PTmcStatuses] ([ID])
GO

ALTER TABLE [manufacture].[PTmcGroups]
  ADD CONSTRAINT [FK_PTmcGroups_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

ALTER TABLE [manufacture].[PTmcGroups]
  ADD CONSTRAINT [FK_PTmcGroups_TmcPlaces_ID] FOREIGN KEY ([StorageStructureID]) REFERENCES [manufacture].[StorageStructure] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcGroups', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на место хранения', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcGroups', 'COLUMN', N'StorageStructureID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на ТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcGroups', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Количество', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcGroups', 'COLUMN', N'Count'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Значение пТМЦ с минимальным идентификатором', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcGroups', 'COLUMN', N'Min'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Значение пТМЦ с максимальным идентификатором', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcGroups', 'COLUMN', N'Max'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус пТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcGroups', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Показывает, упакован ли текущий диапазон в тару', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcGroups', 'COLUMN', N'isPacked'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на этап работы', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcGroups', 'COLUMN', N'JobStageID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Поле групповой таблицы, которое отвечает за связь с данным ТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcGroups', 'COLUMN', N'GroupColumnName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дополнительная группировочная колонка', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcGroups', 'COLUMN', N'Batch'
GO