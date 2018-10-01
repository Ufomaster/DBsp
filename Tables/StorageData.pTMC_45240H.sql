CREATE TABLE [StorageData].[pTMC_45240H] (
  [ID] [int] IDENTITY,
  [StatusID] [tinyint] NULL,
  [StorageStructureID] [smallint] NULL,
  [ParentTMCID] [int] NULL,
  [pTmcID] [int] NULL,
  [ParentPTMCID] [int] NULL,
  [ModifyDate] [datetime] NOT NULL,
  [ModifyEmployeeID] [int] NOT NULL,
  [OperationID] [int] NULL,
  [EmployeeGroupsFactID] [int] NULL,
  [PackedDate] [datetime] NULL,
  [OperationType] [tinyint] NULL,
  CONSTRAINT [PK_pTMC_45240H_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'StorageData.pTMC_45240H.ModifyDate'
GO