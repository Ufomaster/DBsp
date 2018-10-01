CREATE TABLE [dbo].[BudgetSpends] (
  [ID] [int] IDENTITY,
  [Code] [varchar](20) NULL,
  [Name] [varchar](255) NULL,
  [SubGroup] [varchar](255) NULL,
  [Group] [varchar](255) NULL,
  [Section] [varchar](255) NULL,
  CONSTRAINT [PK_BudgetSpends_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'BudgetSpends', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код статьи', 'SCHEMA', N'dbo', 'TABLE', N'BudgetSpends', 'COLUMN', N'Code'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование статьи', 'SCHEMA', N'dbo', 'TABLE', N'BudgetSpends', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Подгруппа', 'SCHEMA', N'dbo', 'TABLE', N'BudgetSpends', 'COLUMN', N'SubGroup'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Группа', 'SCHEMA', N'dbo', 'TABLE', N'BudgetSpends', 'COLUMN', N'Group'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Раздел', 'SCHEMA', N'dbo', 'TABLE', N'BudgetSpends', 'COLUMN', N'Section'
GO