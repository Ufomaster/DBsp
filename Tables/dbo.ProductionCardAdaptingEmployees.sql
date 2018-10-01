CREATE TABLE [dbo].[ProductionCardAdaptingEmployees] (
  [ID] [int] IDENTITY,
  [DepartmentPositionID] [int] NOT NULL,
  [TextColor] [varchar](16) NULL,
  CONSTRAINT [PK_ProductionCardAdaptingGroupEmployees_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardAdaptingEmployees]
  ADD CONSTRAINT [FK_ProductionCardAdaptingSchemeEmployees_DepartmentPositions_ID_ProductionCardAdaptingGroupEmployees] FOREIGN KEY ([DepartmentPositionID]) REFERENCES [dbo].[DepartmentPositions] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Список должностей штатного расписания, допущеных для участия в соглосовании', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingEmployees'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingEmployees', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор должности звена, согласовывающего  заказной лист', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingEmployees', 'COLUMN', N'DepartmentPositionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Цвет текста', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingEmployees', 'COLUMN', N'TextColor'
GO