CREATE TABLE [dbo].[ProductionCardCustomizeTechOp] (
  [ID] [int] IDENTITY,
  [ProductionCardCustomizeID] [int] NULL,
  [TechOperationID] [int] NULL,
  [Amount] [decimal](38, 10) NULL,
  [CreateDate] [datetime] NULL,
  [EmployeeID] [int] NULL,
  [TechnologicalOperationID] [int] NULL,
  [StorageStructureSectorID] [tinyint] NULL,
  CONSTRAINT [PK_ProductionCardCustomizeTechOp_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.ProductionCardCustomizeTechOp.CreateDate'
GO

ALTER TABLE [dbo].[ProductionCardCustomizeTechOp]
  ADD CONSTRAINT [FK_ProductionCardCustomizeTechOp_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomizeTechOp]
  ADD CONSTRAINT [FK_ProductionCardCustomizeTechOp_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ProductionCardCustomizeTechOp]
  ADD CONSTRAINT [FK_ProductionCardCustomizeTechOp_StorageStructureSectors_ID] FOREIGN KEY ([StorageStructureSectorID]) REFERENCES [manufacture].[StorageStructureSectors] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomizeTechOp]
  ADD CONSTRAINT [FK_ProductionCardCustomizeTechOp_TechnologicalOperations_ID] FOREIGN KEY ([TechnologicalOperationID]) REFERENCES [manufacture].[TechnologicalOperations] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomizeTechOp]
  ADD CONSTRAINT [FK_ProductionCardCustomizeTechOp_TechOperations_ID] FOREIGN KEY ([TechOperationID]) REFERENCES [dbo].[TechOperations] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeTechOp', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ЗЛ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeTechOp', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор тех оп. Оставлено для кликвью для обратной совместимости', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeTechOp', 'COLUMN', N'TechOperationID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeTechOp', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeTechOp', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeTechOp', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор Технологическая операция из 1с', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeTechOp', 'COLUMN', N'TechnologicalOperationID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентфикатор участка технологической операции', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeTechOp', 'COLUMN', N'StorageStructureSectorID'
GO