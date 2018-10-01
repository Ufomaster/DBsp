CREATE TABLE [QualityControl].[ActOfSamplingDetails] (
  [ID] [int] IDENTITY,
  [ActOfSamplingID] [int] NOT NULL,
  [ProductsIDInfo] [varchar](255) NULL,
  [UnitID] [int] NULL,
  [Quantity] [decimal](18, 4) NULL,
  [UnUsedQuantity] [decimal](18, 4) NULL,
  CONSTRAINT [PK_ActOfSamplingDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActOfSamplingDetails]
  ADD CONSTRAINT [FK_ActOfSamplingDetails_ActOfSampling_ID] FOREIGN KEY ([ActOfSamplingID]) REFERENCES [QualityControl].[ActOfSampling] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [QualityControl].[ActOfSamplingDetails]
  ADD CONSTRAINT [FK_ActOfSamplingDetails_Units_ID] FOREIGN KEY ([UnitID]) REFERENCES [dbo].[Units] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSamplingDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор акта отбора проб', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSamplingDetails', 'COLUMN', N'ActOfSamplingID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификационные данные продукции', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSamplingDetails', 'COLUMN', N'ProductsIDInfo'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ед. измерения', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSamplingDetails', 'COLUMN', N'UnitID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во отобранной продукции', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSamplingDetails', 'COLUMN', N'Quantity'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во не использованной продукции что передана на склад', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSamplingDetails', 'COLUMN', N'UnUsedQuantity'
GO