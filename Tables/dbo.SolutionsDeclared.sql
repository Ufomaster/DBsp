CREATE TABLE [dbo].[SolutionsDeclared] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NOT NULL,
  [SpendNorma] [numeric](18, 4) NULL,
  [SpendNormaUnitID] [int] NULL,
  [TimeNorma] [numeric](18, 4) NULL,
  [WorkersCount] [int] NULL,
  [Kind] [int] NOT NULL,
  [TMCID] [int] NULL,
  [Comments] [varchar](2000) NULL,
  [SolutionsDeclaredGroupsID] [int] NULL,
  [Date] [datetime] NOT NULL,
  CONSTRAINT [PK_SolutionsPlanDeclared_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.SolutionsDeclared.Date'
GO

ALTER TABLE [dbo].[SolutionsDeclared]
  ADD CONSTRAINT [FK_SolutionsDeclared_SolutionsDeclaredGroups_ID] FOREIGN KEY ([SolutionsDeclaredGroupsID]) REFERENCES [dbo].[SolutionsDeclaredGroups] ([ID])
GO

ALTER TABLE [dbo].[SolutionsDeclared]
  ADD CONSTRAINT [FK_SolutionsPlanDeclared_Tmc_ID] FOREIGN KEY ([TMCID]) REFERENCES [dbo].[Tmc] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SolutionsDeclared]
  ADD CONSTRAINT [FK_SolutionsPlanDeclared_Units_ID] FOREIGN KEY ([SpendNormaUnitID]) REFERENCES [dbo].[Units] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Справочник регламентных работ', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclared'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclared', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование регламентной работы', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclared', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Норма расхода', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclared', 'COLUMN', N'SpendNorma'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Единицы измерения нормы расхода', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclared', 'COLUMN', N'SpendNormaUnitID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Норма затрат времени, человеко-часы', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclared', 'COLUMN', N'TimeNorma'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Необходимое кол-во людей', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclared', 'COLUMN', N'WorkersCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вид работы. 0-Замена, 1-Ремонт', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclared', 'COLUMN', N'Kind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ-расходника', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclared', 'COLUMN', N'TMCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарий', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclared', 'COLUMN', N'Comments'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор группы р. работ', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclared', 'COLUMN', N'SolutionsDeclaredGroupsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания записи', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDeclared', 'COLUMN', N'Date'
GO