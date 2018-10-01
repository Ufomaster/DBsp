CREATE TABLE [QualityControl].[FaultsGroups] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  [FaultsClassID] [int] NULL,
  CONSTRAINT [PK_FaultsGroups_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[FaultsGroups]
  ADD CONSTRAINT [FK_FaultsGroups_FaultsClass (QualityControl)_ID] FOREIGN KEY ([FaultsClassID]) REFERENCES [QualityControl].[FaultsClass] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'FaultsGroups', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'FaultsGroups', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор Класа', 'SCHEMA', N'QualityControl', 'TABLE', N'FaultsGroups', 'COLUMN', N'FaultsClassID'
GO