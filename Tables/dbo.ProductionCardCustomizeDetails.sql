CREATE TABLE [dbo].[ProductionCardCustomizeDetails] (
  [ID] [int] IDENTITY,
  [ProductionCardCustomizeID] [int] NOT NULL,
  [LinkedProductionCardCustomizeID] [int] NULL,
  [Norma] [decimal](32, 10) NULL,
  [UnitID] [int] NULL,
  [MaterialKind] [smallint] NULL,
  [TmcID] [int] NULL,
  [Kind] [tinyint] NULL DEFAULT (1),
  CONSTRAINT [PK_ProductionCardCustomizeAssemblyDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardCustomizeDetails_LinkedProductionCardCustomizeID]
  ON [dbo].[ProductionCardCustomizeDetails] ([LinkedProductionCardCustomizeID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardCustomizeDetails_ProductionCardCustomizeID]
  ON [dbo].[ProductionCardCustomizeDetails] ([ProductionCardCustomizeID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardCustomizeDetails_TmcID]
  ON [dbo].[ProductionCardCustomizeDetails] ([TmcID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardCustomizeDetails]
  ADD CONSTRAINT [FK_ProductionCardCustomizeAssemblyDetails_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ProductionCardCustomizeDetails]
  ADD CONSTRAINT [FK_ProductionCardCustomizeAssemblyDetails_ProductionCardCustomize_ID1] FOREIGN KEY ([LinkedProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomizeDetails]
  ADD CONSTRAINT [FK_ProductionCardCustomizeDetails_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomizeDetails]
  ADD CONSTRAINT [FK_ProductionCardCustomizeDetails_Units_UnitID] FOREIGN KEY ([UnitID]) REFERENCES [dbo].[Units] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа/шапка/сборочный зл', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetails', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ЗЛ составляющей', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetails', 'COLUMN', N'LinkedProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Норма', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetails', 'COLUMN', N'Norma'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Единицы измерения', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetails', 'COLUMN', N'UnitID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вид материала 0-Матеріал, 1-Напівфабрикат, 2-Прийняті до переробки', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetails', 'COLUMN', N'MaterialKind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор материала', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetails', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер этапа сборки', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDetails', 'COLUMN', N'Kind'
GO