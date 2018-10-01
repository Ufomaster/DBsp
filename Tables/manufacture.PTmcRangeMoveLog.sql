CREATE TABLE [manufacture].[PTmcRangeMoveLog] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NOT NULL,
  [TmcID] [int] NULL,
  [FromValue] [varchar](255) NULL,
  [ToValue] [varchar](255) NULL,
  [StorageStructureID] [smallint] NULL,
  [EmployeeID] [int] NULL,
  [StatusID] [tinyint] NULL,
  [MultiTMC] [bit] NULL,
  [JobStageID] [int] NULL,
  [MoveType] [tinyint] NULL,
  CONSTRAINT [PK_PTmcRangeMoveLog_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'manufacture.PTmcRangeMoveLog.CreateDate'
GO