CREATE TABLE [dbo].[InvoiceDetail] (
  [ID] [int] IDENTITY,
  [InvoiceID] [int] NOT NULL,
  [TmcID] [int] NULL,
  [Price] [numeric](18, 4) NULL,
  [Amount] [numeric](18, 4) NULL,
  [TmcPlaceID] [smallint] NULL,
  [Comments] [varchar](max) NULL,
  [PayDate] [datetime] NULL,
  [RecieveDate] [datetime] NULL,
  [UnitID] [int] NULL,
  [PriceVal] [numeric](18, 4) NULL,
  [CurrencyID] [int] NULL,
  CONSTRAINT [PK_InvoiceDetail_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_InvoiceDetail_TmcID]
  ON [dbo].[InvoiceDetail] ([TmcID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[InvoiceDetail]
  ADD CONSTRAINT [FK_InvoiceDetail_Currency_ID] FOREIGN KEY ([CurrencyID]) REFERENCES [dbo].[Currency] ([ID])
GO

ALTER TABLE [dbo].[InvoiceDetail]
  ADD CONSTRAINT [FK_InvoiceDetail_Invoice_ID] FOREIGN KEY ([InvoiceID]) REFERENCES [dbo].[Invoice] ([ID])
GO

ALTER TABLE [dbo].[InvoiceDetail]
  ADD CONSTRAINT [FK_InvoiceDetail_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

ALTER TABLE [dbo].[InvoiceDetail]
  ADD CONSTRAINT [FK_InvoiceDetail_TmcPlaces_ID] FOREIGN KEY ([TmcPlaceID]) REFERENCES [dbo].[TmcPlaces] ([ID])
GO

ALTER TABLE [dbo].[InvoiceDetail]
  ADD CONSTRAINT [FK_InvoiceDetail_Units_ID] FOREIGN KEY ([UnitID]) REFERENCES [dbo].[Units] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDetail', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор счета', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDetail', 'COLUMN', N'InvoiceID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDetail', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Цена за штуку', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDetail', 'COLUMN', N'Price'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Количество, вес', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDetail', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор места хранения', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDetail', 'COLUMN', N'TmcPlaceID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDetail', 'COLUMN', N'Comments'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата оплаты', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDetail', 'COLUMN', N'PayDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата получения', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDetail', 'COLUMN', N'RecieveDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'(Устарело) Идентификатор единицы измерения', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDetail', 'COLUMN', N'UnitID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сумма в валюте', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDetail', 'COLUMN', N'PriceVal'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор валюты', 'SCHEMA', N'dbo', 'TABLE', N'InvoiceDetail', 'COLUMN', N'CurrencyID'
GO