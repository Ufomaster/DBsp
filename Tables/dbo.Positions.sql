CREATE TABLE [dbo].[Positions] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NOT NULL,
  [Code1C] [varchar](36) NULL,
  [UserCode1C] [varchar](30) NULL,
  [IsHidden] [bit] NULL,
  CONSTRAINT [PK_Positions_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Positions', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название должности', 'SCHEMA', N'dbo', 'TABLE', N'Positions', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', 'Code1C', 'SCHEMA', N'dbo', 'TABLE', N'Positions', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый пользователю код 1С', 'SCHEMA', N'dbo', 'TABLE', N'Positions', 'COLUMN', N'UserCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг скрытая ли запись', 'SCHEMA', N'dbo', 'TABLE', N'Positions', 'COLUMN', N'IsHidden'
GO