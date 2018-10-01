CREATE TABLE [QualityControl].[ActsDetails] (
  [ID] [int] IDENTITY,
  [ActsID] [int] NOT NULL,
  [XMLData] [xml] NULL,
  [ParagraphCaption] [varchar](255) NULL,
  [EmployeeID] [int] NULL,
  [SortOrder] [tinyint] NULL,
  [SignDate] [datetime] NULL,
  CONSTRAINT [PK_ActsDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActsDetails]
  ADD CONSTRAINT [FK_ActsDetails_Acts_ID] FOREIGN KEY ([ActsID]) REFERENCES [QualityControl].[Acts] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [QualityControl].[ActsDetails]
  ADD CONSTRAINT [FK_ActsDetails_Employess_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsDetails', 'COLUMN', N'ActsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Данные по списку полей одного емплои', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsDetails', 'COLUMN', N'XMLData'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование параграфа данных', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsDetails', 'COLUMN', N'ParagraphCaption'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор сотрудника', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsDetails', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок следования записей в списке', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsDetails', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата окончания работы с блоком полей', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsDetails', 'COLUMN', N'SignDate'
GO