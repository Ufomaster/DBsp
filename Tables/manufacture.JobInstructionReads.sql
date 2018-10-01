CREATE TABLE [manufacture].[JobInstructionReads] (
  [ID] [int] IDENTITY,
  [ShiftID] [int] NULL,
  [JobStageID] [int] NULL,
  [EmployeeID] [int] NULL,
  [SignDate] [datetime] NULL,
  [WorkPlaceID] [smallint] NULL,
  CONSTRAINT [PK_JobInstructionReads_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UQ_JobInstructionReads_ShiftID_JobStageID_EmployeeID_WorkPlaceID]
  ON [manufacture].[JobInstructionReads] ([ShiftID], [JobStageID], [EmployeeID], [WorkPlaceID])
  ON [PRIMARY]
GO

ALTER TABLE [manufacture].[JobInstructionReads]
  ADD CONSTRAINT [FK_JobInstructionReads_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [manufacture].[JobInstructionReads]
  ADD CONSTRAINT [FK_JobInstructionReads_JobStages (manufacture)_ID] FOREIGN KEY ([JobStageID]) REFERENCES [manufacture].[JobStages] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [manufacture].[JobInstructionReads]
  ADD CONSTRAINT [FK_JobInstructionReads_Shifts (shifts)_ID] FOREIGN KEY ([ShiftID]) REFERENCES [shifts].[Shifts] ([ID])
GO

ALTER TABLE [manufacture].[JobInstructionReads]
  ADD CONSTRAINT [FK_JobInstructionReads_StorageStructure (manufacture)_ID] FOREIGN KEY ([WorkPlaceID]) REFERENCES [manufacture].[StorageStructure] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'JobInstructionReads', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор смены', 'SCHEMA', N'manufacture', 'TABLE', N'JobInstructionReads', 'COLUMN', N'ShiftID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор этапа работы', 'SCHEMA', N'manufacture', 'TABLE', N'JobInstructionReads', 'COLUMN', N'JobStageID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор оператора', 'SCHEMA', N'manufacture', 'TABLE', N'JobInstructionReads', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата подписи', 'SCHEMA', N'manufacture', 'TABLE', N'JobInstructionReads', 'COLUMN', N'SignDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор рабочего места', 'SCHEMA', N'manufacture', 'TABLE', N'JobInstructionReads', 'COLUMN', N'WorkPlaceID'
GO