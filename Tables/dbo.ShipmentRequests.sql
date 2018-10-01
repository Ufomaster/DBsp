CREATE TABLE [dbo].[ShipmentRequests] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NULL,
  [StatusID] [tinyint] NULL,
  [EmployeeID] [int] NULL,
  [LogistEmployeeID] [int] NULL,
  [PlanDate] [datetime] NULL,
  [ReadyDate] [datetime] NULL,
  [TimeFrom] [datetime] NULL,
  [TimeTo] [datetime] NULL,
  [SenderCustomerID] [int] NULL,
  [CustomerID] [int] NULL,
  [ContactID] [int] NULL,
  [ContactsAdditional] [varchar](1000) NULL,
  [DeparturePoint] [varchar](1000) NULL,
  [ArrivalPoint] [varchar](1000) NULL,
  [Description] [varchar](1000) NULL,
  [DeliveryCustomerID] [int] NULL,
  [Payer] [tinyint] NULL,
  [CompleteDate] [datetime] NULL,
  [CancelReason] [varchar](1000) NULL,
  [Courier] [varchar](255) NULL,
  [LicenseNumber] [varchar](30) NULL,
  [Comments] [varchar](1000) NULL,
  [OperationKind] [tinyint] NULL,
  [ContractData] [varchar](100) NULL,
  [OrderData] [varchar](500) NULL,
  [Customer3ID] [int] NULL,
  [SenderContacts] [varchar](1000) NULL,
  [Conditions] [varchar](1000) NULL,
  [Declaration] [varchar](50) NULL,
  [TransportTypeID] [smallint] NULL,
  [CustomerTransport] [bit] NULL,
  [DeliveryDate] [datetime] NULL,
  [SenderContactID] [int] NULL,
  [CFRID] [int] NULL,
  [BudgetSpendsID] [int] NULL,
  [Cost] [decimal](18, 4) NULL,
  [ActNum] [varchar](20) NULL,
  [ActDate] [datetime] NULL,
  [CostCourier] [decimal](18, 4) NULL,
  CONSTRAINT [PK_ShipmentRequests_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.ShipmentRequests.CreateDate'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ShipmentRequests.CustomerTransport'
GO

ALTER TABLE [dbo].[ShipmentRequests]
  ADD CONSTRAINT [FK_ShipmentRequests_BudgetSpends_ID] FOREIGN KEY ([BudgetSpendsID]) REFERENCES [dbo].[BudgetSpends] ([ID])
GO

ALTER TABLE [dbo].[ShipmentRequests]
  ADD CONSTRAINT [FK_ShipmentRequests_CFR_ID] FOREIGN KEY ([CFRID]) REFERENCES [dbo].[CFR] ([ID])
GO

ALTER TABLE [dbo].[ShipmentRequests]
  ADD CONSTRAINT [FK_ShipmentRequests_CustomerContacts_ID] FOREIGN KEY ([ContactID]) REFERENCES [dbo].[CustomerContacts] ([ID])
GO

ALTER TABLE [dbo].[ShipmentRequests]
  ADD CONSTRAINT [FK_ShipmentRequests_CustomerContacts_ID2] FOREIGN KEY ([SenderContactID]) REFERENCES [dbo].[CustomerContacts] ([ID])
GO

ALTER TABLE [dbo].[ShipmentRequests]
  ADD CONSTRAINT [FK_ShipmentRequests_Customers_ID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID])
GO

ALTER TABLE [dbo].[ShipmentRequests]
  ADD CONSTRAINT [FK_ShipmentRequests_Customers_ID2] FOREIGN KEY ([SenderCustomerID]) REFERENCES [dbo].[Customers] ([ID])
GO

ALTER TABLE [dbo].[ShipmentRequests]
  ADD CONSTRAINT [FK_ShipmentRequests_Customers_ID3] FOREIGN KEY ([Customer3ID]) REFERENCES [dbo].[Customers] ([ID])
GO

ALTER TABLE [dbo].[ShipmentRequests]
  ADD CONSTRAINT [FK_ShipmentRequests_Customers_ID4] FOREIGN KEY ([DeliveryCustomerID]) REFERENCES [dbo].[Customers] ([ID])
GO

ALTER TABLE [dbo].[ShipmentRequests]
  ADD CONSTRAINT [FK_ShipmentRequests_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[ShipmentRequests]
  ADD CONSTRAINT [FK_ShipmentRequests_Employees_ID2] FOREIGN KEY ([LogistEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[ShipmentRequests]
  ADD CONSTRAINT [FK_ShipmentRequests_TransportTypes_ID] FOREIGN KEY ([TransportTypeID]) REFERENCES [dbo].[TransportTypes] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус завяки', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор подателя заявки', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор логиста', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'LogistEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Плановая дата поставки', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'PlanDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата готовности груза', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'ReadyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Время доствки с', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'TimeFrom'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Время доствки по', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'TimeTo'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Отправитель/контрактодержатель', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'SenderCustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Контрагент - заказчик', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Контакты заказчика', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'ContactID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дополнителные контакты. Контакты посредников, брокеров', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'ContactsAdditional'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пункт відправления (організація, адреса, назва, підрозділ)', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'DeparturePoint'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пункт прибытия (організація, адреса, назва, підрозділ)', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'ArrivalPoint'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Компания доставщик, указывается и завявителем и правится логистом', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'DeliveryCustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Плательщик vw_PayersTypes', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'Payer'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата выполения', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'CompleteDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Причина отмены', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'CancelReason'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ФИО курьера', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'Courier'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'№ ТС', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'LicenseNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Примечания', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'Comments'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вид операции', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'OperationKind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'№ та дата Договору з  контрагентом ', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'ContractData'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'№ та дата Замовлення (додатку) з контрагентом', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'OrderData'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор контрагента 3-е лицо', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'Customer3ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Контакты отправителя', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'SenderContacts'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Условия поставки', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'Conditions'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер декларации', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'Declaration'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вид транспорта', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'TransportTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Транспорт контрагента', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'CustomerTransport'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Согласованная дата поставки', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'DeliveryDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Контакты отправителя', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'SenderContactID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ЦФВ', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'CFRID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статья расходов', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'BudgetSpendsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Стоимость услуг (грн. без ПДВ)', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'Cost'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'№ Акта выполненых работ', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'ActNum'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата Акта выполненых работ', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'ActDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'расход курьер', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequests', 'COLUMN', N'CostCourier'
GO