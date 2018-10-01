CREATE TABLE [dbo].[ProductionCardAdaptingGroupEmployees] (
  [ID] [int] IDENTITY,
  [AdaptingGroupID] [int] NULL,
  [ProductionCardAdaptingGroupEmployeesID] [int] NULL,
  CONSTRAINT [PK_ProductionCardAdaptingGroupEmployees_ID1] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardAdaptingGroupEmployees]
  ADD CONSTRAINT [FK_ProductionCardAdaptingGroupEmployeesLinked_ProductionCardAdaptingGroupEmployees_ID] FOREIGN KEY ([ProductionCardAdaptingGroupEmployeesID]) REFERENCES [dbo].[ProductionCardAdaptingEmployees] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardAdaptingGroupEmployees]
  ADD CONSTRAINT [FK_ProductionCardAdaptingGroups_AdaptingGroupsID_ID] FOREIGN KEY ([AdaptingGroupID]) REFERENCES [dbo].[ProductionCardAdaptingGroups] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Связка групп согласователей с позициями штатного расписания', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingGroupEmployees'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingGroupEmployees', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на группу согласователей', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingGroupEmployees', 'COLUMN', N'AdaptingGroupID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на позицию в штатке', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingGroupEmployees', 'COLUMN', N'ProductionCardAdaptingGroupEmployeesID'
GO