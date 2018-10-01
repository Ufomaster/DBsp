CREATE TABLE [manufacture].[PTmcUndoRangeLog] (
  [ID] [int] IDENTITY,
  [ExecDate] [datetime] NOT NULL,
  [UndoTmcID] [int] NULL,
  [SearchValue] [varchar](255) NULL,
  [StorageStructureID] [smallint] NULL,
  [JobStageID] [int] NULL,
  [ExecResult] [varchar](8000) NULL,
  CONSTRAINT [PK_PTmcUndoRangeLog_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'manufacture.PTmcUndoRangeLog.ExecDate'
GO