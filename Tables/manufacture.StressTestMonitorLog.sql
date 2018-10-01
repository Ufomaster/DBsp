CREATE TABLE [manufacture].[StressTestMonitorLog] (
  [ID] [int] IDENTITY,
  [StorageStructureID] [int] NULL,
  [LastError] [varchar](8000) NULL,
  [Status] [varchar](50) NULL,
  [LastResponse] [datetime] NULL,
  [PackExecSpeed] [int] NULL,
  [CodeValidExecSpeed] [int] NULL,
  [SortOrderExecSpeed] [int] NULL,
  [LinksExecSpeed] [int] NULL,
  [IterationLog] [varchar](8000) NULL,
  [PackExecArray] [varchar](255) NULL,
  [CodeValidExecArray] [varchar](255) NULL,
  [SortOrderExecArray] [varchar](255) NULL,
  [LinksExecArray] [varchar](255) NULL,
  [LastLogWriteDelay] [int] NULL
)
ON [PRIMARY]
GO