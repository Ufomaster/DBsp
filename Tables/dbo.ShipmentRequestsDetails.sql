CREATE TABLE [dbo].[ShipmentRequestsDetails] (
  [ID] [int] IDENTITY,
  [PCCID] [int] NULL,
  [Name] [varchar](255) NULL,
  [Amount] [decimal](24, 4) NULL,
  [UnitID] [int] NULL,
  [PackTypeID] [tinyint] NULL,
  [Length] [smallint] NULL,
  [Width] [smallint] NULL,
  [Height] [smallint] NULL,
  [PackCount] [smallint] NULL,
  [Weight] [decimal](19, 2) NULL,
  [Comments] [varchar](255) NULL,
  [ShipmentRequestID] [int] NOT NULL,
  [TZ] [varchar](30) NULL,
  [TMCID] [int] NULL,
  CONSTRAINT [PK_ShipmentRequestsDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ShipmentRequestsDetails]
  ADD CONSTRAINT [FK_ShipmentRequestsDetails_PackTypes_ID] FOREIGN KEY ([PackTypeID]) REFERENCES [dbo].[PackTypes] ([ID])
GO

ALTER TABLE [dbo].[ShipmentRequestsDetails]
  ADD CONSTRAINT [FK_ShipmentRequestsDetails_ProductionCardCustomize_ID] FOREIGN KEY ([PCCID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

ALTER TABLE [dbo].[ShipmentRequestsDetails]
  ADD CONSTRAINT [FK_ShipmentRequestsDetails_ShipmentRequests_ID] FOREIGN KEY ([ShipmentRequestID]) REFERENCES [dbo].[ShipmentRequests] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ShipmentRequestsDetails]
  ADD CONSTRAINT [FK_ShipmentRequestsDetails_Tmc_ID] FOREIGN KEY ([TMCID]) REFERENCES [dbo].[Tmc] ([ID])
GO

ALTER TABLE [dbo].[ShipmentRequestsDetails]
  ADD CONSTRAINT [FK_ShipmentRequestsDetails_Units_ID] FOREIGN KEY ([UnitID]) REFERENCES [dbo].[Units] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'PCCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор единицы измерения', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'UnitID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа упаковки', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'PackTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Длинна', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'Length'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ширина', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'Width'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Высота', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'Height'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во тары', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'PackCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вес тары', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'Weight'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарии', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'Comments'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заявки', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'ShipmentRequestID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ТЗ по зл', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'TZ'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор материала', 'SCHEMA', N'dbo', 'TABLE', N'ShipmentRequestsDetails', 'COLUMN', N'TMCID'
GO