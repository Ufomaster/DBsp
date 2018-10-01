CREATE TABLE [QualityControl].[ActsHistoryTasks] (
  [ID] [int] IDENTITY,
  [ActsHistoryID] [int] NULL,
  [Name] [varchar](800) NULL,
  [AssignedToEmployeeID] [int] NULL,
  [ControlEmployeeID] [int] NULL,
  [Status] [tinyint] NULL,
  [CreateDate] [datetime] NULL,
  [Comment] [varchar](1000) NULL,
  [TasksID] [int] NULL,
  [BeginFromDate] [datetime] NULL,
  CONSTRAINT [PK_ActsHistoryTasks_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActsHistoryTasks]
  ADD CONSTRAINT [FK_ActsHistoryTasks_ActsHistory (QualityControl)_ID] FOREIGN KEY ([ActsHistoryID]) REFERENCES [QualityControl].[ActsHistory] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryTasks', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание задачи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryTasks', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ответственный', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryTasks', 'COLUMN', N'AssignedToEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Контролирующий', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryTasks', 'COLUMN', N'ControlEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Желаемый статус задачи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryTasks', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания будущей задачи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryTasks', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryTasks', 'COLUMN', N'Comment'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор реальной созданной задачи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryTasks', 'COLUMN', N'TasksID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Начать выполение в дату', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryTasks', 'COLUMN', N'BeginFromDate'
GO