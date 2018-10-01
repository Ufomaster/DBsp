CREATE TABLE [dbo].[ProductionCardCustomizeHistory] (
  [ID] [int] IDENTITY,
  [OperationType] [int] NULL,
  [ModifyEmployeeID] [int] NULL,
  [ModifyDate] [datetime] NULL,
  [ProductionCardCustomizeID] [int] NULL,
  [Name] [varchar](255) NULL,
  [Number] [varchar](30) NULL,
  [CreateDate] [datetime] NULL,
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
  [LinkProductionCardCustomizeID] [int] NULL,
  [StatusID] [smallint] NULL,
  [ManEmployeeID] [int] NULL,
  [ManSignedDate] [datetime] NULL,
  [CompleteDate] [datetime] NULL,
  [TypeID] [int] NULL,
  [DemoPackPaper] [bit] NULL,
  [DocTasks] [varchar](max) NULL,
  [PrintOrientPCCID] [int] NULL,
  [PrintOrientActNumber] [varchar](50) NULL,
  [ContractData2] [varchar](255) NULL,
  [ContractDataType] [smallint] NULL,
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
  [PersonalizeRequirementsExtended] [varchar](max) NULL,
  [DBReceiveDate] [datetime] NULL,
  [WeightGross] [decimal](18, 2) NULL,
  [WeightNet] [decimal](18, 2) NULL,
  [PackingID] [tinyint] NULL,
  [WeightPlaceCount] [smallint] NULL,
  [TechnologicalCardID] [int] NULL,
  [isGroupedProduction] [bit] NULL,
  [GroupedZLText] [varchar](200) NULL,
  CONSTRAINT [PK_ProductionCardCustomizeHistory_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardCustomizeHistory_ProductionCardCustomizeID]
  ON [dbo].[ProductionCardCustomizeHistory] ([ProductionCardCustomizeID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardCustomizeHistory]
  ADD CONSTRAINT [FK_ProductionCardCustomizeHistory_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomizeHistory]
  ADD CONSTRAINT [FK_ProductionCardCustomizeHistory_ProductionCardCustomize_ID1] FOREIGN KEY ([LinkProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID]) ON DELETE SET NULL
GO

ALTER TABLE [dbo].[ProductionCardCustomizeHistory]
  ADD CONSTRAINT [FK_ProductionCardCustomizeHistory_ProductionCardStatuses_ID] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[ProductionCardStatuses] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции 0-insert, 1-update, 2-delete', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сотрудник, который изменил запись', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата события истории', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа. Без форейна. Удаляем заказные', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование заказа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер заказа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'Number'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания заказного', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во по счету', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'CardCountInvoice'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата передачи в производство', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'DateProductionTransfer'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор клиента', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Клиент присутствует на печати тиража', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'CustomerPresence'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата поступления БД', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'DBDateIncome'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Путь поступления БД - предполагается справочник', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'DBWayIncome'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Хранить файлы БД до даты', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'DBDateStore'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер ТЗ если есть', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'SpecificationNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Служебная записка 1-есть/0-нет', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'OfficialNote'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Образец карты стороннего производителя 1-есть/0-нет', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'CardDemoSomewhere'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Согласованная цветопроба 1-есть/0-нет', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ApprovedProofing'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Согласованный образец персонализации 1-есть/0-нет', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ApprovedSampleOfPersonalization'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Согласованный лист тестовой трафаретной печати 1-есть/0-нет', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ApprovedTestScreenPrinting'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Демонстрационный образец 1-есть/0-нет', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'DemoSample'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование оригинал макета', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'SketchFileName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Данные договра', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ContractData1'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ориентир для печати', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'PrintOrientID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Клмментарий к способу доставки', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'Comment'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ProductionCardCustomize оригинал макет другого ЗЛ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'LinkProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор менеджера создателя', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ManEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата подписания ЗЛ менеджером-при переходе ЗЛ в статус Оформлен', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ManSignedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата завершения ЗЛ. ставится в статусе "Завершен"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'CompleteDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа - ссылка на ветку истории дерева технологий. Типизация заказных листов', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'TypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Образец упаковочного листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'DemoPackPaper'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Задачи по обработке полей документов цод', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'DocTasks'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ЗЛ ориентира для печати', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'PrintOrientPCCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер акта тестового образца для ориентира печати', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'PrintOrientActNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Данные по контракту 2', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ContractData2'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Фишки по договорным данным
0 - Договор + приложение
1 - Спецификация + счет
2 - Договор + счет', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ContractDataType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Схемы к оригинал макету', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'LayoutsSchemes'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Цветопроба', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ColorPick'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание персонализации', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'PersonalizationDescription'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Группы всех согласователей', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'AdaptingGroupID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор Технолога', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'TecEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата подписи технологом', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'TecSignedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Давальческое сырье"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'RawMatSuppliedByCustomer'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Спекл"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'RawMatSpekl'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Закупка у клиента"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'RawMatPurchaseByCustomer'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Подрядчик"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'RawMatIndepContractor'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вимоги до баз даних та передачі баз даних/Додаткові вимоги до персоналізації', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'DBRequirements'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Додаткові вимоги до пакування, пломбування та маркування', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'PackingRequirements'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Додаткові вимоги до продукції', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ProductionRequirements'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор причины отмены', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'CancelReasonID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вимоги до персоналізації', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'PersonalizeRequirements'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ЗЛ, который был заменен этим ЗЛ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'ChangedPCCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование давальческого сырья', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'RawMatSuppliedByCustomerName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер техкарты', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'TechCardNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Готовая продукция', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата ТЗ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'SpecificationDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Закупівля у постачальника"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'RawMatPurchaseIndepContractor'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Подрядчик 2"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'RawMatIndepContractor2'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Спекл_Трафарет"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'RawMatSpeklTraf'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор источника "Спекл_ЦИФРА"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'RawMatSpeklCyfra'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Оборот печати пвх. 0 свой 1 чужой', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'PVHPrintSide'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Формат пвх. 0 - A2(620*486) 1- A3(309*486)', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'PVHFormat'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Технолог присутствует при печати тиража', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'TechnologistPresence'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Детальные требования к персонализации', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'PersonalizeRequirementsExtended'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата получения базы данных', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'DBReceiveDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вес брутто', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'WeightGross'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'вес нетто', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'WeightNet'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип упаковки', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'PackingID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во мест груза', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'WeightPlaceCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор технологической карты', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'TechnologicalCardID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг сборочный тираж', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'isGroupedProduction'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'сборочные зл', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeHistory', 'COLUMN', N'GroupedZLText'
GO