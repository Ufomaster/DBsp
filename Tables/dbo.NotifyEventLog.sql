CREATE TABLE [dbo].[NotifyEventLog] (
  [ID] [int] IDENTITY,
  [NotifyEventID] [int] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  [SendDate] [datetime] NOT NULL,
  [TargetEmail] [varchar](150) NOT NULL,
  [Msg] [varchar](8000) COLLATE Cyrillic_General_CS_AS NULL,
  CONSTRAINT [PK_NotifyEventLog_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.NotifyEventLog.SendDate'
GO

ALTER TABLE [dbo].[NotifyEventLog]
  ADD CONSTRAINT [FK_NotifyEventLog_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[NotifyEventLog]
  ADD CONSTRAINT [FK_NotifyEventLog_NotifyEvents_ID] FOREIGN KEY ([NotifyEventID]) REFERENCES [dbo].[NotifyEvents] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEventLog', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор события', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEventLog', 'COLUMN', N'NotifyEventID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника, которому было послано сообщение', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEventLog', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата отсылки', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEventLog', 'COLUMN', N'SendDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Email по которому было отослано письмецо', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEventLog', 'COLUMN', N'TargetEmail'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Текст ошибки или статуса при завершени отсылки', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEventLog', 'COLUMN', N'Msg'
GO