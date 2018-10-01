CREATE TABLE [StorageData].[pTMC_45240] (
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
  CONSTRAINT [PK_pTMC_45240_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45240_Batch]
  ON [StorageData].[pTMC_45240] ([Batch])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45240_EmployeeGroupsFactID]
  ON [StorageData].[pTMC_45240] ([EmployeeGroupsFactID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45240_PackedDate]
  ON [StorageData].[pTMC_45240] ([PackedDate])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45240_StatusID]
  ON [StorageData].[pTMC_45240] ([StatusID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45240_StorageStructureID]
  ON [StorageData].[pTMC_45240] ([StorageStructureID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45240_TMCID]
  ON [StorageData].[pTMC_45240] ([TMCID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45240_Value]
  ON [StorageData].[pTMC_45240] ([Value])
  ON [PRIMARY]
GO

ALTER TABLE [StorageData].[pTMC_45240]
  ADD CONSTRAINT [FK_pTMC_45240_EmployeeGroupsFact_ID] FOREIGN KEY ([EmployeeGroupsFactID]) REFERENCES [shifts].[EmployeeGroupsFact] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45240]
  ADD CONSTRAINT [FK_pTMC_45240_PTmc_ID] FOREIGN KEY ([ParentTMCID]) REFERENCES [dbo].[Tmc] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45240]
  ADD CONSTRAINT [FK_pTMC_45240_PTmcOperations_ID] FOREIGN KEY ([OperationID]) REFERENCES [manufacture].[PTmcOperations] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45240]
  ADD CONSTRAINT [FK_pTMC_45240_PTmcStatuses_ID] FOREIGN KEY ([StatusID]) REFERENCES [manufacture].[PTmcStatuses] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45240]
  ADD CONSTRAINT [FK_pTMC_45240_StorageStructure_ID] FOREIGN KEY ([StorageStructureID]) REFERENCES [manufacture].[StorageStructure] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45240]
  ADD CONSTRAINT [FK_pTMC_45240_Tmc_ID] FOREIGN KEY ([TMCID]) REFERENCES [dbo].[Tmc] ([ID])
GO