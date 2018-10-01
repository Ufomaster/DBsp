CREATE TABLE [shifts].[ShiftsGroups] (
  [ID] [int] IDENTITY,
  [ManufactureStructureID] [smallint] NOT NULL,
  [Name] [varchar](255) NOT NULL,
  CONSTRAINT [PK_ShiftsGroups_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_ShiftsGroups_ManufactureStructureID_Name] UNIQUE ([ManufactureStructureID], [Name])
)
ON [PRIMARY]
GO

ALTER TABLE [shifts].[ShiftsGroups]
  ADD CONSTRAINT [FK_ShiftsGroups_ManufactureStructure_ID] FOREIGN KEY ([ManufactureStructureID]) REFERENCES [manufacture].[ManufactureStructure] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsGroups', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор цеха', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsGroups', 'COLUMN', N'ManufactureStructureID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsGroups', 'COLUMN', N'Name'
GO