CREATE TABLE [QualityControl].[ActTemplatesSigners] (
  [ID] [int] NOT NULL,
  [ActTemplatesID] [smallint] NOT NULL,
  [DepartmentPositionID] [int] NOT NULL,
  [ParagraphCaption] [varchar](255) NULL,
  [SortOrder] [tinyint] NULL,
  CONSTRAINT [PK_ActTemplateSigners_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActTemplatesSigners]
  ADD CONSTRAINT [FK_ActTemplateSigners_ActTemplatesID_ID] FOREIGN KEY ([ActTemplatesID]) REFERENCES [QualityControl].[ActTemplates] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [QualityControl].[ActTemplatesSigners]
  ADD CONSTRAINT [FK_ActTemplateSigners_DepartmentPositions_ID] FOREIGN KEY ([DepartmentPositionID]) REFERENCES [dbo].[DepartmentPositions] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Список подписывающих лиц и получателей Email', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesSigners'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesSigners', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesSigners', 'COLUMN', N'ActTemplatesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор вакансии', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesSigners', 'COLUMN', N'DepartmentPositionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Заголовок блокаполей для данного подписателя или решателя', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesSigners', 'COLUMN', N'ParagraphCaption'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок записей', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplatesSigners', 'COLUMN', N'SortOrder'
GO