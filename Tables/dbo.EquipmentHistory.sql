CREATE TABLE [dbo].[EquipmentHistory] (
  [ID] [int] IDENTITY,
  [EquipmentID] [int] NOT NULL,
  [TmcID] [int] NOT NULL,
  [TmcName] [varchar](252) NULL,
  [InventoryNum] [varchar](50) NULL,
  [SerialNum] [varchar](100) NULL,
  [CommissioningDate] [datetime] NULL,
  [CommissioningDocNum] [varchar](30) NULL,
  [RetirementDate] [datetime] NULL,
  [RetirementDocNum] [varchar](30) NULL,
  [Status] [int] NULL,
  [StatusName] [varchar](50) NULL,
  [DepartmentPositionID] [int] NULL,
  [DepartmentPositionName] [varchar](250) NULL,
  [EquipmentPlaceID] [int] NULL,
  [EquipmentPlaceName] [varchar](250) NULL,
  [EquipTerms] [int] NULL,
  [WarrantyTerms] [int] NULL,
  [InvoiceDetailID] [int] NULL,
  [ModifyDate] [datetime] NOT NULL CONSTRAINT [DF_EquipmentHistory_ModifyDate] DEFAULT (getdate()),
  [ModifyEmployeeID] [int] NOT NULL,
  [OperationType] [int] NULL,
  CONSTRAINT [PK_EquipmentHistory_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Инвентарный номер', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'InventoryNum'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Серийный номер, при наличии', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'SerialNum'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата ввода в эксплуатацию', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'CommissioningDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер акта ввода в эксплуатацию', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'CommissioningDocNum'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата списания', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'RetirementDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер акта списания', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'RetirementDocNum'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние ОС. 0-в разработке, 1-эксплуатируется, 2-списано', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор. Закрепление за штатным расписанием', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'DepartmentPositionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор местоположения', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'EquipmentPlaceID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Срок эксплуатации, мес', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'EquipTerms'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Срок гарантии, мес', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'WarrantyTerms'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор позиции счета', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'InvoiceDetailID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата модификации', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пользователь, изменивший данные', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции 0-вставка, 1-апдейт, 2-удаление', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentHistory', 'COLUMN', N'OperationType'
GO