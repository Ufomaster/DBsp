CREATE TABLE [dbo].[Accounts] (
  [ID] [int] IDENTITY,
  [Name] [varchar](64) NOT NULL,
  [SMTPServer] [varchar](128) NOT NULL,
  [SMTPPort] [int] NOT NULL,
  [POP3Server] [varchar](128) NOT NULL,
  [POP3Port] [int] NOT NULL,
  [Authentification] [int] NOT NULL,
  [UserName] [varchar](32) NOT NULL,
  [Password] [varchar](20) NOT NULL,
  [SenderName] [varchar](64) NOT NULL,
  [SenderAddress] [varchar](64) NOT NULL,
  [ReplyAddress] [varchar](64) NOT NULL,
  [IsActive] [bit] NOT NULL,
  CONSTRAINT [PK_Accounts_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Accounts', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'Accounts', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'SMTP сервер', 'SCHEMA', N'dbo', 'TABLE', N'Accounts', 'COLUMN', N'SMTPServer'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'SMTP порт', 'SCHEMA', N'dbo', 'TABLE', N'Accounts', 'COLUMN', N'SMTPPort'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'POP3 сервер', 'SCHEMA', N'dbo', 'TABLE', N'Accounts', 'COLUMN', N'POP3Server'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'POP3 порт', 'SCHEMA', N'dbo', 'TABLE', N'Accounts', 'COLUMN', N'POP3Port'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Аутентификация отправки', 'SCHEMA', N'dbo', 'TABLE', N'Accounts', 'COLUMN', N'Authentification'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Логин', 'SCHEMA', N'dbo', 'TABLE', N'Accounts', 'COLUMN', N'UserName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пароль', 'SCHEMA', N'dbo', 'TABLE', N'Accounts', 'COLUMN', N'Password'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Отправитель', 'SCHEMA', N'dbo', 'TABLE', N'Accounts', 'COLUMN', N'SenderName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Адрес получателя', 'SCHEMA', N'dbo', 'TABLE', N'Accounts', 'COLUMN', N'SenderAddress'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Адрес отправителя', 'SCHEMA', N'dbo', 'TABLE', N'Accounts', 'COLUMN', N'ReplyAddress'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Активность Учётной записи', 'SCHEMA', N'dbo', 'TABLE', N'Accounts', 'COLUMN', N'IsActive'
GO