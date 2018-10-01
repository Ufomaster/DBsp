CREATE TABLE [dbo].[MonitorType] (
  [ID] [int] IDENTITY,
  [Name] [varchar](25) NOT NULL,
  PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_MonitorType_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'MonitorType', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'MonitorType', 'COLUMN', N'Name'
GO