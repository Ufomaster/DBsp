CREATE TABLE [dbo].[PrinterTypes] (
  [ID] [int] IDENTITY,
  [Name] [varchar](25) NOT NULL,
  CONSTRAINT [PK_PrinterTypes_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_PrinterTypes_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Типы принтеров', 'SCHEMA', N'dbo', 'TABLE', N'PrinterTypes'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'PrinterTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'PrinterTypes', 'COLUMN', N'Name'
GO