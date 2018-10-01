CREATE TABLE [manufacture].[TechnologicalOperationsPlanProductivity] (
  [ID] [int] IDENTITY,
  [TechnologicalOperationID] [int] NOT NULL,
  [Amount] [decimal](18, 4) NULL,
  [DateFrom] [datetime] NULL,
  [IsDeleted] [bit] NULL,
  CONSTRAINT [PK_TechnologicalOperationsPlanProductivity_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [manufacture].[TechnologicalOperationsPlanProductivity]
  ADD CONSTRAINT [FK_TechnologicalOperationsPlanProductivity_TechnologicalOperations_ID] FOREIGN KEY ([TechnologicalOperationID]) REFERENCES [manufacture].[TechnologicalOperations] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperationsPlanProductivity', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТО', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperationsPlanProductivity', 'COLUMN', N'TechnologicalOperationID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во, сумма', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperationsPlanProductivity', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата действия от', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperationsPlanProductivity', 'COLUMN', N'DateFrom'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг удален в 1с', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperationsPlanProductivity', 'COLUMN', N'IsDeleted'
GO