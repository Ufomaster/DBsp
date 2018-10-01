CREATE TABLE [dbo].[ProductionCardCustomizeAdaptings] (
  [ID] [int] IDENTITY,
  [EmployeeID] [int] NOT NULL,
  [ProductionCardCustomizeID] [int] NOT NULL,
  [Date] [datetime] NOT NULL,
  [Status] [tinyint] NULL,
  [SignDate] [datetime] NULL,
  [StatusID] [smallint] NULL,
  CONSTRAINT [PK_ProductionCardCustomizeAdaptings_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardCustomizeAdaptings_ProductionCardCustomizeID]
  ON [dbo].[ProductionCardCustomizeAdaptings] ([ProductionCardCustomizeID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.ProductionCardCustomizeAdaptings.Date'
GO

ALTER TABLE [dbo].[ProductionCardCustomizeAdaptings]
  ADD CONSTRAINT [FK_ProductionCardCustomizeAdaptings_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ProductionCardCustomizeAdaptings]
  ADD CONSTRAINT [FK_ProductionCardCustomizeAdaptings_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ProductionCardCustomizeAdaptings]
  ADD CONSTRAINT [FK_ProductionCardCustomizeAdaptings_ProductionCardStatuses_ID] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[ProductionCardStatuses] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptings', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор согласуюущего сотрудника', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptings', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptings', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата вступления в согласование', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptings', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние Null - не обрабатывалось согласующим, 0-Есть претензии, 1-Нет претензий', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptings', 'COLUMN', N'Status'
GO