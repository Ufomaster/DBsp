CREATE TABLE [dbo].[Invoice] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NOT NULL,
  [Number] [int] NULL,
  [NumberStr] [varchar](50) NULL,
  [PlanRecieveDate] [datetime] NULL,
  [Comments] [varchar](max) NULL,
  [OrderDate] [datetime] NULL,
  [CustomerID] [int] NULL,
  [PayType] [int] NULL,
  CONSTRAINT [PK_Invoice_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Invoice]
  ADD CONSTRAINT [FK_Invoice_Customers_ID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Invoice', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата счета', 'SCHEMA', N'dbo', 'TABLE', N'Invoice', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядковый номер счета', 'SCHEMA', N'dbo', 'TABLE', N'Invoice', 'COLUMN', N'Number'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Строковый номер счета', 'SCHEMA', N'dbo', 'TABLE', N'Invoice', 'COLUMN', N'NumberStr'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата плановой поставки', 'SCHEMA', N'dbo', 'TABLE', N'Invoice', 'COLUMN', N'PlanRecieveDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'dbo', 'TABLE', N'Invoice', 'COLUMN', N'Comments'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата заказа', 'SCHEMA', N'dbo', 'TABLE', N'Invoice', 'COLUMN', N'OrderDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор поставщика', 'SCHEMA', N'dbo', 'TABLE', N'Invoice', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'0-Нал 1-безнал', 'SCHEMA', N'dbo', 'TABLE', N'Invoice', 'COLUMN', N'PayType'
GO