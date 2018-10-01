CREATE TABLE [manufacture].[FileLog_LOG] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NULL,
  [Type] [int] NULL,
  [Value] [varchar](1000) NULL,
  [StorageStructureID] [int] NULL,
  PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO