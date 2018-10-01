CREATE TABLE [QualityControl].[ActsTasks] (
  [ID] [int] IDENTITY,
  [Name] [varchar](800) NULL,
  [AssignedToEmployeeID] [int] NULL,
  [ControlEmployeeID] [int] NULL,
  [Status] [tinyint] NULL,
  [CreateDate] [datetime] NULL,
  [Comment] [varchar](1000) NULL,
  [ActID] [int] NULL,
  [TasksID] [int] NULL,
  [BeginFromDate] [datetime] NULL,
  CONSTRAINT [PK_ActsTasks_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActsTasks]
  ADD CONSTRAINT [FK_ActsTasks_Acts (QualityControl)_ID] FOREIGN KEY ([ActID]) REFERENCES [QualityControl].[Acts] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [QualityControl].[ActsTasks]
  ADD CONSTRAINT [FK_ActsTasks_Employees_ID1] FOREIGN KEY ([ControlEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[ActsTasks]
  ADD CONSTRAINT [FK_ActsTasks_Employees_ID2] FOREIGN KEY ([AssignedToEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[ActsTasks]
  ADD CONSTRAINT [FK_ActsTasks_Tasks_ID] FOREIGN KEY ([TasksID]) REFERENCES [dbo].[Tasks] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsTasks', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание задачи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsTasks', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ответственный', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsTasks', 'COLUMN', N'AssignedToEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Контролирующий', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsTasks', 'COLUMN', N'ControlEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Желаемый статус задачи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsTasks', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания будущей задачи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsTasks', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsTasks', 'COLUMN', N'Comment'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор акта НС', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsTasks', 'COLUMN', N'ActID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор реальной созданной задачи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsTasks', 'COLUMN', N'TasksID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Начать выполение в дату', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsTasks', 'COLUMN', N'BeginFromDate'
GO