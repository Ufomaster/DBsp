CREATE TABLE [dbo].[Solutions] (
  [ID] [int] IDENTITY,
  [Description] [varchar](1000) NULL,
  [RequestID] [int] NULL,
  [SolutionPlanID] [int] NULL,
  [Type] [int] NOT NULL,
  [Kind] [int] NOT NULL,
  [Status] [int] NOT NULL,
  [Date] [datetime] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  [StartDate] [datetime] NULL,
  [DateEnd] [datetime] NULL,
  [CreateDate] [datetime] NOT NULL,
  [CustomerID] [int] NULL,
  [RequestSolutionID] [int] NULL,
  CONSTRAINT [PK_Solutions_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_Solutions_SolutionPlanID_Date]
  ON [dbo].[Solutions] ([SolutionPlanID], [Date])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.Solutions.CreateDate'
GO

ALTER TABLE [dbo].[Solutions]
  ADD CONSTRAINT [FK_RequestSolutions_Requests_ID] FOREIGN KEY ([RequestID]) REFERENCES [dbo].[Requests] ([ID])
GO

ALTER TABLE [dbo].[Solutions]
  ADD CONSTRAINT [FK_RequestSolutions_SolutionsPlanned_ID] FOREIGN KEY ([SolutionPlanID]) REFERENCES [dbo].[SolutionsPlanned] ([ID])
GO

ALTER TABLE [dbo].[Solutions]
  ADD CONSTRAINT [FK_Solutions_Customers_ID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID])
GO

ALTER TABLE [dbo].[Solutions]
  ADD CONSTRAINT [FK_Solutions_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[Solutions]
  ADD CONSTRAINT [FK_Solutions_Solutions_ID] FOREIGN KEY ([RequestSolutionID]) REFERENCES [dbo].[Solutions] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заявки', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'RequestID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор плановой работы', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'SolutionPlanID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип работы 0-по заявке, 1-плановая', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'Type'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вид работы. 0-Замена, 1-Ремонт', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'Kind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние работы. 0-выполняется, 1-выполнена', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Плановая дата работы', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя который создал работу', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата время начала', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'StartDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата время окончания', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'DateEnd'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания записи', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор исполнителя-подрядчика', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор работы по заявке, которая покрывает работу по плану', 'SCHEMA', N'dbo', 'TABLE', N'Solutions', 'COLUMN', N'RequestSolutionID'
GO