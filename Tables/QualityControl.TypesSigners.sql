CREATE TABLE [QualityControl].[TypesSigners] (
  [ID] [int] IDENTITY,
  [TypesID] [tinyint] NOT NULL,
  [DepartmentPositionID] [int] NOT NULL,
  [EmailOnly] [bit] NULL,
  CONSTRAINT [PK_TypesSigners_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[TypesSigners]
  ADD CONSTRAINT [FK_QuaConTypesSigners_DepartmentPositions_ID] FOREIGN KEY ([DepartmentPositionID]) REFERENCES [dbo].[DepartmentPositions] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [QualityControl].[TypesSigners]
  ADD CONSTRAINT [FK_TypesSigners_Types_ID] FOREIGN KEY ([TypesID]) REFERENCES [QualityControl].[Types] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Список подписывающих лиц и получателей Email', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesSigners'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesSigners', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesSigners', 'COLUMN', N'TypesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор вакансии', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesSigners', 'COLUMN', N'DepartmentPositionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг 0 - не требовать подписи, только отлылать Email', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesSigners', 'COLUMN', N'EmailOnly'
GO