CREATE TABLE [manufacture].[TechnologicalOperationsRates] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NOT NULL,
  [TechnologicalOperationID] [int] NOT NULL,
  [Amount] [decimal](18, 4) NULL,
  [AmountUpr] [decimal](18, 4) NULL,
  [DateFrom] [datetime] NULL,
  [IsDeleted] [bit] NULL,
  [DateTo] [datetime] NULL,
  CONSTRAINT [PK_TechnologicalOperationsRates_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [manufacture].[TechnologicalOperationsRates]
  ADD CONSTRAINT [FK_TechnologicalOperationsRates_TechnologicalOperations_ID] FOREIGN KEY ([TechnologicalOperationID]) REFERENCES [manufacture].[TechnologicalOperations] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperationsRates', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperationsRates', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТО', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperationsRates', 'COLUMN', N'TechnologicalOperationID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во сумма', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperationsRates', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во сумма в упр учете', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperationsRates', 'COLUMN', N'AmountUpr'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата действия от', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperationsRates', 'COLUMN', N'DateFrom'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг удален в 1с', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperationsRates', 'COLUMN', N'IsDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата действия ДО. равняентся дате старта нового тарифа. Сделано для ускорения запросов.', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperationsRates', 'COLUMN', N'DateTo'
GO