CREATE TABLE [dbo].[DepartmentPositions] (
  [ID] [int] IDENTITY,
  [PositionID] [int] NOT NULL,
  [DepartmentID] [int] NOT NULL,
  [isHidden] [bit] NULL,
  CONSTRAINT [PK_DepartmentsPositions_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_DepartmentPositions_DepartmentID]
  ON [dbo].[DepartmentPositions] ([DepartmentID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_DepartmentPositions_PositionID]
  ON [dbo].[DepartmentPositions] ([PositionID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[DepartmentPositions]
  ADD CONSTRAINT [FK_DepartmentPositions_Departments_ID] FOREIGN KEY ([DepartmentID]) REFERENCES [dbo].[Departments] ([ID])
GO

ALTER TABLE [dbo].[DepartmentPositions]
  ADD CONSTRAINT [FK_DepartmentPositions_Positions_ID] FOREIGN KEY ([PositionID]) REFERENCES [dbo].[Positions] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'DepartmentPositions', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор должности', 'SCHEMA', N'dbo', 'TABLE', N'DepartmentPositions', 'COLUMN', N'PositionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор департамента', 'SCHEMA', N'dbo', 'TABLE', N'DepartmentPositions', 'COLUMN', N'DepartmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг удалена ли запись', 'SCHEMA', N'dbo', 'TABLE', N'DepartmentPositions', 'COLUMN', N'isHidden'
GO