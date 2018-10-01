CREATE TABLE [dbo].[RequestsHistory] (
  [ID] [int] IDENTITY,
  [RequestID] [int] NOT NULL,
  [Date] [datetime] NULL,
  [Description] [varchar](max) NULL,
  [EmployeeName] [varchar](255) NULL,
  [Solution] [varchar](max) NULL,
  [PlanDate] [datetime] NULL,
  [SolutionEmployeeName] [varchar](255) NULL,
  [SeverityName] [varchar](255) NULL,
  [StatusName] [varchar](255) NULL,
  [Equipment] [varchar](255) NULL,
  [DepartmentName] [varchar](255) NULL,
  [ModifyDate] [datetime] NOT NULL,
  [ModifyEmployeeID] [int] NOT NULL,
  [OperationType] [int] NULL,
  [DesiredDate] [datetime] NULL,
  [Accepted] [varchar](255) NULL,
  [AcceptDate] [datetime] NULL,
  [AcceptEmployeeName] [varchar](255) NULL,
  [StatusID] [int] NULL,
  [WorkTime] [int] NULL,
  CONSTRAINT [PK_RequestsHistory_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_RequestsHistory_StatusID_RequestID_ModifyDate]
  ON [dbo].[RequestsHistory] ([StatusID])
  INCLUDE ([RequestID], [ModifyDate])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.RequestsHistory.ModifyDate'
GO

ALTER TABLE [dbo].[RequestsHistory]
  ADD CONSTRAINT [FK_RequestsHistory_Requests_ID] FOREIGN KEY ([RequestID]) REFERENCES [dbo].[Requests] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор запроса(заявки)', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'RequestID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата заявки', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Инициатор', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'EmployeeName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Решение', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'Solution'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Планируемая дата', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'PlanDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Контактное лицо', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'SolutionEmployeeName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Важность', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'SeverityName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'StatusName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Оборудование,с-н', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'Equipment'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Департамент', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'DepartmentName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата модификации', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пользователь, изменивший данные', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции 0-вставка, 1-апдейт, 2-удаление', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Желаемая плановая дата', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'DesiredDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние подтрерждена или не подтверждена', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'Accepted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата потверждения', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'AcceptDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сотрудник, подтвердивший заявку', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'AcceptEmployeeName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Время потраченное по работам на решение заявки на момент', 'SCHEMA', N'dbo', 'TABLE', N'RequestsHistory', 'COLUMN', N'WorkTime'
GO