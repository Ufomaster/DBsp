CREATE TABLE [manufacture].[FileLog] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NULL,
  [Type] [int] NULL,
  [Value] [varchar](1000) NULL,
  [StorageStructureID] [int] NULL,
  [ErrID] [int] NULL,
  PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO