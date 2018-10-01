CREATE TABLE [dbo].[ProductionCardCustomizeDocDetailsHistory] (
  [ID] [int] IDENTITY,
  [Number] [int] NULL,
  [Name] [varchar](60) NULL,
  [Format] [varchar](max) NULL,
  [NeedCheck] [bit] NULL,
  [ProductionCardCustomizeHistoryID] [int] NOT NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardCustomizeDocDetailsHistory]
  ADD CONSTRAINT [FK_ProductionCardCustomizeDocDetailsHistory_ProductionCardCustomizeHistory_ID] FOREIGN KEY ([ProductionCardCustomizeHistoryID]) REFERENCES [dbo].[ProductionCardCustomizeHistory] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDocDetailsHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер поля', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDocDetailsHistory', 'COLUMN', N'Number'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDocDetailsHistory', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Формат/пример', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDocDetailsHistory', 'COLUMN', N'Format'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверка по справочнику', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDocDetailsHistory', 'COLUMN', N'NeedCheck'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор исторической записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDocDetailsHistory', 'COLUMN', N'ProductionCardCustomizeHistoryID'
GO