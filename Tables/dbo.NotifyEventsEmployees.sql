CREATE TABLE [dbo].[NotifyEventsEmployees] (
  [ID] [int] IDENTITY,
  [NotifyEventID] [int] NOT NULL,
  [DepartmentPositionID] [int] NULL,
  [isActive] [bit] NULL,
  CONSTRAINT [PK_NotifyEventEmployess_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[NotifyEventsEmployees]
  ADD CONSTRAINT [FK_NotifyEventsEmployees_DepartmentPositions_ID] FOREIGN KEY ([DepartmentPositionID]) REFERENCES [dbo].[DepartmentPositions] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[NotifyEventsEmployees]
  ADD CONSTRAINT [FK_NotifyEventsEmployees_NotifyEvents_ID] FOREIGN KEY ([NotifyEventID]) REFERENCES [dbo].[NotifyEvents] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEventsEmployees', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор события', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEventsEmployees', 'COLUMN', N'NotifyEventID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор единицы штатного рассписания', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEventsEmployees', 'COLUMN', N'DepartmentPositionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1-Активно 0-неактивно', 'SCHEMA', N'dbo', 'TABLE', N'NotifyEventsEmployees', 'COLUMN', N'isActive'
GO