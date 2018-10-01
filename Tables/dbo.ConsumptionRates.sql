CREATE TABLE [dbo].[ConsumptionRates] (
  [ID] [int] IDENTITY,
  [ObjectTypesMaterialID] [int] NULL,
  [Script] [varchar](max) NOT NULL DEFAULT (0),
  [Name] [varchar](255) NOT NULL,
  [TechOperationID] [int] NULL,
  CONSTRAINT [PK_ConsumptionRates_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ConsumptionRates]
  ADD CONSTRAINT [FK_ConsumptionRate_ObjectTypesMaterials_ID] FOREIGN KEY ([ObjectTypesMaterialID]) REFERENCES [dbo].[ObjectTypesMaterials] ([ID])
GO

ALTER TABLE [dbo].[ConsumptionRates]
  ADD CONSTRAINT [FK_ConsumptionRates_TechOperations_ID] FOREIGN KEY ([TechOperationID]) REFERENCES [dbo].[TechOperations] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'dbo', 'TABLE', N'ConsumptionRates', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор связки материала со значением справочника', 'SCHEMA', N'dbo', 'TABLE', N'ConsumptionRates', 'COLUMN', N'ObjectTypesMaterialID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Скрипт', 'SCHEMA', N'dbo', 'TABLE', N'ConsumptionRates', 'COLUMN', N'Script'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание/название механизма расчета', 'SCHEMA', N'dbo', 'TABLE', N'ConsumptionRates', 'COLUMN', N'Name'
GO