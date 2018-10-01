CREATE TABLE [dbo].[Tasks] (
  [ID] [int] IDENTITY,
  [Name] [varchar](max) NULL,
  [EmployeeAuthorID] [int] NULL,
  [AssignedToEmployeeID] [int] NULL,
  [ControlEmployeeID] [int] NULL,
  [Status] [tinyint] NULL,
  [CreateDate] [datetime] NULL,
  [StartDate] [datetime] NULL,
  [FinishDate] [datetime] NULL,
  [ResultMarkID] [tinyint] NULL,
  [Type] [tinyint] NULL,
  [Comment] [varchar](max) NULL,
  [QCActID] [int] NULL,
  [BeginFromDate] [datetime] NULL,
  [Kind] [tinyint] NULL,
  [Severity] [tinyint] NULL,
  [QCProtocolID] [int] NULL,
  [DocNumber] [varchar](50) NULL,
  [DocDate] [datetime] NULL,
  [FilePath] [varchar](255) NULL,
  [Results] [varchar](max) NULL,
  CONSTRAINT [PK_Tasks_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_Tasks_CreateDate]
  ON [dbo].[Tasks] ([CreateDate])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Tasks_EmployeeAuthorID_AssignedToEmployeeID_ControlEmployeeID]
  ON [dbo].[Tasks] ([EmployeeAuthorID], [AssignedToEmployeeID], [ControlEmployeeID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Tasks_Status]
  ON [dbo].[Tasks] ([Status])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[Tasks]
  ADD CONSTRAINT [FK_Tasks_Acts (QualityControl)_ID] FOREIGN KEY ([QCActID]) REFERENCES [QualityControl].[Acts] ([ID])
GO

ALTER TABLE [dbo].[Tasks]
  ADD CONSTRAINT [FK_Tasks_Employees_ID1] FOREIGN KEY ([EmployeeAuthorID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[Tasks]
  ADD CONSTRAINT [FK_Tasks_Employees_ID2] FOREIGN KEY ([AssignedToEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[Tasks]
  ADD CONSTRAINT [FK_Tasks_Employees_ID3] FOREIGN KEY ([ControlEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[Tasks]
  ADD CONSTRAINT [FK_Tasks_Protocols (QualityControl)_ID] FOREIGN KEY ([QCProtocolID]) REFERENCES [QualityControl].[Protocols] ([ID])
GO

ALTER TABLE [dbo].[Tasks]
  ADD CONSTRAINT [FK_Tasks_TasksResultMarks_ID] FOREIGN KEY ([ResultMarkID]) REFERENCES [dbo].[TasksResultMarks] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор автора', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'EmployeeAuthorID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор ответственного ', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'AssignedToEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор контролирующего', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'ControlEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания задачи', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата начала', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'StartDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата завершения', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'FinishDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор оценки результативности', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'ResultMarkID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип задачи vw_TasksTypes', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'Comment'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор акта', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'QCActID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Начать выполение в дату', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'BeginFromDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вид задачи 0-Предупреждающая 1- Корректирующая.', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'Kind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Важность 0-низький, 1-середній, 2-високий', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'Severity'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор протокола', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'QCProtocolID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер приказа/распоряжения', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'DocNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата приказа документа', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'DocDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Путь к файлу', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'FilePath'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Результат задания', 'SCHEMA', N'dbo', 'TABLE', N'Tasks', 'COLUMN', N'Results'
GO