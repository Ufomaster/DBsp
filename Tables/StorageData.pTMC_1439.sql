CREATE TABLE [StorageData].[pTMC_1439] (
  [ID] [int] IDENTITY,
  [Value] [varchar](255) NULL,
  [StatusID] [tinyint] NULL,
  [TMCID] [int] NULL,
  [StorageStructureID] [smallint] NULL,
  [ParentTMCID] [int] NULL,
  [ParentPTMCID] [int] NULL,
  [OperationID] [int] NULL,
  [EmployeeGroupsFactID] [int] NULL,
  [PackedDate] [datetime] NULL,
  [Batch] [varchar](255) NULL,
  [ChallengeTime] [smallint] NULL,
  CONSTRAINT [PK_pTMC_1439_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_1439_Batch]
  ON [StorageData].[pTMC_1439] ([Batch])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_1439_EmployeeGroupsFactID]
  ON [StorageData].[pTMC_1439] ([EmployeeGroupsFactID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_1439_PackedDate]
  ON [StorageData].[pTMC_1439] ([PackedDate])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_1439_StatusID]
  ON [StorageData].[pTMC_1439] ([StatusID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_1439_StorageStructureID]
  ON [StorageData].[pTMC_1439] ([StorageStructureID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_1439_TMCID]
  ON [StorageData].[pTMC_1439] ([TMCID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_1439_Value]
  ON [StorageData].[pTMC_1439] ([Value])
  ON [PRIMARY]
GO

ALTER TABLE [StorageData].[pTMC_1439]
  ADD CONSTRAINT [FK_pTMC_1439_EmployeeGroupsFact_ID] FOREIGN KEY ([EmployeeGroupsFactID]) REFERENCES [shifts].[EmployeeGroupsFact] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_1439]
  ADD CONSTRAINT [FK_pTMC_1439_PTmc_ID] FOREIGN KEY ([ParentTMCID]) REFERENCES [dbo].[Tmc] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_1439]
  ADD CONSTRAINT [FK_pTMC_1439_PTmcOperations_ID] FOREIGN KEY ([OperationID]) REFERENCES [manufacture].[PTmcOperations] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_1439]
  ADD CONSTRAINT [FK_pTMC_1439_PTmcStatuses_ID] FOREIGN KEY ([StatusID]) REFERENCES [manufacture].[PTmcStatuses] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_1439]
  ADD CONSTRAINT [FK_pTMC_1439_StorageStructure_ID] FOREIGN KEY ([StorageStructureID]) REFERENCES [manufacture].[StorageStructure] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_1439]
  ADD CONSTRAINT [FK_pTMC_1439_Tmc_ID] FOREIGN KEY ([TMCID]) REFERENCES [dbo].[Tmc] ([ID])
GO