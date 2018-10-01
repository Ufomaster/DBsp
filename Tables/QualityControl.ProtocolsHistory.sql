CREATE TABLE [QualityControl].[ProtocolsHistory] (
  [ID] [int] IDENTITY,
  [OperationType] [int] NOT NULL,
  [ModifyEmployeeID] [int] NOT NULL,
  [ModifyDate] [datetime] NOT NULL,
  [ProtocolsID] [int] NOT NULL,
  [EmployeeID] [int] NULL,
  [EmployeeSignDate] [datetime] NULL,
  [EmployeeSpecialistID] [int] NULL,
  [EmployeeSpecialistSignDate] [datetime] NULL,
  [TypesID] [tinyint] NULL,
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
  [isDeleted] [bit] NULL,
  [UnitID] [int] NULL,
  [TechCardNumber] [int] NULL,
  [TechNeedsCount] [int] NULL,
  [ActOfTestCreateDate] [datetime] NULL,
  [ActOfTestCloseDate] [datetime] NULL,
  CONSTRAINT [PK_ProtocolsHistory_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ProtocolsHistory_ProtocolsID]
  ON [QualityControl].[ProtocolsHistory] ([ProtocolsID])
  ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ProtocolsHistory]
  ADD CONSTRAINT [FK_ProtocolsHistory_Customers_ID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID])
GO

ALTER TABLE [QualityControl].[ProtocolsHistory]
  ADD CONSTRAINT [FK_ProtocolsHistory_Employees_ID] FOREIGN KEY ([ModifyEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[ProtocolsHistory]
  ADD CONSTRAINT [FK_ProtocolsHistory_Employees_ID2] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[ProtocolsHistory]
  ADD CONSTRAINT [FK_ProtocolsHistory_Employees_ID3] FOREIGN KEY ([EmployeeSpecialistID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[ProtocolsHistory]
  ADD CONSTRAINT [FK_ProtocolsHistory_Employees_ID4] FOREIGN KEY ([WarehouseEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[ProtocolsHistory]
  ADD CONSTRAINT [FK_ProtocolsHistory_ProductionCardCustomize_ID] FOREIGN KEY ([PCCID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

ALTER TABLE [QualityControl].[ProtocolsHistory]
  ADD CONSTRAINT [FK_ProtocolsHistory_Protocols (QualityControl)_ID] FOREIGN KEY ([ProtocolsID]) REFERENCES [QualityControl].[Protocols] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [QualityControl].[ProtocolsHistory]
  ADD CONSTRAINT [FK_ProtocolsHistory_StorageStructure (manufacture)_ID] FOREIGN KEY ([StorageStructureID]) REFERENCES [manufacture].[StorageStructure] ([ID])
GO

ALTER TABLE [QualityControl].[ProtocolsHistory]
  ADD CONSTRAINT [FK_ProtocolsHistory_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

ALTER TABLE [QualityControl].[ProtocolsHistory]
  ADD CONSTRAINT [FK_ProtocolsHistory_Types_ID] FOREIGN KEY ([TypesID]) REFERENCES [QualityControl].[Types] ([ID])
GO

ALTER TABLE [QualityControl].[ProtocolsHistory]
  ADD CONSTRAINT [FK_ProtocolsHistory_TypesStatuses (QualityControl)_ID] FOREIGN KEY ([StatusID]) REFERENCES [QualityControl].[TypesStatuses] ([ID])
GO

ALTER TABLE [QualityControl].[ProtocolsHistory]
  ADD CONSTRAINT [FK_ProtocolsHistory_Units_ID] FOREIGN KEY ([UnitID]) REFERENCES [dbo].[Units] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции 0-insert, 1-update, 2-delete', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsHistory', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника который зименил запись', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsHistory', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата изменений', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsHistory', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsHistory', 'COLUMN', N'ProtocolsID'
GO