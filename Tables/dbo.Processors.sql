CREATE TABLE [dbo].[Processors] (
  [ID] [int] IDENTITY,
  [Name] [varchar](100) NOT NULL,
  PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_Processors_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Список наименований процессоров', 'SCHEMA', N'dbo', 'TABLE', N'Processors'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Processors', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование процессора', 'SCHEMA', N'dbo', 'TABLE', N'Processors', 'COLUMN', N'Name'
GO