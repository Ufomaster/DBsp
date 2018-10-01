CREATE TABLE [QualityControl].[Protocols] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NOT NULL,
  [EmployeeID] [int] NULL,
  [EmployeeSignDate] [datetime] NULL,
  [EmployeeSpecialistID] [int] NULL,
  [EmployeeSpecialistSignDate] [datetime] NULL,
  [TypesID] [tinyint] NOT NULL,
  [StatusID] [tinyint] NULL,
  [PCCID] [int] NULL,
  [Number] [smallint] NULL,
  [TmcID] [int] NULL,
  [Result] [bit] NULL,
  [CustomerID] [int] NULL,
  [OrderNumber] [varchar](30) NULL,
  [OrderDate] [datetime] NULL,
  [IncomingCount] [decimal](18, 4) NULL,
  [WarehouseEmployeeID] [int] NULL,
  [StorageStructureID] [smallint] NULL,
  [isDeleted] [bit] NOT NULL,
  [UnitID] [int] NULL,
  [TechCardNumber] [int] NULL,
  [TechNeedsCount] [int] NULL,
  [ActOfTestCreateDate] [datetime] NULL,
  [ActOfTestCloseDate] [datetime] NULL,
  [SupplyCustomerID] [int] NULL,
  [VendorNumber] [varchar](30) NULL,
  [VendorDate] [datetime] NULL,
  CONSTRAINT [PK_Protocols_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'QualityControl.Protocols.CreateDate'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.Protocols.isDeleted'
GO

ALTER TABLE [QualityControl].[Protocols]
  ADD CONSTRAINT [FK_Protocols_Customers_ID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID])
GO

ALTER TABLE [QualityControl].[Protocols]
  ADD CONSTRAINT [FK_Protocols_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[Protocols]
  ADD CONSTRAINT [FK_Protocols_Employees_ID1] FOREIGN KEY ([EmployeeSpecialistID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[Protocols]
  ADD CONSTRAINT [FK_Protocols_Employees_ID2] FOREIGN KEY ([WarehouseEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[Protocols]
  ADD CONSTRAINT [FK_Protocols_ProductionCardCustomize_ID] FOREIGN KEY ([PCCID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

ALTER TABLE [QualityControl].[Protocols]
  ADD CONSTRAINT [FK_Protocols_StorageStructure (manufacture)_ID] FOREIGN KEY ([StorageStructureID]) REFERENCES [manufacture].[StorageStructure] ([ID])
GO

ALTER TABLE [QualityControl].[Protocols]
  ADD CONSTRAINT [FK_Protocols_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

ALTER TABLE [QualityControl].[Protocols]
  ADD CONSTRAINT [FK_Protocols_Types_ID] FOREIGN KEY ([TypesID]) REFERENCES [QualityControl].[Types] ([ID])
GO

ALTER TABLE [QualityControl].[Protocols]
  ADD CONSTRAINT [FK_Protocols_TypesStatuses (QualityControl)_ID] FOREIGN KEY ([StatusID]) REFERENCES [QualityControl].[TypesStatuses] ([ID])
GO

ALTER TABLE [QualityControl].[Protocols]
  ADD CONSTRAINT [FK_Protocols_Units_ID] FOREIGN KEY ([UnitID]) REFERENCES [dbo].[Units] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника, которотый создал запись. Нач смены или нач склада', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата подписи автора документа', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'EmployeeSignDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор специалиста ОКК', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'EmployeeSpecialistID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата подписи специалистом ОКК', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'EmployeeSpecialistSignDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'TypesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'PCCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер протокола. Уникальный в пределах года', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'Number'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор контролируемого материала', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Соотвествие качеству 0 нет 1 да', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'Result'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор поставщика', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'№ приходного ордера', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'OrderNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата приходного ордера', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'OrderDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во продукции', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'IncomingCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор начальника склада', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'WarehouseEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор склада', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'StorageStructureID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг удаления 1 удалён', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'isDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор единицы измерения', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'UnitID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер техкарты постачальника', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'TechCardNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во на тех. нужды', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'TechNeedsCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания акта тестирования', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'ActOfTestCreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата оформления акта тестирования', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'ActOfTestCloseDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор контрагента поставщика мат', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'SupplyCustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'№ заказа поставщика', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'VendorNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата заказа поставщика', 'SCHEMA', N'QualityControl', 'TABLE', N'Protocols', 'COLUMN', N'VendorDate'
GO