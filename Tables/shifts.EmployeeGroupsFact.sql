CREATE TABLE [shifts].[EmployeeGroupsFact] (
  [ID] [int] IDENTITY,
  [StartDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [IP] [varchar](50) NULL,
  [WorkPlaceID] [smallint] NULL,
  [ShiftID] [int] NULL,
  [IsDeleted] [bit] NULL,
  [AutoCreate] [bit] NULL,
  [JobStageID] [int] NULL,
  CONSTRAINT [PK_EmployeeGroupsFact_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_EmployeeGroupsFact_EndDate]
  ON [shifts].[EmployeeGroupsFact] ([EndDate])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_EmployeeGroupsFact_ShiftID]
  ON [shifts].[EmployeeGroupsFact] ([ShiftID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_EmployeeGroupsFact_StartDate]
  ON [shifts].[EmployeeGroupsFact] ([StartDate])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_EmployeeGroupsFact_WorkPlaceID_ShiftID_StartDate_EndDate_ID]
  ON [shifts].[EmployeeGroupsFact] ([WorkPlaceID], [ShiftID])
  INCLUDE ([StartDate], [EndDate], [ID])
  ON [PRIMARY]
GO

ALTER TABLE [shifts].[EmployeeGroupsFact]
  ADD CONSTRAINT [FK_EmployeeGroupsFact_JobStages (manufacture)_ID] FOREIGN KEY ([JobStageID]) REFERENCES [manufacture].[JobStages] ([ID])
GO

ALTER TABLE [shifts].[EmployeeGroupsFact]
  ADD CONSTRAINT [FK_EmployeeGroupsFact_Shifts (shifts)_ID] FOREIGN KEY ([ShiftID]) REFERENCES [shifts].[Shifts] ([ID])
GO

ALTER TABLE [shifts].[EmployeeGroupsFact]
  ADD CONSTRAINT [FK_EmployeeGroupsFact_StorageStructure (manufacture)_ID] FOREIGN KEY ([WorkPlaceID]) REFERENCES [manufacture].[StorageStructure] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsFact', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsFact', 'COLUMN', N'StartDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата закрытия', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsFact', 'COLUMN', N'EndDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'IP адрес компьютера', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsFact', 'COLUMN', N'IP'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор рабочего места', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsFact', 'COLUMN', N'WorkPlaceID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор смены', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsFact', 'COLUMN', N'ShiftID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пометка удаления', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsFact', 'COLUMN', N'IsDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Признак того что запись создана автоматически', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsFact', 'COLUMN', N'AutoCreate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор выполняющейся работы', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroupsFact', 'COLUMN', N'JobStageID'
GO