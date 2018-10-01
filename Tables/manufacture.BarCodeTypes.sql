CREATE TABLE [manufacture].[BarCodeTypes] (
  [ID] [smallint] IDENTITY,
  [Code] [varchar](3) NULL,
  [Name] [varchar](20) NULL,
  CONSTRAINT [PK_BarCodeTypes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'BarCodeTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код', 'SCHEMA', N'manufacture', 'TABLE', N'BarCodeTypes', 'COLUMN', N'Code'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'manufacture', 'TABLE', N'BarCodeTypes', 'COLUMN', N'Name'
GO