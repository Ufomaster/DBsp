CREATE TABLE [sync].[1CExpensesDetails] (
  [ID] [int] IDENTITY,
  [1CExpensesID] [int] NULL,
  [TMCCode1С] [varchar](36) NULL,
  [Qty] [decimal](15, 3) NULL,
  [PCCNumber] [varchar](5) NULL,
  [Norma] [decimal](38, 10) NULL,
  [PCCCount] [int] NULL,
  [PCCID] [int] NULL,
  [Skip] [bit] NULL,
  [OrderSelector] [bit] NOT NULL,
  [SkipSpecificationCheck] [bit] NULL,
  CONSTRAINT [PK__1CExpens__3214EC2750568816] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'sync.[1CExpensesDetails].OrderSelector'
GO

ALTER TABLE [sync].[1CExpensesDetails]
  ADD CONSTRAINT [FK_1CExpensesDetails_1CExpenses (sync)_ID] FOREIGN KEY ([1CExpensesID]) REFERENCES [sync].[1CExpenses] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [sync].[1CExpensesDetails]
  ADD CONSTRAINT [FK_1CExpensesDetails_ProductionCardCustomize_ID] FOREIGN KEY ([PCCID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CExpensesDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор шапки документа', 'SCHEMA', N'sync', 'TABLE', N'1CExpensesDetails', 'COLUMN', N'1CExpensesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код тмц', 'SCHEMA', N'sync', 'TABLE', N'1CExpensesDetails', 'COLUMN', N'TMCCode1С'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во', 'SCHEMA', N'sync', 'TABLE', N'1CExpensesDetails', 'COLUMN', N'Qty'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'В Спеклере вносится номер заказа, по которому  осуществляется поиск документа «Заказ на производство»', 'SCHEMA', N'sync', 'TABLE', N'1CExpensesDetails', 'COLUMN', N'PCCNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Норма', 'SCHEMA', N'sync', 'TABLE', N'1CExpensesDetails', 'COLUMN', N'Norma'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во продукции', 'SCHEMA', N'sync', 'TABLE', N'1CExpensesDetails', 'COLUMN', N'PCCCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'sync', 'TABLE', N'1CExpensesDetails', 'COLUMN', N'PCCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг 0,нулл- не пропускаем, 1- пропускаем загрузку', 'SCHEMA', N'sync', 'TABLE', N'1CExpensesDetails', 'COLUMN', N'Skip'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'0 - Заказ на производство, 1- Заказ покупателя', 'SCHEMA', N'sync', 'TABLE', N'1CExpensesDetails', 'COLUMN', N'OrderSelector'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг - игнорируем проверку по спецификации', 'SCHEMA', N'sync', 'TABLE', N'1CExpensesDetails', 'COLUMN', N'SkipSpecificationCheck'
GO