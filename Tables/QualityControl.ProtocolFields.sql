CREATE TABLE [QualityControl].[ProtocolFields] (
  [colid] [int] NOT NULL,
  [Name] [varchar](50) NULL,
  [Value] [varchar](255) NULL,
  [AbstractBlockID] [smallint] NULL,
  CONSTRAINT [PK_ProtocolFields_colid] PRIMARY KEY CLUSTERED ([colid])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', 'select b.column_id, b.[name] from sys.[columns] b where b.object_id = (select object_id from sys.objects c where c.name = ''Protocols'' and schema_id = 9)', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolFields', 'COLUMN', N'colid'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'имя поля бд', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolFields', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolFields', 'COLUMN', N'Value'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Условная группировка для сортировки списка полей', 'SCHEMA', N'QualityControl', 'TABLE', N'ProtocolFields', 'COLUMN', N'AbstractBlockID'
GO