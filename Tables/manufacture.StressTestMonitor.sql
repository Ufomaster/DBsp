CREATE TABLE [manufacture].[StressTestMonitor] (
  [ID] [int] IDENTITY,
  [StorageStructureID] [int] NULL,
  [LastError] [varchar](8000) NULL,
  [Status] [bit] NULL,
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
  [LastLogWriteDelay] [int] NULL,
  CONSTRAINT [PK_StressTestMonitor_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create TRIGGER [TR_StressTestMonitor_IU] ON [manufacture].[StressTestMonitor]

FOR INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO manufacture.StressTestMonitorLog(StorageStructureID, LastError, [Status],
  LastResponse,  PackExecSpeed,  CodeValidExecSpeed,  SortOrderExecSpeed,  LinksExecSpeed, IterationLog,
  PackExecArray, CodeValidExecArray, SortOrderExecArray, LinksExecArray, LastLogWriteDelay)
  
  SELECT StorageStructureID, LastError, [Status],
  LastResponse,  PackExecSpeed,  CodeValidExecSpeed,  SortOrderExecSpeed,  LinksExecSpeed, IterationLog,
  PackExecArray, CodeValidExecArray, SortOrderExecArray, LinksExecArray, LastLogWriteDelay
  FROM INSERTED
END
GO