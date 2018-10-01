CREATE TABLE [QualityControl].[ActClasses] (
  [ID] [tinyint] IDENTITY,
  [Name] [varchar](255) NULL,
  [isDeleted] [bit] NULL,
  CONSTRAINT [PK_ActClasses_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_ActClasses_Name] UNIQUE ([Name])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActClasses', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'QualityControl', 'TABLE', N'ActClasses', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг - 1-удален', 'SCHEMA', N'QualityControl', 'TABLE', N'ActClasses', 'COLUMN', N'isDeleted'
GO