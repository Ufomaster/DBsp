CREATE TABLE [QualityControl].[TypesDetails] (
  [ID] [smallint] IDENTITY,
  [TypesID] [tinyint] NOT NULL,
  [Caption] [varchar](8000) NULL,
  [ValueToCheck] [varchar](8000) NULL,
  [StartDate] [datetime] NOT NULL,
  [EndDate] [datetime] NULL,
  [SortOrder] [tinyint] NOT NULL,
  [ResultKind] [tinyint] NULL,
  [PCCColumnID] [int] NULL,
  [BlockID] [smallint] NULL,
  [ImportanceID] [tinyint] NULL,
  CONSTRAINT [PK_TypesDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[TypesDetails]
  ADD CONSTRAINT [FK_TypesDetails_Blocks_ID] FOREIGN KEY ([BlockID]) REFERENCES [QualityControl].[TypesBlocks] ([ID])
GO

ALTER TABLE [QualityControl].[TypesDetails]
  ADD CONSTRAINT [FK_TypesDetails_ProductionCardFields_colid] FOREIGN KEY ([PCCColumnID]) REFERENCES [dbo].[ProductionCardFields] ([colid])
GO

ALTER TABLE [QualityControl].[TypesDetails]
  ADD CONSTRAINT [FK_TypesDetails_PropImportance (QualityControl)_ID] FOREIGN KEY ([ImportanceID]) REFERENCES [QualityControl].[PropImportance] ([ID])
GO

ALTER TABLE [QualityControl].[TypesDetails]
  ADD CONSTRAINT [FK_TypesDetailsDetails_Types_ID] FOREIGN KEY ([TypesID]) REFERENCES [QualityControl].[Types] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Детальная часть(описание) полей типа протокола ОКК', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesDetails'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesDetails', 'COLUMN', N'TypesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование Caption компонента для айтема', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesDetails', 'COLUMN', N'Caption'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Значение, которое проверяется (при наличии).', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesDetails', 'COLUMN', N'ValueToCheck'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата начала действия значения(для историчности)', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesDetails', 'COLUMN', N'StartDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата окончания действия значения(для историчности)', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesDetails', 'COLUMN', N'EndDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок следования записи', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesDetails', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Классификация значения', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesDetails', 'COLUMN', N'ResultKind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор колонки таблицы заказных листов', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesDetails', 'COLUMN', N'PCCColumnID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор раздела, в который будет выводиться характеристика', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesDetails', 'COLUMN', N'BlockID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор критичности', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesDetails', 'COLUMN', N'ImportanceID'
GO