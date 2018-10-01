CREATE TABLE [manufacture].[ProductionTasksOperationTypes] (
  [ID] [tinyint] NOT NULL,
  [Name] [varchar](30) NULL,
  [isOut] [bit] NULL,
  CONSTRAINT [PK_ProductionTasksOperationTypes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор операции', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksOperationTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksOperationTypes', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Исходящая операция, ГП', 'SCHEMA', N'manufacture', 'TABLE', N'ProductionTasksOperationTypes', 'COLUMN', N'isOut'
GO