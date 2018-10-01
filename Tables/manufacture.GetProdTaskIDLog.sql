CREATE TABLE [manufacture].[GetProdTaskIDLog] (
  [ID] [int] NULL,
  [JobStageID] [int] NULL,
  [ProdTaskID] [int] NULL,
  [SSID] [int] NULL,
  [SectorID] [int] NULL,
  [LocalProdTaskID] [int] NULL,
  [ShiftID] [int] NULL,
  [OpType] [int] NULL,
  [ProdEndDate] [datetime] NULL,
  [ProdStartDate] [datetime] NULL,
  [CreateDate] [datetime] NOT NULL
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'manufacture.GetProdTaskIDLog.CreateDate'
GO