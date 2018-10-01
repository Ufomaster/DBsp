CREATE TABLE [dbo].[RamFlow] (
  [ID] [int] IDENTITY,
  [Name] [varchar](20) NOT NULL,
  PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_RamFlow_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пропускная способность памяти', 'SCHEMA', N'dbo', 'TABLE', N'RamFlow'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'RamFlow', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'RamFlow', 'COLUMN', N'Name'
GO