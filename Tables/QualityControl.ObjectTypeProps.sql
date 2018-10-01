CREATE TABLE [QualityControl].[ObjectTypeProps] (
  [ID] [int] IDENTITY,
  [Name] [varchar](1000) NOT NULL,
  [ResultKind] [tinyint] NOT NULL,
  [ValueToCheck] [varchar](1000) NULL,
  [AssignedToQC] [bit] NULL,
  [AssignedToTestAct] [bit] NULL,
  [SortOrder] [tinyint] NULL,
  [ObjectTypeID] [int] NOT NULL,
  [ImportanceID] [tinyint] NOT NULL,
  CONSTRAINT [PK_ObjectTypeProps_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ObjectTypeProps]
  ADD CONSTRAINT [FK_ObjectTypeProps_ObjectTypes_ID] FOREIGN KEY ([ObjectTypeID]) REFERENCES [dbo].[ObjectTypes] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [QualityControl].[ObjectTypeProps]
  ADD CONSTRAINT [FK_ObjectTypeProps_PropImportance (QualityControl)_ID] FOREIGN KEY ([ImportanceID]) REFERENCES [QualityControl].[PropImportance] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ObjectTypeProps', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'ObjectTypeProps', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Классификация значения', 'SCHEMA', N'QualityControl', 'TABLE', N'ObjectTypeProps', 'COLUMN', N'ResultKind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Нормативное значение', 'SCHEMA', N'QualityControl', 'TABLE', N'ObjectTypeProps', 'COLUMN', N'ValueToCheck'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Для протоколв КК', 'SCHEMA', N'QualityControl', 'TABLE', N'ObjectTypeProps', 'COLUMN', N'AssignedToQC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Для акта тестирования на оборудовании', 'SCHEMA', N'QualityControl', 'TABLE', N'ObjectTypeProps', 'COLUMN', N'AssignedToTestAct'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок сортировки', 'SCHEMA', N'QualityControl', 'TABLE', N'ObjectTypeProps', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор группы материалов', 'SCHEMA', N'QualityControl', 'TABLE', N'ObjectTypeProps', 'COLUMN', N'ObjectTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор критичности', 'SCHEMA', N'QualityControl', 'TABLE', N'ObjectTypeProps', 'COLUMN', N'ImportanceID'
GO