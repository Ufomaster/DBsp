CREATE TABLE [shifts].[LogProcedures] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  CONSTRAINT [PK__LogProce__3214EC2777705537] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'LogProcedures', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование процедуры', 'SCHEMA', N'shifts', 'TABLE', N'LogProcedures', 'COLUMN', N'Name'
GO