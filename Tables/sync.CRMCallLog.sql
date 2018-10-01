CREATE TABLE [sync].[CRMCallLog] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NULL,
  [EntityTypeID] [tinyint] NULL,
  CONSTRAINT [PK_CRMCallLog_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.CRMCallLog.Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'CRMCallLog', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата вызова', 'SCHEMA', N'sync', 'TABLE', N'CRMCallLog', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор вызываемой сущности 0-account', 'SCHEMA', N'sync', 'TABLE', N'CRMCallLog', 'COLUMN', N'EntityTypeID'
GO