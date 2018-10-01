CREATE TABLE [manufacture].[StorageStructure] (
  [ID] [smallint] IDENTITY,
  [ParentID] [smallint] NULL,
  [NodeOrder] [int] NULL,
  [NodeImageIndex] [int] NOT NULL,
  [NodeLevel] [int] NOT NULL CONSTRAINT [DF_AStorageScheme_Level_AStorageScheme] DEFAULT (0),
  [NodeExpanded] [bit] NOT NULL,
  [Name] [varchar](255) NOT NULL,
  [IP] [varchar](50) NULL,
  [HiddenForSelect] [bit] NULL,
  [CSStorage] [bit] NULL,
  CONSTRAINT [PK_StorageStructure_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.StorageStructure.NodeExpanded'
GO

ALTER TABLE [manufacture].[StorageStructure]
  ADD CONSTRAINT [FK_StorageStructure_StorageStructure (storage)_ID] FOREIGN KEY ([ParentID]) REFERENCES [manufacture].[StorageStructure] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructure', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор корневой ноды', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructure', 'COLUMN', N'ParentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок, сортировка ноды', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructure', 'COLUMN', N'NodeOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Иконка ноды', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructure', 'COLUMN', N'NodeImageIndex'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уровень вложенности ноды', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructure', 'COLUMN', N'NodeLevel'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние ноды в дереве 0-свернута, 1-развернута', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructure', 'COLUMN', N'NodeExpanded'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование места хранения', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructure', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'IP адрес компьютера', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructure', 'COLUMN', N'IP'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Прятать поле для плоской выборки', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructure', 'COLUMN', N'HiddenForSelect'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Признак склада ЦС', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructure', 'COLUMN', N'CSStorage'
GO