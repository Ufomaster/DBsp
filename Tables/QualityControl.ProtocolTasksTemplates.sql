CREATE TABLE [QualityControl].[ProtocolTasksTemplates] (
  [ID] [int] IDENTITY,
  [Name] [varchar](800) NOT NULL,
  [AssignedToEmployeeID] [int] NOT NULL,
  [ControlEmployeeID] [int] NOT NULL,
  [Status] [tinyint] NOT NULL DEFAULT (1),
  [RepeatPeriod] [smallint] NOT NULL DEFAULT (1),
  CONSTRAINT [PK_ProtocolTasksTemplates_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolTasksTemplates', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание задачи', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolTasksTemplates', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ответственный', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolTasksTemplates', 'COLUMN', N'AssignedToEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Контролирующий', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolTasksTemplates', 'COLUMN', N'ControlEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Желаемый статус задачи', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolTasksTemplates', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сдвиг к дате в днях', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolTasksTemplates', 'COLUMN', N'RepeatPeriod'
GO