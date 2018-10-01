CREATE TABLE [dbo].[RequestsLog] (
  [ID] [int] IDENTITY,
  [EmployeeID] [int] NOT NULL,
  [CreaateDate] [datetime] NOT NULL,
  [RequestID] [int] NULL,
  [ErrorText] [varchar](max) NULL,
  CONSTRAINT [PK_RequestsLog_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.RequestsLog.CreaateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Полученная айдишка после ПОСТ. возможно нулы', 'SCHEMA', N'dbo', 'TABLE', N'RequestsLog', 'COLUMN', N'RequestID'
GO