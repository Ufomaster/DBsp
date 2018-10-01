CREATE TABLE [QualityControl].[FaultsReasonsClass] (
  [ID] [int] IDENTITY,
  [Code] [int] NOT NULL,
  [Name] [varchar](255) NULL,
  [FaultsGroupsID] [int] NULL,
  CONSTRAINT [PK_FaultsReasonsClass_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[FaultsReasonsClass]
  ADD CONSTRAINT [FK_FaultsReasonsClass_FaultsGroups (QualityControl)_ID] FOREIGN KEY ([FaultsGroupsID]) REFERENCES [QualityControl].[FaultsGroups] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'FaultsReasonsClass', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код', 'SCHEMA', N'QualityControl', 'TABLE', N'FaultsReasonsClass', 'COLUMN', N'Code'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'FaultsReasonsClass', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор Групы', 'SCHEMA', N'QualityControl', 'TABLE', N'FaultsReasonsClass', 'COLUMN', N'FaultsGroupsID'
GO