CREATE TABLE [QualityControl].[ProtocolsDetails] (
  [ID] [int] IDENTITY,
  [ProtocolID] [int] NOT NULL,
  [Caption] [varchar](max) NULL,
  [ValueToCheck] [varchar](max) NULL,
  [FactValue] [varchar](max) NULL,
  [Checked] [tinyint] NULL,
  [ModifyDate] [datetime] NULL,
  [SortOrder] [smallint] NULL,
  [ResultKind] [tinyint] NULL,
  [BlockID] [smallint] NULL,
  [DetailBlockID] [smallint] NULL,
  [ImportanceID] [tinyint] NOT NULL,
  CONSTRAINT [PK_ProtocolsDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_ProtocolsDetails_ProtocolID]
  ON [QualityControl].[ProtocolsDetails] ([ProtocolID])
  INCLUDE ([Caption], [ValueToCheck], [FactValue], [Checked], [ModifyDate], [SortOrder], [ResultKind], [BlockID], [DetailBlockID], [ImportanceID], [ID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.ProtocolsDetails.ImportanceID'
GO

ALTER TABLE [QualityControl].[ProtocolsDetails]
  ADD CONSTRAINT [FK_ProtocolsDetails_PropImportance (QualityControl)_ID] FOREIGN KEY ([ImportanceID]) REFERENCES [QualityControl].[PropImportance] ([ID])
GO

ALTER TABLE [QualityControl].[ProtocolsDetails]
  ADD CONSTRAINT [FK_ProtocolsDetails_Protocols_ID] FOREIGN KEY ([ProtocolID]) REFERENCES [QualityControl].[Protocols] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [QualityControl].[ProtocolsDetails]
  ADD CONSTRAINT [FK_ProtocolsDetails_TypesBlocks (QualityControl)_ID] FOREIGN KEY ([BlockID]) REFERENCES [QualityControl].[TypesBlocks] ([ID])
GO

ALTER TABLE [QualityControl].[ProtocolsDetails]
  ADD CONSTRAINT [FK_ProtocolsDetails_TypesBlocks (QualityControl)_ID2] FOREIGN KEY ([DetailBlockID]) REFERENCES [QualityControl].[TypesBlocks] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsDetails', 'COLUMN', N'ProtocolID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsDetails', 'COLUMN', N'Caption'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Значение для проверки', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsDetails', 'COLUMN', N'ValueToCheck'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Фактическое значение или другое', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsDetails', 'COLUMN', N'FactValue'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг характеристики, прошло ли контроль 0-Нет, 1-Да', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsDetails', 'COLUMN', N'Checked'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата последних изменений', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsDetails', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок сортировки', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsDetails', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Классификация значения', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsDetails', 'COLUMN', N'ResultKind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор блока.Форейн не нужен, возможно перейдём на IsBlock', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsDetails', 'COLUMN', N'BlockID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор родительского блока', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsDetails', 'COLUMN', N'DetailBlockID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор критичности', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsDetails', 'COLUMN', N'ImportanceID'
GO