CREATE TABLE [QualityControl].[ActsHistoryDetails] (
  [ID] [int] IDENTITY,
  [ActsHistoryID] [int] NOT NULL,
  [XMLData] [xml] NULL,
  [ParagraphCaption] [varchar](255) NULL,
  [EmployeeID] [int] NULL,
  [SortOrder] [tinyint] NULL,
  [SignDate] [datetime] NULL,
  CONSTRAINT [PK_ActsHistoryDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActsHistoryDetails]
  ADD CONSTRAINT [FK_ActsHistoryDetails_ActsHistory (QualityControl)_ID] FOREIGN KEY ([ActsHistoryID]) REFERENCES [QualityControl].[ActsHistory] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Данные по списку полей одного емплои', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryDetails', 'COLUMN', N'XMLData'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование параграфа данных', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryDetails', 'COLUMN', N'ParagraphCaption'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор сотрудника', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryDetails', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок следования записей в списке', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryDetails', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата окончания работы с блоком полей', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistoryDetails', 'COLUMN', N'SignDate'
GO