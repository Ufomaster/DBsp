CREATE TABLE [dbo].[ConsumptionRatesParams] (
  [ID] [int] IDENTITY,
  [Name] [varchar](30) NULL,
  [Description] [varchar](5000) NULL,
  [ParamValue] [varchar](5000) NULL,
  CONSTRAINT [PK_ConsumptionRatesParams_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UQ_ConsumptionRatesParams_Name]
  ON [dbo].[ConsumptionRatesParams] ([Name])
  ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ConsumptionRatesParams', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование параметра', 'SCHEMA', N'dbo', 'TABLE', N'ConsumptionRatesParams', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание параметра', 'SCHEMA', N'dbo', 'TABLE', N'ConsumptionRatesParams', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Запрос/значение параметра', 'SCHEMA', N'dbo', 'TABLE', N'ConsumptionRatesParams', 'COLUMN', N'ParamValue'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'имена не должны повторяться', 'SCHEMA', N'dbo', 'TABLE', N'ConsumptionRatesParams', 'INDEX', N'UQ_ConsumptionRatesParams_Name'
GO