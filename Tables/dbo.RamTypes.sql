CREATE TABLE [dbo].[RamTypes] (
  [ID] [int] IDENTITY,
  [Name] [varchar](25) NOT NULL,
  PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_RamTypes_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Типы оперативной памяти', 'SCHEMA', N'dbo', 'TABLE', N'RamTypes'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'RamTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'RamTypes', 'COLUMN', N'Name'
GO