CREATE TABLE [manufacture].[StressTestAssmQueryLog] (
  [ID] [int] IDENTITY,
  [Q] [varchar](max) NULL,
  [StorageStructureID] [smallint] NULL,
  [ExecDate] [datetime] NULL,
  [ArrayOfID] [varchar](255) NULL,
  [ArrayOfValues] [varchar](8000) NULL,
  [JobStageID] [int] NULL,
  [EmployeeGroupsFactID] [int] NULL,
  CONSTRAINT [PK_StressTestAssmQueryLog_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO