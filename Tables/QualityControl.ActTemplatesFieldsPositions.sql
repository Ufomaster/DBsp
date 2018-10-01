CREATE TABLE [QualityControl].[ActTemplatesFieldsPositions] (
  [ID] [smallint] IDENTITY,
  [ActTemplatesSignersID] [int] NOT NULL,
  [ActFieldsID] [smallint] NOT NULL,
  [SortOrder] [tinyint] NULL,
  CONSTRAINT [PK_ActTemplateFieldsPositions_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActTemplatesFieldsPositions]
  ADD CONSTRAINT [FK_ActTemplatesFieldsPositions_ActFields (QualityControl)_ID] FOREIGN KEY ([ActFieldsID]) REFERENCES [QualityControl].[ActFields] ([ID])
GO

ALTER TABLE [QualityControl].[ActTemplatesFieldsPositions]
  ADD CONSTRAINT [FK_ActTemplatesFieldsPositions_ActTemplatesSigners (QualityControl)_ID] FOREIGN KEY ([ActTemplatesSignersID]) REFERENCES [QualityControl].[ActTemplatesSigners] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesFieldsPositions', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор участника', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesFieldsPositions', 'COLUMN', N'ActTemplatesSignersID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор поля', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesFieldsPositions', 'COLUMN', N'ActFieldsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок следования должностей участников в акте', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesFieldsPositions', 'COLUMN', N'SortOrder'
GO