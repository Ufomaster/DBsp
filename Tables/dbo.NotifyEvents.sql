CREATE TABLE [dbo].[NotifyEvents] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NOT NULL,
  [Body] [varchar](max) NOT NULL,
  [AccountID] [int] NOT NULL,
  [IsHTML] [bit] NULL,
  [SQLParamsQuery] [varchar](max) NULL,
  [ModifyDate] [datetime] NOT NULL,
  CONSTRAINT [PK_NotifyEventEmployees_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.NotifyEvents.ModifyDate'
GO

ALTER TABLE [dbo].[NotifyEvents]
  ADD CONSTRAINT [FK_NotifyEvents_Accounts_ID] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Accounts] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEvents', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование события', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEvents', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Текст сообщения.', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEvents', 'COLUMN', N'Body'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор учётной записи', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEvents', 'COLUMN', N'AccountID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Формат письма HTML', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEvents', 'COLUMN', N'IsHTML'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Запрос, возвращающий данные параметров для формирования текста. Имеет параметры ID', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEvents', 'COLUMN', N'SQLParamsQuery'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата последних изменений', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEvents', 'COLUMN', N'ModifyDate'
GO