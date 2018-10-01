CREATE TABLE [shifts].[ShiftsTypes] (
  [ID] [tinyint] IDENTITY,
  [Name] [varchar](255) NULL,
  [TimeStart] [datetime] NOT NULL,
  [TimeEnd] [datetime] NOT NULL,
  [ManufactureStructureID] [smallint] NOT NULL,
  [CheckHrs] [tinyint] NULL,
  [ShiftsGroupsID] [int] NULL,
  [ShiftsTypesNamesID] [int] NULL,
  CONSTRAINT [PK_ShiftsTypes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [shifts].[ShiftsTypes]
  ADD CONSTRAINT [FK_ShiftsTypes_ManufactureStructure (manufacture)_ID] FOREIGN KEY ([ManufactureStructureID]) REFERENCES [manufacture].[ManufactureStructure] ([ID])
GO

ALTER TABLE [shifts].[ShiftsTypes]
  ADD CONSTRAINT [FK_ShiftsTypes_ShiftsGroups_ID] FOREIGN KEY ([ShiftsGroupsID]) REFERENCES [shifts].[ShiftsGroups] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [shifts].[ShiftsTypes]
  ADD CONSTRAINT [FK_ShiftsTypes_ShiftsTypesNames_ID] FOREIGN KEY ([ShiftsTypesNamesID]) REFERENCES [shifts].[ShiftsTypesNames] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Смены - Перечень(справочник)', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsTypes'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование смены', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsTypes', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Время начала смены', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsTypes', 'COLUMN', N'TimeStart'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Время окончания смены', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsTypes', 'COLUMN', N'TimeEnd'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор структуры', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsTypes', 'COLUMN', N'ManufactureStructureID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Периодичность проверки в часах', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsTypes', 'COLUMN', N'CheckHrs'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Группа смен', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsTypes', 'COLUMN', N'ShiftsGroupsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имена смен', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsTypes', 'COLUMN', N'ShiftsTypesNamesID'
GO