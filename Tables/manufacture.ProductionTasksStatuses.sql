CREATE TABLE [manufacture].[ProductionTasksStatuses] (
  [ID] [tinyint] IDENTITY,
  [Name] [varchar](30) NOT NULL,
  [MajorOnly] [bit] NOT NULL,
  [InternalName] [varchar](30) NOT NULL,
  [SortOrder] [tinyint] NOT NULL,
  [ManufactureID] [smallint] NULL,
  [OutProdClass] [tinyint] NOT NULL,
  [Multiplier] [tinyint] NULL DEFAULT (1),
  [AutoFillWork] [bit] NULL,
  [isWorkWithCardGroupMaterial] [bit] NULL,
  CONSTRAINT [PK_ProductionTasksStatuses_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.ProductionTasksStatuses.MajorOnly'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.ProductionTasksStatuses.SortOrder'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.ProductionTasksStatuses.OutProdClass'
GO

ALTER TABLE [manufacture].[ProductionTasksStatuses]
  ADD CONSTRAINT [FK_ProductionTasksStatuses_ManufactureStructure (manufacture)_ID] FOREIGN KEY ([ManufactureID]) REFERENCES [manufacture].[ManufactureStructure] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksStatuses', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksStatuses', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус применним только для основной продукции - устаревает', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksStatuses', 'COLUMN', N'MajorOnly'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название статуса видимое для пользователя', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksStatuses', 'COLUMN', N'InternalName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ПОрядок сортировки для отображения', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksStatuses', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор принадлежности к производству', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksStatuses', 'COLUMN', N'ManufactureID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Классификация изготавливаемой ГП по источнику данных.', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksStatuses', 'COLUMN', N'OutProdClass'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Коеффициент преобразования пакета в карты', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksStatuses', 'COLUMN', N'Multiplier'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг нужно ли автозаполнять выработку(прячет кнопку заполнить)', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksStatuses', 'COLUMN', N'AutoFillWork'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Указывает работаем ли мы с пакетом как группой карт. Нужно для понимания требуется ли корректировка нормы из картоштук в пакеты', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksStatuses', 'COLUMN', N'isWorkWithCardGroupMaterial'
GO