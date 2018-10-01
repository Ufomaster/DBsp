CREATE TABLE [dbo].[ProductionOrders] (
  [ID] [int] IDENTITY,
  [CustomerID] [int] NULL,
  [CreateDate] [datetime] NOT NULL,
  [AgreementID] [int] NULL,
  [CustomerOrderNumber] [varchar](50) NOT NULL,
  [CustomerContactID] [int] NULL,
  [LastSignOnly] [bit] NULL,
  [SpeklCustomerID] [int] NOT NULL,
  [Date] [datetime] NULL,
  [SpeklContactID] [int] NULL,
  [ModifyDate] [datetime] NULL,
  [ModifyEmployeeID] [int] NULL,
  [LeftSignerKind] [tinyint] NOT NULL,
  [RightSignerKind] [tinyint] NOT NULL,
  CONSTRAINT [PK_ProductionOrders_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionOrders_CustomerID]
  ON [dbo].[ProductionOrders] ([CustomerID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.ProductionOrders.CreateDate'
GO

ALTER TABLE [dbo].[ProductionOrders]
  ADD CONSTRAINT [FK_ProductionOrders_Agreements_ID] FOREIGN KEY ([AgreementID]) REFERENCES [dbo].[Agreements] ([ID])
GO

ALTER TABLE [dbo].[ProductionOrders]
  ADD CONSTRAINT [FK_ProductionOrders_CustomerContacts_ID] FOREIGN KEY ([CustomerContactID]) REFERENCES [dbo].[CustomerContacts] ([ID])
GO

ALTER TABLE [dbo].[ProductionOrders]
  ADD CONSTRAINT [FK_ProductionOrders_CustomerContacts_SpeklContactID] FOREIGN KEY ([SpeklContactID]) REFERENCES [dbo].[CustomerContacts] ([ID])
GO

ALTER TABLE [dbo].[ProductionOrders]
  ADD CONSTRAINT [FK_ProductionOrders_Customers_ID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID])
GO

ALTER TABLE [dbo].[ProductionOrders]
  ADD CONSTRAINT [FK_ProductionOrders_Customers_ID1] FOREIGN KEY ([SpeklCustomerID]) REFERENCES [dbo].[Customers] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор контрагента', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор договора', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'AgreementID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер замовлення клиента', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'CustomerOrderNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор контакного лица подписчика спецификации', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'CustomerContactID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Подписывается только последняя спецификация', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'LastSignOnly'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Компания со стороны СПЕКЛ, которая подписывает спецификацию', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'SpeklCustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата заказа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Подписант со стороны спекл', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'SpeklContactID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата модификации', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя, который изменил данные', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вид заголовка подписывающего слева', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'LeftSignerKind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вид заголовка подписывающего справа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionOrders', 'COLUMN', N'RightSignerKind'
GO