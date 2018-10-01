CREATE TABLE [manufacture].[ProductionTasksLog] (
  [ID] [int] IDENTITY,
  [Val] [varchar](max) NULL,
  [Date] [datetime] NOT NULL,
  [IsSurro] [bit] NULL,
  CONSTRAINT [PK__Producti__3214EC277AA1C79D] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'manufacture.ProductionTasksLog.Date'
GO