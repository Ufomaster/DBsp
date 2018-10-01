CREATE TABLE [QualityControl].[ProtocolsDetailsHistory] (
  [ID] [int] IDENTITY,
  [ProtocolHistoryID] [int] NOT NULL,
  [Caption] [varchar](max) NULL,
  [ValueToCheck] [varchar](max) NULL,
  [FactValue] [varchar](max) NULL,
  [Checked] [tinyint] NULL,
  [ModifyDate] [datetime] NULL,
  [SortOrder] [smallint] NULL,
  [ResultKind] [tinyint] NULL,
  [BlockID] [smallint] NULL,
  [DetailBlockName] [varchar](max) NULL,
  [ImportanceID] [tinyint] NULL,
  CONSTRAINT [PK_ProtocolsDetailsHistory_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ProtocolsDetailsHistory]
  ADD CONSTRAINT [FK_ProtocolsDetailsHistory_ProtocolsHistory (QualityControl)_ID] FOREIGN KEY ([ProtocolHistoryID]) REFERENCES [QualityControl].[ProtocolsHistory] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор критичности', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolsDetailsHistory', 'COLUMN', N'ImportanceID'
GO