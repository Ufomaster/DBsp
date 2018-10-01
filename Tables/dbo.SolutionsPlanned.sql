CREATE TABLE [dbo].[SolutionsPlanned] (
  [ID] [int] IDENTITY,
  [Type] [int] NULL,
  [Days] [int] NULL,
  [Name] [varchar](2000) NULL,
  [Date] [datetime] NULL,
  [ColorIndex] [int] NULL,
  [CreateDate] [datetime] NULL,
  [CloseDate] [datetime] NULL,
  [DepartmentID] [int] NULL,
  [EquipmentID] [int] NULL,
  [TargetID] [tinyint] NULL,
  CONSTRAINT [PK_SolutionsPlanned_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[SolutionsPlanned]
  ADD CONSTRAINT [FK_SolutionsPlanned_Equipment_ID] FOREIGN KEY ([EquipmentID]) REFERENCES [dbo].[Equipment] ([ID])
GO

ALTER TABLE [dbo].[SolutionsPlanned]
  ADD CONSTRAINT [FK_SolutionsPlanned_RequestTarget_ID] FOREIGN KEY ([TargetID]) REFERENCES [dbo].[RequestTarget] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Список планируемых работ', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlanned'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlanned', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип 0 - разовая, 1- периодическая(дни), 2-пер. (помесячно)', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlanned', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Периодичность в днях', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlanned', 'COLUMN', N'Days'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание работы', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlanned', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата для разового типа', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlanned', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Выделяем цветом', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlanned', 'COLUMN', N'ColorIndex'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания планового задания', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlanned', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата закрытия плановой работы', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlanned', 'COLUMN', N'CloseDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Подразделение, отвечающее за решение плановой работы', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlanned', 'COLUMN', N'DepartmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор оборудования', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlanned', 'COLUMN', N'EquipmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор целевого департамента', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlanned', 'COLUMN', N'TargetID'
GO