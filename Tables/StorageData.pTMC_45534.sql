CREATE TABLE [StorageData].[pTMC_45534] (
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
  CONSTRAINT [PK_pTMC_45534_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45534_Batch]
  ON [StorageData].[pTMC_45534] ([Batch])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45534_EmployeeGroupsFactID]
  ON [StorageData].[pTMC_45534] ([EmployeeGroupsFactID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45534_PackedDate]
  ON [StorageData].[pTMC_45534] ([PackedDate])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45534_StatusID]
  ON [StorageData].[pTMC_45534] ([StatusID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45534_StorageStructureID]
  ON [StorageData].[pTMC_45534] ([StorageStructureID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45534_TMCID]
  ON [StorageData].[pTMC_45534] ([TMCID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_pTMC_45534_Value]
  ON [StorageData].[pTMC_45534] ([Value])
  ON [PRIMARY]
GO

ALTER TABLE [StorageData].[pTMC_45534]
  ADD CONSTRAINT [FK_pTMC_45534_EmployeeGroupsFact_ID] FOREIGN KEY ([EmployeeGroupsFactID]) REFERENCES [shifts].[EmployeeGroupsFact] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45534]
  ADD CONSTRAINT [FK_pTMC_45534_PTmc_ID] FOREIGN KEY ([ParentTMCID]) REFERENCES [dbo].[Tmc] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45534]
  ADD CONSTRAINT [FK_pTMC_45534_PTmcOperations_ID] FOREIGN KEY ([OperationID]) REFERENCES [manufacture].[PTmcOperations] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45534]
  ADD CONSTRAINT [FK_pTMC_45534_PTmcStatuses_ID] FOREIGN KEY ([StatusID]) REFERENCES [manufacture].[PTmcStatuses] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45534]
  ADD CONSTRAINT [FK_pTMC_45534_StorageStructure_ID] FOREIGN KEY ([StorageStructureID]) REFERENCES [manufacture].[StorageStructure] ([ID])
GO

ALTER TABLE [StorageData].[pTMC_45534]
  ADD CONSTRAINT [FK_pTMC_45534_Tmc_ID] FOREIGN KEY ([TMCID]) REFERENCES [dbo].[Tmc] ([ID])
GO