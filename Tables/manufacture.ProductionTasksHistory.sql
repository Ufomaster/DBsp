CREATE TABLE [manufacture].[ProductionTasksHistory] (
  [ID] [int] NOT NULL,
  [CreateDate] [datetime] NULL,
  [ShiftID] [int] NULL,
  [ChiefEmployeeID] [int] NULL,
  [StorageStructureSectorID] [int] NULL,
  [StartDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [CreateType] [tinyint] NULL,
  [HistoryID] [int] IDENTITY,
  [HistoryModifyDate] [datetime] NOT NULL,
  [HistoryUserSID] [varbinary](85) NOT NULL,
  [HistoryModifyEmployeeID] [int] NULL,
  [HistoryIP] [varchar](15) NOT NULL,
  [HistoryCompName] [varchar](100) NOT NULL,
  [HistoryOperationID] [tinyint] NOT NULL,
  [HistoryMacAddress] [nchar](12) NULL DEFAULT ([dbo].[fn_MacAddress]()),
  CONSTRAINT [PK_ProductionTasksHistory_ID] PRIMARY KEY CLUSTERED ([HistoryID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'manufacture.ProductionTasksHistory.HistoryModifyDate'
GO

EXEC sp_bindefault @defname = N'dbo.DF_SID', @objname = N'manufacture.ProductionTasksHistory.HistoryUserSID'
GO

EXEC sp_bindefault @defname = N'dbo.DF_IP', @objname = N'manufacture.ProductionTasksHistory.HistoryIP'
GO

EXEC sp_bindefault @defname = N'dbo.DF_CompName', @objname = N'manufacture.ProductionTasksHistory.HistoryCompName'
GO