CREATE TABLE [dbo].[TransportDrivers] (
  [ID] [int] IDENTITY,
  [TransportID] [int] NOT NULL,
  [EmployeeID] [int] NULL,
  [FullName] [varchar](255) NULL,
  [Phone] [varchar](30) NULL,
  [Cellular] [varchar](30) NULL,
  CONSTRAINT [PK_TransportDrivers_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[TransportDrivers]
  ADD CONSTRAINT [FK_TransportDrivers_Employees] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Водители транспорта', 'SCHEMA', N'dbo', 'TABLE', N'TransportDrivers'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'TransportDrivers', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор транспорта', 'SCHEMA', N'dbo', 'TABLE', N'TransportDrivers', 'COLUMN', N'TransportID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника-водителя', 'SCHEMA', N'dbo', 'TABLE', N'TransportDrivers', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ФИО', 'SCHEMA', N'dbo', 'TABLE', N'TransportDrivers', 'COLUMN', N'FullName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Телефон', 'SCHEMA', N'dbo', 'TABLE', N'TransportDrivers', 'COLUMN', N'Phone'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Мобильный', 'SCHEMA', N'dbo', 'TABLE', N'TransportDrivers', 'COLUMN', N'Cellular'
GO