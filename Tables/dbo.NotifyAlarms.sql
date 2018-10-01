CREATE TABLE [dbo].[NotifyAlarms] (
  [ID] [int] IDENTITY,
  [Name] [varchar](20) NULL,
  [SpProc] [varchar](50) NULL,
  [TagIndex] [int] NULL,
  [ImageIndex] [int] NULL,
  [AlarmRightOn] [int] NULL,
  [isActive] [bit] NOT NULL DEFAULT (1),
  CONSTRAINT [PK_NotifyAlarms_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[NotifyAlarms]
  ADD CONSTRAINT [FK_NotifyAlarms_UserRightsObjects_ID] FOREIGN KEY ([AlarmRightOn]) REFERENCES [dbo].[UserRightsObjects] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'NotifyAlarms', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование оповещения', 'SCHEMA', N'dbo', 'TABLE', N'NotifyAlarms', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя процедуры входящий параметр UserID
Возвращаемые поля Title, Description, Info
используются в окошке оповещения', 'SCHEMA', N'dbo', 'TABLE', N'NotifyAlarms', 'COLUMN', N'SpProc'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Tag из экшенов для перехода на окошок можуля', 'SCHEMA', N'dbo', 'TABLE', N'NotifyAlarms', 'COLUMN', N'TagIndex'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ImageIndex номер иконки для окошка опевещения из dmCommon.il16x16', 'SCHEMA', N'dbo', 'TABLE', N'NotifyAlarms', 'COLUMN', N'ImageIndex'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор разрешающего права', 'SCHEMA', N'dbo', 'TABLE', N'NotifyAlarms', 'COLUMN', N'AlarmRightOn'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг активности типа оповещения', 'SCHEMA', N'dbo', 'TABLE', N'NotifyAlarms', 'COLUMN', N'isActive'
GO