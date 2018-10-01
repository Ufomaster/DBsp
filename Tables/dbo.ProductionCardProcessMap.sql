CREATE TABLE [dbo].[ProductionCardProcessMap] (
  [ID] [int] IDENTITY,
  [Type] [smallint] NOT NULL,
  [StatusID] [smallint] NOT NULL,
  [GoStatusID] [smallint] NOT NULL,
  [NotifyEventID] [int] NULL,
  [SetManSignedDate] [bit] NOT NULL,
  [SetManSignedDateClear] [bit] NOT NULL,
  [SetTecSignedDate] [bit] NOT NULL,
  [SetTecSignedDateClear] [bit] NOT NULL,
  [SetCompleteDate] [bit] NOT NULL,
  [SetProductionDate] [bit] NOT NULL,
  [CheckAdaptingEmployees] [bit] NOT NULL,
  [CheckReleaseDates] [bit] NOT NULL,
  [CheckFieldNumber] [bit] NOT NULL,
  [CheckFieldCardCountInvoice] [bit] NOT NULL,
  [CheckFieldName] [bit] NOT NULL,
  [CheckFieldSketchFileName] [bit] NOT NULL,
  [CheckFieldSourceType] [bit] NOT NULL,
  [CheckOrigSchemesText] [bit] NOT NULL,
  [CheckDBFields] [bit] NOT NULL,
  [CheckDetailsNormaUnit] [bit] NOT NULL,
  [CheckDBRequirements] [bit] NOT NULL,
  [CheckInstructionExistance] [bit] NOT NULL,
  [CheckCancelReasonID] [bit] NOT NULL,
  [NeedAdaptingCheck] [bit] NOT NULL,
  [NeedDetailsFillCheck] [bit] NOT NULL,
  [NeedTechFillCheck] [bit] NOT NULL,
  [UseSendNotifyToManager] [bit] NOT NULL,
  [UseSendNotifyToTech] [bit] NOT NULL,
  [UseSendNotifyToAllAdaptingMembers] [bit] NOT NULL,
  [CheckLayoutsExistance] [bit] NOT NULL,
  [CheckPersRequirements] [bit] NOT NULL,
  [CheckRawMatSuplierCustomerName] [bit] NOT NULL,
  [CheckSpecificationDate] [bit] NOT NULL,
  [SetTO] [bit] NOT NULL,
  [CheckTechCardNumber] [bit] NOT NULL,
  [CheckisGroupedProduction] [bit] NOT NULL,
  [CheckWeight] [bit] NOT NULL,
  CONSTRAINT [PK_ProductionCardProcessMap_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.SetManSignedDate'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.SetManSignedDateClear'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.SetTecSignedDate'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.SetTecSignedDateClear'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.SetCompleteDate'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.SetProductionDate'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckAdaptingEmployees'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckReleaseDates'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckFieldNumber'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckFieldCardCountInvoice'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckFieldName'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckFieldSketchFileName'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckFieldSourceType'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckOrigSchemesText'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckDBFields'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckDetailsNormaUnit'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckDBRequirements'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckInstructionExistance'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckCancelReasonID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.NeedAdaptingCheck'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.NeedDetailsFillCheck'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.NeedTechFillCheck'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.UseSendNotifyToManager'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.UseSendNotifyToTech'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.UseSendNotifyToAllAdaptingMembers'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckLayoutsExistance'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckPersRequirements'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckRawMatSuplierCustomerName'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckSpecificationDate'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.SetTO'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckTechCardNumber'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckisGroupedProduction'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMap.CheckWeight'
GO

ALTER TABLE [dbo].[ProductionCardProcessMap]
  ADD CONSTRAINT [FK_ProductionCardProcessMap_NotifyEvents_ID] FOREIGN KEY ([NotifyEventID]) REFERENCES [dbo].[NotifyEvents] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardProcessMap]
  ADD CONSTRAINT [FK_ProductionCardProcessMap_ProductionCardStatuses_ID1] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[ProductionCardStatuses] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardProcessMap]
  ADD CONSTRAINT [FK_ProductionCardProcessMap_ProductionCardStatuses_ID2] FOREIGN KEY ([GoStatusID]) REFERENCES [dbo].[ProductionCardStatuses] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardProcessMap]
  ADD CONSTRAINT [FK_ProductionCardProcessMap_ProductionCardTypes_ID] FOREIGN KEY ([Type]) REFERENCES [dbo].[ProductionCardTypes] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Разрешенный для перехода статус заказного листа.', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'GoStatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сообщения, которое нужно отослать при переходе', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'NotifyEventID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Нужно ли установаить дату подписи менеджера', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'SetManSignedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Нужно ли снять дату подписи менеджера', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'SetManSignedDateClear'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Нужно ли установить дату подписи технолога', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'SetTecSignedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Нужно ли снять дату подписи технолога', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'SetTecSignedDateClear'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Нужно ли установить дату завершенности ЗЛ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'SetCompleteDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Установить дату в производство', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'SetProductionDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Выполнять ли проверку и апдейт списка согласовующих лиц', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckAdaptingEmployees'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Выполнять ли проверку наличия хотя бы одной даты сдачи в производство', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckReleaseDates'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер. Проверить заполненость поля.', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckFieldNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Количество карт. Проверить заполненость поля.', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckFieldCardCountInvoice'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование. Проверить заполненость поля.', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckFieldName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование оригинал макета. Проверить заполненость поля.', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckFieldSketchFileName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверить заполненость полей персонализация, заготовка для всех источников сырья', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckFieldSourceType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Схеми до оригінал макету. Проверить заполненость поля.', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckOrigSchemesText'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверять поля БД', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckDBFields'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверять заполнение норм и единиц измерения комплектов', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckDetailsNormaUnit'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вимоги до баз даних та передачі баз даних Проверить заполненность поля.', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckDBRequirements'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Инструкция по сборке/порядок збирання для спецификації. Проверить заполненость поля.', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckInstructionExistance'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Причина отмены/замены/остановки. Проверять заполнение.', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckCancelReasonID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Нужно ли выполнить проверку согласования листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'NeedAdaptingCheck'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверять наличие деталей', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'NeedDetailsFillCheck'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверка заполненности технологии', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'NeedTechFillCheck'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Использовать менеджера в рассылке', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'UseSendNotifyToManager'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Использовать рассылку технологу', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'UseSendNotifyToTech'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Использовать рассылку всем подсоединённым к ЗЛ согласователям', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'UseSendNotifyToAllAdaptingMembers'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверить наличие макетов', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckLayoutsExistance'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверять заполнение вимоги до персоналізації ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckPersRequirements'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверять заполнение наименования давальческого сырья', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckRawMatSuplierCustomerName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверять заполненность поля Дата ТЗ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckSpecificationDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Заполнить ТО', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'SetTO'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Заполнение поля "№ техкарти"', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckTechCardNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Требовать заполнение поля соборочный тираж', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckisGroupedProduction'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверка габаритов и веса', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMap', 'COLUMN', N'CheckWeight'
GO