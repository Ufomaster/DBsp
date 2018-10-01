CREATE TABLE [QualityControl].[ActOfSampling] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NOT NULL,
  [ProtocolID] [int] NOT NULL,
  [QCEmployeeID] [int] NOT NULL,
  [CompleteDate] [datetime] NULL,
  [QueryCount] [decimal](18, 4) NULL,
  [StorageEmployeeID] [int] NULL,
  CONSTRAINT [PK_ActOfSampling_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'QualityControl.ActOfSampling.CreateDate'
GO

ALTER TABLE [QualityControl].[ActOfSampling]
  ADD CONSTRAINT [FK_ActOfSampling_Employees_ID] FOREIGN KEY ([QCEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[ActOfSampling]
  ADD CONSTRAINT [FK_ActOfSampling_Employees_ID2] FOREIGN KEY ([StorageEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[ActOfSampling]
  ADD CONSTRAINT [FK_ActOfSampling_Protocols_ID] FOREIGN KEY ([ProtocolID]) REFERENCES [QualityControl].[Protocols] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Акты отбора проб', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSampling'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSampling', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSampling', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSampling', 'COLUMN', N'ProtocolID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника КК', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSampling', 'COLUMN', N'QCEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата оформления', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSampling', 'COLUMN', N'CompleteDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Количество полученной продукции', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSampling', 'COLUMN', N'QueryCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор начальника склада', 'SCHEMA', N'QualityControl', 'TABLE', N'ActOfSampling', 'COLUMN', N'StorageEmployeeID'
GO