CREATE TABLE [dbo].[UserRightsValues] (
  [ID] [int] NOT NULL,
  [Name] [nvarchar](50) NOT NULL,
  CONSTRAINT [PK_UserRightsValues_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Значения прав доступа к объектам системы', 'SCHEMA', N'dbo', 'TABLE', N'UserRightsValues'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'UserRightsValues', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'UserRightsValues', 'COLUMN', N'Name'
GO