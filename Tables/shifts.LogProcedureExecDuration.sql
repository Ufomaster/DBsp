CREATE TABLE [shifts].[LogProcedureExecDuration] (
  [ID] [bigint] IDENTITY,
  [Name] [varchar](255) NULL,
  [EventDate] [datetime] NOT NULL,
  [EmployeeID] [int] NULL,
  [Duration] [int] NULL,
  [SPID] [int] NULL,
  CONSTRAINT [PK_LogProcedureExecDuration_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'shifts.LogProcedureExecDuration.EventDate'
GO