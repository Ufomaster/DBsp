CREATE TABLE [dbo].[Users] (
  [ID] [int] IDENTITY,
  [EmployeeID] [int] NOT NULL,
  [Login] [varchar](64) NOT NULL,
  [Password] [varchar](32) NOT NULL,
  [IsBlocked] [bit] NOT NULL CONSTRAINT [DF_Users_IsBlocked] DEFAULT (0),
  [Outdated] [bit] NULL CONSTRAINT [DF_Users_Outdated] DEFAULT (0),
  [IsAdmin] [bit] NOT NULL CONSTRAINT [DF_Users_IsAdmin] DEFAULT (0),
  CONSTRAINT [PK_Users_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_Users_Login] UNIQUE ([Login])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Users]
  ADD CONSTRAINT [FK_Users_Employees] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пользователи системы', 'SCHEMA', N'dbo', 'TABLE', N'Users'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Users', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника', 'SCHEMA', N'dbo', 'TABLE', N'Users', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Login пользователя', 'SCHEMA', N'dbo', 'TABLE', N'Users', 'COLUMN', N'Login'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пароль', 'SCHEMA', N'dbo', 'TABLE', N'Users', 'COLUMN', N'Password'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пользователь заблокирован: 0 - нет (default), 1 - да', 'SCHEMA', N'dbo', 'TABLE', N'Users', 'COLUMN', N'IsBlocked'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Не работает', 'SCHEMA', N'dbo', 'TABLE', N'Users', 'COLUMN', N'Outdated'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пометка пользователя как Администратор', 'SCHEMA', N'dbo', 'TABLE', N'Users', 'COLUMN', N'IsAdmin'
GO