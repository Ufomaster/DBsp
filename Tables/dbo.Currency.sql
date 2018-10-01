CREATE TABLE [dbo].[Currency] (
  [ID] [int] IDENTITY,
  [Name] [varchar](100) NULL,
  [ShortName] [varchar](4) NULL,
  [isBase] [bit] NULL CONSTRAINT [DF_Currency_isBase] DEFAULT (0),
  [Code] [int] NULL,
  CONSTRAINT [PK_Currency_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_Currency_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Currency', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование валюты', 'SCHEMA', N'dbo', 'TABLE', N'Currency', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Аббревиатура', 'SCHEMA', N'dbo', 'TABLE', N'Currency', 'COLUMN', N'ShortName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Базовая 0: нет, 1-да', 'SCHEMA', N'dbo', 'TABLE', N'Currency', 'COLUMN', N'isBase'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Международный код валюты', 'SCHEMA', N'dbo', 'TABLE', N'Currency', 'COLUMN', N'Code'
GO