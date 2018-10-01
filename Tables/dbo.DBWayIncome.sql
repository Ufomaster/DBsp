CREATE TABLE [dbo].[DBWayIncome] (
  [ID] [int] IDENTITY,
  [Name] [varchar](100) NOT NULL,
  CONSTRAINT [PK_DBWayIncome_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_DBWayIncome_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'DBWayIncome', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'DBWayIncome', 'COLUMN', N'Name'
GO