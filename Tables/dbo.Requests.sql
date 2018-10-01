CREATE TABLE [dbo].[Requests] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NOT NULL CONSTRAINT [DF_Requests_Date] DEFAULT (getdate()),
  [Description] [varchar](max) NULL,
  [EmployeeID] [int] NOT NULL,
  [Solution] [varchar](max) NULL,
  [PlanDate] [datetime] NULL,
  [SolutionEmployeeID] [int] NULL,
  [Severity] [int] NOT NULL CONSTRAINT [DF_Requests_Severity] DEFAULT (1),
  [Status] [int] NOT NULL CONSTRAINT [DF_Requests_Status] DEFAULT (0),
  [DepartmentID] [int] NULL,
  [Deleted] [bit] NOT NULL CONSTRAINT [DF_Requests_Delete] DEFAULT (0),
  [EquipmentID] [int] NULL,
  [DesiredDate] [datetime] NULL,
  [Accepted] [bit] NOT NULL CONSTRAINT [DF_Requests_Accepted] DEFAULT (0),
  [AcceptDate] [datetime] NULL,
  [AcceptEmployeeID] [int] NULL,
  [WriteTime] [int] NULL,
  [MalfunctionCauseID] [int] NULL,
  [WorkTotals] [int] NULL,
  [TargetID] [tinyint] NULL,
  CONSTRAINT [PK_Requests_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Requests]
  ADD CONSTRAINT [FK_Requests_Employees_ID] FOREIGN KEY ([SolutionEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[Requests]
  ADD CONSTRAINT [FK_Requests_Employees_ID2] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[Requests]
  ADD CONSTRAINT [FK_Requests_Equipment_ID] FOREIGN KEY ([EquipmentID]) REFERENCES [dbo].[Equipment] ([ID])
GO

ALTER TABLE [dbo].[Requests]
  ADD CONSTRAINT [FK_Requests_RequestTarget_ID] FOREIGN KEY ([TargetID]) REFERENCES [dbo].[RequestTarget] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания заявки', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание проблемы', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пользователь создатель заявки', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Решение проблемы', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'Solution'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Планируемая дата окончания работ по заявке', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'PlanDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ответсвенный за решение заявки', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'SolutionEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Важность 0-низкая 1-средняя 2-высокая', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'Severity'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус заявки 0-новая, 1-прочтена, 2-выполняется, 3-отменена, 4-выполнена, 5-заново открыта,6 - Отложена', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор подразделения', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'DepartmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Признак того что заявка была удалена', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'Deleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор оборудования', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'EquipmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Желаемая дата выполнения', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'DesiredDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Подтверждение заявки 0-не подтверждена, 1 подтверждена', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'Accepted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата подтверждения заявки', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'AcceptDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника подтвердившего заявку', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'AcceptEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Время заполнения заявки в секундах', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'WriteTime'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор причины неработоспособности оборудования', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'MalfunctionCauseID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наработка', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'WorkTotals'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор целового подразделения заявки', 'SCHEMA', N'dbo', 'TABLE', N'Requests', 'COLUMN', N'TargetID'
GO