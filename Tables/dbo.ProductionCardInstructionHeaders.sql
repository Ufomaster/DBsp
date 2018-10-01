CREATE TABLE [dbo].[ProductionCardInstructionHeaders] (
  [ID] [int] IDENTITY,
  [Name] [varchar](100) NOT NULL,
  [Data] [varbinary](max) NULL,
  [SortOrder] [int] NOT NULL,
  CONSTRAINT [PK_ProductionCardInstructionHeaders_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardInstructionHeaders', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Виртуальное наименование', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardInstructionHeaders', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Данные в ртф формате', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardInstructionHeaders', 'COLUMN', N'Data'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Подрядок следования заголовка в инструкции', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardInstructionHeaders', 'COLUMN', N'SortOrder'
GO