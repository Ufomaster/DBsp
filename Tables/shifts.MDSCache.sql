CREATE TABLE [shifts].[MDSCache] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NULL,
  [JobStageID] [int] NULL,
  [OutputTmcID] [int] NULL,
  [OutputNameTmcID] [int] NULL,
  CONSTRAINT [PK_MDSCache_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'shifts.MDSCache.CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'MDSCache', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'shifts', 'TABLE', N'MDSCache', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор этапа', 'SCHEMA', N'shifts', 'TABLE', N'MDSCache', 'COLUMN', N'JobStageID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ГП', 'SCHEMA', N'shifts', 'TABLE', N'MDSCache', 'COLUMN', N'OutputTmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор тмц с номером для ГП', 'SCHEMA', N'shifts', 'TABLE', N'MDSCache', 'COLUMN', N'OutputNameTmcID'
GO