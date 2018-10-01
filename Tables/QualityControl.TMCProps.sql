CREATE TABLE [QualityControl].[TMCProps] (
  [ID] [int] IDENTITY,
  [Name] [varchar](1000) NOT NULL,
  [ResultKind] [tinyint] NOT NULL,
  [ValueToCheck] [varchar](1000) NULL,
  [AssignedToQC] [bit] NULL,
  [AssignedToTestAct] [bit] NULL,
  [TMCID] [int] NOT NULL,
  [Status] [tinyint] NULL,
  [ObjectTypePropsID] [int] NULL,
  [ImportanceID] [tinyint] NOT NULL,
  CONSTRAINT [PK_TMCProps_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[TMCProps]
  ADD CONSTRAINT [FK_TMCProps_ObjectTypeProps (QualityControl)_ID] FOREIGN KEY ([ObjectTypePropsID]) REFERENCES [QualityControl].[ObjectTypeProps] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [QualityControl].[TMCProps]
  ADD CONSTRAINT [FK_TMCProps_PropImportance (QualityControl)_ID] FOREIGN KEY ([ImportanceID]) REFERENCES [QualityControl].[PropImportance] ([ID])
GO

ALTER TABLE [QualityControl].[TMCProps]
  ADD CONSTRAINT [FK_TMCProps_TMC_ID] FOREIGN KEY ([TMCID]) REFERENCES [dbo].[Tmc] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'TMCProps', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'TMCProps', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Классификация значения', 'SCHEMA', N'QualityControl', 'TABLE', N'TMCProps', 'COLUMN', N'ResultKind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Нормативное значение', 'SCHEMA', N'QualityControl', 'TABLE', N'TMCProps', 'COLUMN', N'ValueToCheck'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Для протоколв КК', 'SCHEMA', N'QualityControl', 'TABLE', N'TMCProps', 'COLUMN', N'AssignedToQC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Для акта тестирования на оборудовании', 'SCHEMA', N'QualityControl', 'TABLE', N'TMCProps', 'COLUMN', N'AssignedToTestAct'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор группы материалов', 'SCHEMA', N'QualityControl', 'TABLE', N'TMCProps', 'COLUMN', N'TMCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Настройка специфики наследования 1-перегружает настройки группы, 2-не используется-не выбирать х-ку для этого тмц,3-добавлена новая', 'SCHEMA', N'QualityControl', 'TABLE', N'TMCProps', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор настройки х-к для группы', 'SCHEMA', N'QualityControl', 'TABLE', N'TMCProps', 'COLUMN', N'ObjectTypePropsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор критичности', 'SCHEMA', N'QualityControl', 'TABLE', N'TMCProps', 'COLUMN', N'ImportanceID'
GO