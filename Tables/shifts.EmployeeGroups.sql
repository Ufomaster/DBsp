CREATE TABLE [shifts].[EmployeeGroups] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NOT NULL,
  [ManufactureStructureID] [smallint] NULL,
  CONSTRAINT [PK_EmployeeGroups_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [shifts].[EmployeeGroups]
  ADD CONSTRAINT [FK_EmployeeGroups_ManufactureStructure (manufacture)_ID] FOREIGN KEY ([ManufactureStructureID]) REFERENCES [manufacture].[ManufactureStructure] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroups', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroups', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор производственной единицы', 'SCHEMA', N'shifts', 'TABLE', N'EmployeeGroups', 'COLUMN', N'ManufactureStructureID'
GO