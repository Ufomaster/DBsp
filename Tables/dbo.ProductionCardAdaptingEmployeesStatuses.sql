CREATE TABLE [dbo].[ProductionCardAdaptingEmployeesStatuses] (
  [ID] [int] IDENTITY,
  [ProductionCardAdaptingEmployeesID] [int] NOT NULL,
  [ProductionCardStatusesID] [smallint] NOT NULL,
  CONSTRAINT [PK_ProductionCardAdaptingEmployeesStatuses_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardAdaptingEmployeesStatuses]
  ADD CONSTRAINT [FK_ProductionCardAdaptingEmployeesStatuses_ProductionCardAdaptingEmployees_ID] FOREIGN KEY ([ProductionCardAdaptingEmployeesID]) REFERENCES [dbo].[ProductionCardAdaptingEmployees] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ProductionCardAdaptingEmployeesStatuses]
  ADD CONSTRAINT [FK_ProductionCardAdaptingEmployeesStatuses_ProductionCardStatuses_ID] FOREIGN KEY ([ProductionCardStatusesID]) REFERENCES [dbo].[ProductionCardStatuses] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingEmployeesStatuses', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор согласователя', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingEmployeesStatuses', 'COLUMN', N'ProductionCardAdaptingEmployeesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingEmployeesStatuses', 'COLUMN', N'ProductionCardStatusesID'
GO