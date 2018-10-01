CREATE TABLE [dbo].[ProductionCardCustomize] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  [Number] [varchar](30) NULL,
  [CreateDate] [datetime] NOT NULL,
  [CardCountInvoice] [int] NULL,
  [DateProductionTransfer] [datetime] NULL,
  [CustomerID] [int] NULL,
  [CustomerPresence] [bit] NULL,
  [DBDateIncome] [datetime] NULL,
  [DBWayIncome] [int] NULL,
  [DBDateStore] [datetime] NULL,
  [SpecificationNumber] [varchar](50) NULL,
  [OfficialNote] [varchar](50) NULL,
  [CardDemoSomewhere] [bit] NULL,
  [ApprovedProofing] [bit] NULL,
  [ApprovedSampleOfPersonalization] [bit] NULL,
  [ApprovedTestScreenPrinting] [bit] NULL,
  [DemoSample] [bit] NULL,
  [SketchFileName] [varchar](255) NULL,
  [ContractData1] [varchar](800) NULL,
  [PrintOrientID] [int] NULL,
  [Comment] [varchar](max) NULL,
  [ProductionCardCustomizeID] [int] NULL,
  [StatusID] [smallint] NOT NULL,
  [ManEmployeeID] [int] NULL,
  [ManSignedDate] [datetime] NULL,
  [CompleteDate] [datetime] NULL,
  [TypeID] [int] NOT NULL,
  [DemoPackPaper] [bit] NULL,
  [DocTasks] [varchar](max) NULL,
  [PrintOrientPCCID] [int] NULL,
  [PrintOrientActNumber] [varchar](50) NULL,
  [ContractDataType] [smallint] NULL,
  [ContractData2] [varchar](255) NULL,
  [LayoutsSchemes] [varchar](8000) NULL,
  [ColorPick] [bit] NULL,
  [PersonalizationDescription] [varchar](max) NULL,
  [AdaptingGroupID] [int] NULL,
  [TecEmployeeID] [int] NULL,
  [TecSignedDate] [datetime] NULL,
  [RawMatSuppliedByCustomer] [tinyint] NULL,
  [RawMatSpekl] [tinyint] NULL,
  [RawMatPurchaseByCustomer] [tinyint] NULL,
  [RawMatIndepContractor] [tinyint] NULL,
  [DBRequirements] [varchar](max) NULL,
  [PackingRequirements] [varchar](max) NULL,
  [ProductionRequirements] [varchar](max) NULL,
  [CancelReasonID] [int] NULL,
  [PersonalizeRequirements] [varchar](max) NULL,
  [ChangedPCCID] [int] NULL,
  [RawMatSuppliedByCustomerName] [varchar](1000) NULL,
  [TechCardNumber] [varchar](30) NULL,
  [TmcID] [int] NULL,
  [SpecificationDate] [datetime] NULL,
  [RawMatPurchaseIndepContractor] [tinyint] NULL,
  [RawMatIndepContractor2] [tinyint] NULL,
  [RawMatSpeklTraf] [tinyint] NULL,
  [RawMatSpeklCyfra] [tinyint] NULL,
  [PVHPrintSide] [tinyint] NULL,
  [PVHFormat] [tinyint] NULL,
  [TechnologistPresence] [bit] NULL,
  [PrintOrientAdvID] [int] NULL,
  [PersonalizeRequirementsExtended] [varchar](max) NULL,
  [DBReceiveDate] [datetime] NULL,
  [WeightGross] [decimal](18, 2) NULL,
  [WeightNet] [decimal](18, 2) NULL,
  [PackingID] [tinyint] NULL,
  [WeightPlaceCount] [smallint] NULL,
  [TechnologicalCardID] [int] NULL,
  [isGroupedProduction] [bit] NULL,
  [GroupedZLText] [varchar](200) NULL,
  CONSTRAINT [PK_ProductionCardCustomize_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardCustomize_CreateDate]
  ON [dbo].[ProductionCardCustomize] ([CreateDate])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardCustomize_StatusID]
  ON [dbo].[ProductionCardCustomize] ([StatusID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardCustomize_TypeID]
  ON [dbo].[ProductionCardCustomize] ([TypeID])
  INCLUDE ([ID], [Name], [Number], [CreateDate], [CardCountInvoice], [DateProductionTransfer], [SketchFileName], [StatusID], [ManEmployeeID], [ManSignedDate], [CompleteDate], [TecEmployeeID], [TecSignedDate], [ChangedPCCID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.ProductionCardCustomize.CreateDate'
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_AdaptingGroups_ID] FOREIGN KEY ([AdaptingGroupID]) REFERENCES [dbo].[ProductionCardAdaptingGroups] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_DBWayIncome_ID] FOREIGN KEY ([DBWayIncome]) REFERENCES [dbo].[DBWayIncome] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_Employees_ID] FOREIGN KEY ([ManEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_EmployeesTec_ID] FOREIGN KEY ([TecEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_Packings_ID] FOREIGN KEY ([PackingID]) REFERENCES [dbo].[Packings] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_PrintOrient_ID] FOREIGN KEY ([PrintOrientID]) REFERENCES [dbo].[PrintOrient] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_PrintOrientAdv_ID] FOREIGN KEY ([PrintOrientAdvID]) REFERENCES [dbo].[PrintOrientAdv] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardCancelReasons_ID] FOREIGN KEY ([CancelReasonID]) REFERENCES [dbo].[ProductionCardCancelReasons] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardCustomize_ID2] FOREIGN KEY ([PrintOrientPCCID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardCustomize_ID3] FOREIGN KEY ([ChangedPCCID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardPropertiesHistoryDetails_ID] FOREIGN KEY ([TypeID]) REFERENCES [dbo].[ProductionCardProperties] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardSourceKind_ID1] FOREIGN KEY ([RawMatSuppliedByCustomer]) REFERENCES [dbo].[ProductionCardSourceKind] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardSourceKind_ID2] FOREIGN KEY ([RawMatSpekl]) REFERENCES [dbo].[ProductionCardSourceKind] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardSourceKind_ID3] FOREIGN KEY ([RawMatPurchaseByCustomer]) REFERENCES [dbo].[ProductionCardSourceKind] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardSourceKind_ID4] FOREIGN KEY ([RawMatIndepContractor]) REFERENCES [dbo].[ProductionCardSourceKind] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardSourceKind_ID5] FOREIGN KEY ([RawMatPurchaseIndepContractor]) REFERENCES [dbo].[ProductionCardSourceKind] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardSourceKind_ID6] FOREIGN KEY ([RawMatIndepContractor2]) REFERENCES [dbo].[ProductionCardSourceKind] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardSourceKind_ID7] FOREIGN KEY ([RawMatSpeklTraf]) REFERENCES [dbo].[ProductionCardSourceKind] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardSourceKind_ID8] FOREIGN KEY ([RawMatSpeklCyfra]) REFERENCES [dbo].[ProductionCardSourceKind] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_ProductionCardStatuses_ID] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[ProductionCardStatuses] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_TechnologicalCards_ID] FOREIGN KEY ([TechnologicalCardID]) REFERENCES [manufacture].[TechnologicalCards] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomize]
  ADD CONSTRAINT [FK_ProductionCardCustomize_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование заказа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер заказа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'Number'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во по счету', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'CardCountInvoice'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата передачи в производство', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'DateProductionTransfer'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор клиента', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Клиент присутствует на печати тиража', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'CustomerPresence'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата поступления БД', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'DBDateIncome'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Путь поступления БД - предполагается справочник', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'DBWayIncome'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Хранить файлы БД до даты', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'DBDateStore'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер ТЗ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'SpecificationNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Служебная записка, номер', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'OfficialNote'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Образец карты стороннего производителя 1-есть/0-нет', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'CardDemoSomewhere'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Согласованная цветопроба 1-есть/0-нет', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'ApprovedProofing'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Согласованный образец персонализации 1-есть/0-нет', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'ApprovedSampleOfPersonalization'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Согласованынй лист тестовой трафаретной печати 1-есть/0-нет', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'ApprovedTestScreenPrinting'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Демонстрационный образец 1-есть/0-нет', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'DemoSample'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование оригинал макета', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'SketchFileName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Устарело. Данные договора', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'ContractData1'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ориентир для печати', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'PrintOrientID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'Comment'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ProductionCardCustomize оригинал макет другого ЗЛ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор менеджера', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'ManEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата подписания ЗЛ менеджером', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'ManSignedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата завершения ЗЛ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'CompleteDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа - ссылка на ветку истории дерева технологий. Типизация заказных листов', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'TypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Образец упаковочного листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'DemoPackPaper'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Задачи по обработке полей документов цод', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'DocTasks'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ЗЛ ориентира для печати', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'PrintOrientPCCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Устарело. Номер акта тест. образца для ориентира печати', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'PrintOrientActNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Устарело. Фишки по договорным данным 0 - договір + Замовлення 1 - Замовлення 2 - Договір', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'ContractDataType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Устарело. Данные по контракту 2', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'ContractData2'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Схемы к оригинал макету', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'LayoutsSchemes'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Цветопроба', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'ColorPick'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание персонализации', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'PersonalizationDescription'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Группы всех согласователей', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'AdaptingGroupID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор технолога', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'TecEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата подписи технологом', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'TecSignedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Давальческое сырье"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'RawMatSuppliedByCustomer'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Спекл"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'RawMatSpekl'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Закупка у клиента"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'RawMatPurchaseByCustomer'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Подрядчик 1"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'RawMatIndepContractor'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вимоги до баз даних та передачі баз даних', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'DBRequirements'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Додаткові вимоги до пакування, пломбування та маркування', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'PackingRequirements'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Додаткові вимоги до продукції', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'ProductionRequirements'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор причины отмены', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'CancelReasonID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Додаткові вимоги до персоналізації', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'PersonalizeRequirements'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ЗЛ, который был заменен этим ЗЛ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'ChangedPCCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование давальческого сырья', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'RawMatSuppliedByCustomerName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер техкарты', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'TechCardNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор готовой продукции', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата ТЗ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'SpecificationDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Закупівля у постачальника"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'RawMatPurchaseIndepContractor'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Подрядчик 2"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'RawMatIndepContractor2'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Спекл_Трафарет"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'RawMatSpeklTraf'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Спекл_ЦИФРА"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'RawMatSpeklCyfra'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Оборот печати пвх. 0 свой 1 чужой', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'PVHPrintSide'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Формат пвх. 0 - A2(620*486) 1- A3(309*486)', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'PVHFormat'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Технолог присутній при друці тиражу ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'TechnologistPresence'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ориентир для печати расширенный', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'PrintOrientAdvID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Устарело', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'PersonalizeRequirementsExtended'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата получения базы данных', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'DBReceiveDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вес брутто', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'WeightGross'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'вес нетто', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'WeightNet'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип упаковки', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'PackingID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во мест груза', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'WeightPlaceCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор технологической карты', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'TechnologicalCardID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг сборочный тираж', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'isGroupedProduction'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ЗЛ сборочного тиража', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomize', 'COLUMN', N'GroupedZLText'
GO