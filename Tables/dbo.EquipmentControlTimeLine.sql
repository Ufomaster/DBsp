CREATE TABLE [dbo].[EquipmentControlTimeLine] (
  [ID] [int] IDENTITY,
  [StartDate] [datetime] NOT NULL,
  [EndDate] [datetime] NULL,
  [EquipmentControlID] [int] NOT NULL,
  [EquipmentStateID] [int] NOT NULL,
  [AuthorID] [int] NULL,
  CONSTRAINT [PK_EquipmentControlTimeline_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[EquipmentControlTimeLine]
  ADD CONSTRAINT [FK_EquipmentControlTimeLine_Employees_ID] FOREIGN KEY ([AuthorID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[EquipmentControlTimeLine]
  ADD CONSTRAINT [FK_EquipmentControlTimeLine_EquipmentControl_ID] FOREIGN KEY ([EquipmentControlID]) REFERENCES [dbo].[EquipmentControl] ([ID])
GO

ALTER TABLE [dbo].[EquipmentControlTimeLine]
  ADD CONSTRAINT [FK_EquipmentControlTimeLine_EquipmentStates_ID] FOREIGN KEY ([EquipmentStateID]) REFERENCES [dbo].[EquipmentStates] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControlTimeLine', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата запуска оборудования', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControlTimeLine', 'COLUMN', N'StartDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата останова оборудования', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControlTimeLine', 'COLUMN', N'EndDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор точки контроля оборудования', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControlTimeLine', 'COLUMN', N'EquipmentControlID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние оборудования', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControlTimeLine', 'COLUMN', N'EquipmentStateID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника, изменившего данные', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentControlTimeLine', 'COLUMN', N'AuthorID'
GO