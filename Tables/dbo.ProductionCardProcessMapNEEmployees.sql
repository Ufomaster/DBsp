CREATE TABLE [dbo].[ProductionCardProcessMapNEEmployees] (
  [ID] [int] IDENTITY,
  [DepartmentPositionID] [int] NOT NULL,
  [UseAdaptingFiltering] [bit] NOT NULL,
  [ProductionCardProcessMapID] [int] NOT NULL,
  CONSTRAINT [PK_ProductionCardProcessMapNEEmployees_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardProcessMapNEEmployees.UseAdaptingFiltering'
GO

ALTER TABLE [dbo].[ProductionCardProcessMapNEEmployees]
  ADD CONSTRAINT [FK_ProductionCardProcessMapNEEmployees_DepartmentPositions_ID] FOREIGN KEY ([DepartmentPositionID]) REFERENCES [dbo].[DepartmentPositions] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ProductionCardProcessMapNEEmployees]
  ADD CONSTRAINT [FK_ProductionCardProcessMapNEEmployees_ProductionCardProcessMap_ID] FOREIGN KEY ([ProductionCardProcessMapID]) REFERENCES [dbo].[ProductionCardProcessMap] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMapNEEmployees', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор вакансии', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMapNEEmployees', 'COLUMN', N'DepartmentPositionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг - использовать фильтрацию выбора этого сотрудника по списку групп согласователей', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMapNEEmployees', 'COLUMN', N'UseAdaptingFiltering'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор процесса прохождения', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardProcessMapNEEmployees', 'COLUMN', N'ProductionCardProcessMapID'
GO