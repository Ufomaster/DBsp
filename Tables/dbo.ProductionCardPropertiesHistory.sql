CREATE TABLE [dbo].[ProductionCardPropertiesHistory] (
  [ID] [int] IDENTITY,
  [RootProductionCardPropertiesID] [int] NULL,
  [StartDate] [datetime] NOT NULL,
  CONSTRAINT [PK_ProductionCardPropertiesHistory_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardPropertiesHistory]
  ADD CONSTRAINT [FK_ProductionCardPropertiesHistory_ProductionCardProperties_ID] FOREIGN KEY ([RootProductionCardPropertiesID]) REFERENCES [dbo].[ProductionCardProperties] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Таблица шапки опубликованных взаимоисключений установок производства', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardPropertiesHistory'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardPropertiesHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор корневой записи ветки взаимоисключений', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardPropertiesHistory', 'COLUMN', N'RootProductionCardPropertiesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата ввода в работу', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardPropertiesHistory', 'COLUMN', N'StartDate'
GO