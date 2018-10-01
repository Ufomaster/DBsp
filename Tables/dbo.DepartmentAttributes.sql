CREATE TABLE [dbo].[DepartmentAttributes] (
  [ID] [int] IDENTITY,
  [DepartmentID] [int] NOT NULL,
  [AttributeID] [int] NULL,
  CONSTRAINT [PK_DepartmentAttributes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_DepartmentAttributes_AttributeID]
  ON [dbo].[DepartmentAttributes] ([AttributeID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_DepartmentAttributes_DepartmentID]
  ON [dbo].[DepartmentAttributes] ([DepartmentID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[DepartmentAttributes]
  ADD CONSTRAINT [FK_DepartmentAttributes_Attributes_ID] FOREIGN KEY ([AttributeID]) REFERENCES [dbo].[Attributes] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[DepartmentAttributes]
  ADD CONSTRAINT [FK_DepartmentAttributes_Departments_ID] FOREIGN KEY ([DepartmentID]) REFERENCES [dbo].[Departments] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'DepartmentAttributes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор подразделения', 'SCHEMA', N'dbo', 'TABLE', N'DepartmentAttributes', 'COLUMN', N'DepartmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор атрибута', 'SCHEMA', N'dbo', 'TABLE', N'DepartmentAttributes', 'COLUMN', N'AttributeID'
GO