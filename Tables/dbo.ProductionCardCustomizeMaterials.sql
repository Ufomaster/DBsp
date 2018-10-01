CREATE TABLE [dbo].[ProductionCardCustomizeMaterials] (
  [ID] [int] IDENTITY,
  [ProductionCardCustomizeID] [int] NOT NULL,
  [Norma] [decimal](38, 10) NOT NULL,
  [ModifyEmployeeID] [int] NULL,
  [ModifyDate] [datetime] NULL,
  [OriginalNorma] [decimal](38, 10) NULL,
  [TmcID] [int] NOT NULL,
  [is1CSpecNode] [bit] NULL,
  [PlanNorma] [decimal](38, 10) NULL,
  CONSTRAINT [PK_ProductionCardCustomizeMaterials_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardCustomizeMaterials_ProductionCardCustomizeID]
  ON [dbo].[ProductionCardCustomizeMaterials] ([ProductionCardCustomizeID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardCustomizeMaterials]
  ADD CONSTRAINT [FK_ProductionCardCustomizeMaterials_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ProductionCardCustomizeMaterials]
  ADD CONSTRAINT [FK_ProductionCardCustomizeMaterials_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeMaterials', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeMaterials', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Норма расхода для производства', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeMaterials', 'COLUMN', N'Norma'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника, изменившего норму', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeMaterials', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата изменения нормы', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeMaterials', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Норма, расчитанная автоматически, копия PlanNorma', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeMaterials', 'COLUMN', N'OriginalNorma'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор материала', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeMaterials', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пометка что запись является узлом спецификации 1с.', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeMaterials', 'COLUMN', N'is1CSpecNode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Плановая норма, которая рассчитывается формулами и передается в 1с', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeMaterials', 'COLUMN', N'PlanNorma'
GO