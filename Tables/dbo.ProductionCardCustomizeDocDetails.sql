CREATE TABLE [dbo].[ProductionCardCustomizeDocDetails] (
  [ID] [int] IDENTITY,
  [Number] [int] NOT NULL,
  [Name] [varchar](60) NOT NULL,
  [Format] [varchar](max) NULL,
  [NeedCheck] [bit] NULL,
  [ProductionCardCustomizeID] [int] NOT NULL,
  CONSTRAINT [PK_ProductionCardCustomizeDocDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardCustomizeDocDetails]
  ADD CONSTRAINT [FK_ProductionCardCustomizeDocDetails_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDocDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер поля', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDocDetails', 'COLUMN', N'Number'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDocDetails', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Формат/пример', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDocDetails', 'COLUMN', N'Format'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверка по справочнику', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDocDetails', 'COLUMN', N'NeedCheck'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeDocDetails', 'COLUMN', N'ProductionCardCustomizeID'
GO