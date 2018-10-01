CREATE TABLE [dbo].[Equipment] (
  [ID] [int] IDENTITY,
  [TmcID] [int] NOT NULL,
  [InventoryNum] [varchar](50) NULL,
  [SerialNum] [varchar](100) NULL,
  [CommissioningDate] [datetime] NULL,
  [CommissioningDocNum] [varchar](30) NULL,
  [RetirementDate] [datetime] NULL,
  [RetirementDocNum] [varchar](30) NULL,
  [Status] [int] NULL,
  [DepartmentPositionID] [int] NULL,
  [EquipmentPlaceID] [int] NULL,
  [EquipTerms] [int] NULL,
  [WarrantyTerms] [int] NULL,
  [InvoiceDetailID] [int] NULL,
  [WorkTotalsPresent] [bit] NULL,
  [UnitID] [int] NULL,
  CONSTRAINT [PK_Equipment_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_Equipment_DepartmentPositionID]
  ON [dbo].[Equipment] ([DepartmentPositionID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Equipment_TmcID]
  ON [dbo].[Equipment] ([TmcID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[Equipment]
  ADD CONSTRAINT [FK_Equipment_DepartmentPositions_ID] FOREIGN KEY ([DepartmentPositionID]) REFERENCES [dbo].[DepartmentPositions] ([ID])
GO

ALTER TABLE [dbo].[Equipment]
  ADD CONSTRAINT [FK_Equipment_EquipmentPlaces_ID] FOREIGN KEY ([EquipmentPlaceID]) REFERENCES [dbo].[EquipmentPlaces] ([ID])
GO

ALTER TABLE [dbo].[Equipment]
  ADD CONSTRAINT [FK_Equipment_InvoiceDetail_ID] FOREIGN KEY ([InvoiceDetailID]) REFERENCES [dbo].[InvoiceDetail] ([ID])
GO

ALTER TABLE [dbo].[Equipment]
  ADD CONSTRAINT [FK_Equipment_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

ALTER TABLE [dbo].[Equipment]
  ADD CONSTRAINT [FK_Equipment_Units_ID] FOREIGN KEY ([UnitID]) REFERENCES [dbo].[Units] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Инвентарный номер', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'InventoryNum'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Серийный номер, при наличии', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'SerialNum'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата ввода в эксплуатацию', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'CommissioningDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер акта ввода в эксплуатацию', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'CommissioningDocNum'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата списания', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'RetirementDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер акта списания', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'RetirementDocNum'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние ОС. 0-в разработке, 1-эксплуатируется, 2-списано', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор. Закрепление за штатным расписанием', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'DepartmentPositionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор местоположения', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'EquipmentPlaceID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Срок эксплуатации, мес', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'EquipTerms'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Срок гарантии, мес', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'WarrantyTerms'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор позиции счета', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'InvoiceDetailID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Обязательная наработка', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'WorkTotalsPresent'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор измерения выработки', 'SCHEMA', N'dbo', 'TABLE', N'Equipment', 'COLUMN', N'UnitID'
GO