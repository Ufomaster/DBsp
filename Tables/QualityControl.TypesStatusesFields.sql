CREATE TABLE [QualityControl].[TypesStatusesFields] (
  [ID] [int] IDENTITY,
  [TypesStatusesID] [tinyint] NOT NULL,
  [colid] [int] NULL,
  CONSTRAINT [PK_TypesStatusesFields_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[TypesStatusesFields]
  ADD CONSTRAINT [FK_TypesStatusesFields_ProtocolFields (QualityControl)_colid] FOREIGN KEY ([colid]) REFERENCES [QualityControl].[ProtocolFields] ([colid]) ON DELETE CASCADE
GO

ALTER TABLE [QualityControl].[TypesStatusesFields]
  ADD CONSTRAINT [FK_TypesStatusesFields_TypesStatuses (QualityControl)_ID] FOREIGN KEY ([TypesStatusesID]) REFERENCES [QualityControl].[TypesStatuses] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesStatusesFields', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesStatusesFields', 'COLUMN', N'TypesStatusesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор колонки таблицы протоколов. Взаимоисключающее с блоком полей', 'SCHEMA', N'QualityControl', 'TABLE', N'TypesStatusesFields', 'COLUMN', N'colid'
GO