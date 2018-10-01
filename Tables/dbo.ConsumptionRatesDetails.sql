CREATE TABLE [dbo].[ConsumptionRatesDetails] (
  [ID] [int] IDENTITY,
  [ConsumptionRateID] [int] NULL,
  [ObjectTypeID] [int] NULL,
  [Negation] [bit] NULL,
  CONSTRAINT [PK_ConsumptionRatesDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UQ_ConsumptionRatesDetails_ConsumptionRateID_ObjectTypeID]
  ON [dbo].[ConsumptionRatesDetails] ([ConsumptionRateID], [ObjectTypeID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ConsumptionRatesDetails.Negation'
GO

ALTER TABLE [dbo].[ConsumptionRatesDetails]
  ADD CONSTRAINT [FK_ConsumptionRatesDetails_ConsumptionRatesDetails_ID] FOREIGN KEY ([ConsumptionRateID]) REFERENCES [dbo].[ConsumptionRates] ([ID])
GO

ALTER TABLE [dbo].[ConsumptionRatesDetails]
  ADD CONSTRAINT [FK_ConsumptionRatesDetails_ObjectTypes_ID] FOREIGN KEY ([ObjectTypeID]) REFERENCES [dbo].[ObjectTypes] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ConsumptionRatesDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор норм расхода', 'SCHEMA', N'dbo', 'TABLE', N'ConsumptionRatesDetails', 'COLUMN', N'ConsumptionRateID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор значений справочника', 'SCHEMA', N'dbo', 'TABLE', N'ConsumptionRatesDetails', 'COLUMN', N'ObjectTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Показывает, необходимо ли применить отрицание', 'SCHEMA', N'dbo', 'TABLE', N'ConsumptionRatesDetails', 'COLUMN', N'Negation'
GO