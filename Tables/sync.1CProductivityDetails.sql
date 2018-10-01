CREATE TABLE [sync].[1CProductivityDetails] (
  [ID] [int] IDENTITY,
  [1CProductivityID] [int] NULL,
  [EmployeeCode1C] [varchar](36) NULL,
  [PCCNumber] [varchar](30) NULL,
  [TechnologicalOperationCode1C] [varchar](36) NULL,
  [ShiftStartDate] [datetime] NULL,
  [Amount] [int] NULL,
  [AmountTime] [int] NULL,
  CONSTRAINT [PK_1CProductivityDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [sync].[1CProductivityDetails]
  ADD CONSTRAINT [FK_1CProductivityDetails_1CProductivity_ID] FOREIGN KEY ([1CProductivityID]) REFERENCES [sync].[1CProductivity] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CProductivityDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентфикатор шапки документа', 'SCHEMA', N'sync', 'TABLE', N'1CProductivityDetails', 'COLUMN', N'1CProductivityID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Гуид 1с сотрудника физлица', 'SCHEMA', N'sync', 'TABLE', N'1CProductivityDetails', 'COLUMN', N'EmployeeCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'НОмер зл', 'SCHEMA', N'sync', 'TABLE', N'1CProductivityDetails', 'COLUMN', N'PCCNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Гуид ТО', 'SCHEMA', N'sync', 'TABLE', N'1CProductivityDetails', 'COLUMN', N'TechnologicalOperationCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'дата смены', 'SCHEMA', N'sync', 'TABLE', N'1CProductivityDetails', 'COLUMN', N'ShiftStartDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во', 'SCHEMA', N'sync', 'TABLE', N'1CProductivityDetails', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во времени в секундах', 'SCHEMA', N'sync', 'TABLE', N'1CProductivityDetails', 'COLUMN', N'AmountTime'
GO