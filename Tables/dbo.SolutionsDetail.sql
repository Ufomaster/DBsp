CREATE TABLE [dbo].[SolutionsDetail] (
  [ID] [int] IDENTITY,
  [SolutionID] [int] NOT NULL,
  [SolutionsDeclaredID] [int] NOT NULL,
  CONSTRAINT [PK_SolutionDetail_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[SolutionsDetail]
  ADD CONSTRAINT [FK_SolutionsDetail_Solutions_ID] FOREIGN KEY ([SolutionID]) REFERENCES [dbo].[Solutions] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SolutionsDetail]
  ADD CONSTRAINT [FK_SolutionsDetail_SolutionsDeclared_ID] FOREIGN KEY ([SolutionsDeclaredID]) REFERENCES [dbo].[SolutionsDeclared] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDetail', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор работы', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDetail', 'COLUMN', N'SolutionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор регламентной работы', 'SCHEMA', N'dbo', 'TABLE', N'SolutionsDetail', 'COLUMN', N'SolutionsDeclaredID'
GO