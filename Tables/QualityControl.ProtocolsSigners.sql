CREATE TABLE [QualityControl].[ProtocolsSigners] (
  [ID] [int] IDENTITY,
  [ProtocolID] [int] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  [EmailOnly] [bit] NULL,
  [SignDate] [datetime] NULL,
  CONSTRAINT [PK_ProtocolsSigners_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ProtocolsSigners]
  ADD CONSTRAINT [FK_ProtocolsSigners_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[ProtocolsSigners]
  ADD CONSTRAINT [FK_ProtocolsSigners_ProtocolID_ID] FOREIGN KEY ([ProtocolID]) REFERENCES [QualityControl].[Protocols] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Список подписывающих лиц и получателей Email', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsSigners'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsSigners', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsSigners', 'COLUMN', N'ProtocolID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsSigners', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг 0 - не требовать подписи, только отлылать Email', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsSigners', 'COLUMN', N'EmailOnly'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата подписания', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsSigners', 'COLUMN', N'SignDate'
GO