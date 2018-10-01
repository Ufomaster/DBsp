CREATE TABLE [dbo].[Warehoueses] (
  [ID] [int] IDENTITY,
  [Name] [varchar](30) NULL,
  [DepartmentPositionID] [int] NULL,
  CONSTRAINT [PK_Warehoueses_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Warehoueses]
  ADD CONSTRAINT [FK_Warehoueses_DepartmentPositions_ID] FOREIGN KEY ([DepartmentPositionID]) REFERENCES [dbo].[DepartmentPositions] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Warehoueses', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование склада', 'SCHEMA', N'dbo', 'TABLE', N'Warehoueses', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор начальника склада', 'SCHEMA', N'dbo', 'TABLE', N'Warehoueses', 'COLUMN', N'DepartmentPositionID'
GO