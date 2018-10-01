CREATE TABLE [manufacture].[ManufactureStructure] (
  [ID] [smallint] IDENTITY,
  [Name] [varchar](255) NULL,
  [Code1C] [varchar](36) NULL,
  [DepartmentCode1C] [varchar](36) NULL,
  CONSTRAINT [PK_ManufactureStructure_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'ManufactureStructure', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'manufacture', 'TABLE', N'ManufactureStructure', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с', 'SCHEMA', N'manufacture', 'TABLE', N'ManufactureStructure', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с Подразделения накладных требований', 'SCHEMA', N'manufacture', 'TABLE', N'ManufactureStructure', 'COLUMN', N'DepartmentCode1C'
GO