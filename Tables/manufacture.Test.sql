CREATE TABLE [manufacture].[Test] (
  [ID] [int] IDENTITY,
  [Value] [varchar](max) NULL,
  [Date] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'manufacture.Test.Date'
GO