CREATE TABLE [dbo].[EquipmentStates] (
  [ID] [int] IDENTITY,
  [Name] [varchar](50) NOT NULL,
  [Comment] [varchar](5000) NULL,
  CONSTRAINT [PK_EquipmentSTatuses_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentStates', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentStates', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание', 'SCHEMA', N'dbo', 'TABLE', N'EquipmentStates', 'COLUMN', N'Comment'
GO