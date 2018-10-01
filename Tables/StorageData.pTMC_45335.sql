CREATE TABLE [StorageData].[pTMC_45335] (
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
  CONSTRAINT [PK_pTMC_45335_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45335_Batch]
  ON [StorageData].[pTMC_45335] ([Batch])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45335_EmployeeGroupsFactID]
  ON [StorageData].[pTMC_45335] ([EmployeeGroupsFactID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45335_PackedDate]
  ON [StorageData].[pTMC_45335] ([PackedDate])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45335_StatusID]
  ON [StorageData].[pTMC_45335] ([StatusID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45335_StorageStructureID]
  ON [StorageData].[pTMC_45335] ([StorageStructureID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45335_TMCID]
  ON [StorageData].[pTMC_45335] ([TMCID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45335_Value]
  ON [StorageData].[pTMC_45335] ([Value])
  ON [PRIMARY]
GO

ALTER TABLE [StorageData].[pTMC_45335]
  ADD CONSTRAINT [FK_pTMC_45335_EmployeeGroupsFact_ID] FOREIGN KEY ([EmployeeGroupsFactID]) REFERENCES [shifts].[EmployeeGroupsFact] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45335]
  ADD CONSTRAINT [FK_pTMC_45335_PTmc_ID] FOREIGN KEY ([ParentTMCID]) REFERENCES [dbo].[Tmc] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45335]
  ADD CONSTRAINT [FK_pTMC_45335_PTmcOperations_ID] FOREIGN KEY ([OperationID]) REFERENCES [manufacture].[PTmcOperations] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45335]
  ADD CONSTRAINT [FK_pTMC_45335_PTmcStatuses_ID] FOREIGN KEY ([StatusID]) REFERENCES [manufacture].[PTmcStatuses] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45335]
  ADD CONSTRAINT [FK_pTMC_45335_StorageStructure_ID] FOREIGN KEY ([StorageStructureID]) REFERENCES [manufacture].[StorageStructure] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45335]
  ADD CONSTRAINT [FK_pTMC_45335_Tmc_ID] FOREIGN KEY ([TMCID]) REFERENCES [dbo].[Tmc] ([ID])
GO