CREATE TABLE [dbo].[SolutionsPlannedDetails] (
  [ID] [int] IDENTITY,
  [SolutionsDeclaredID] [int] NOT NULL,
  [SolutionsPlannedID] [int] NOT NULL,
  [Date] [datetime] NOT NULL,
  CONSTRAINT [PK_SolutionsPlannedDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.SolutionsPlannedDetails.Date'
GO

ALTER TABLE [dbo].[SolutionsPlannedDetails]
  ADD CONSTRAINT [FK_SolutionsPlannedDetails_SolutionsPlanDeclared_ID] FOREIGN KEY ([SolutionsDeclaredID]) REFERENCES [dbo].[SolutionsDeclared] ([ID])
GO

ALTER TABLE [dbo].[SolutionsPlannedDetails]
  ADD CONSTRAINT [FK_SolutionsPlannedDetails_SolutionsPlanned_ID] FOREIGN KEY ([SolutionsPlannedID]) REFERENCES [dbo].[SolutionsPlanned] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Список регламентных работ, которые входят в плановую работу', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlannedDetails'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор записи', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlannedDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор регламентной работы', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlannedDetails', 'COLUMN', N'SolutionsDeclaredID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор плановой работы', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlannedDetails', 'COLUMN', N'SolutionsPlannedID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания записи', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsPlannedDetails', 'COLUMN', N'Date'
GO