CREATE TABLE [dbo].[MonitorResolution] (
  [ID] [int] IDENTITY,
  [Name] [varchar](10) NULL,
  CONSTRAINT [PK_MonitorResolution_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_MonitorResolution_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'MonitorResolution', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название', 'SCHEMA', N'dbo', 'TABLE', N'MonitorResolution', 'COLUMN', N'Name'
GO