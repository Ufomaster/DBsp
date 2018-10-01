CREATE TABLE [dbo].[UserRightsObjects] (
  [ID] [int] NOT NULL,
  [ParentID] [int] NULL,
  [Name] [nvarchar](75) NOT NULL,
  [IcoIndex] [int] NULL,
  [DelphiConst] [varchar](50) NULL,
  [Comment] [varchar](255) NULL,
  CONSTRAINT [PK_UserRightsObjects_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserRightsObjects]
  ADD CONSTRAINT [FK_UserRightsObjects_Objects] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[UserRightsObjects] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Объекты ограничения прав', 'SCHEMA', N'dbo', 'TABLE', N'UserRightsObjects'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'UserRightsObjects', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на предка в иерархии объектов', 'SCHEMA', N'dbo', 'TABLE', N'UserRightsObjects', 'COLUMN', N'ParentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'UserRightsObjects', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Делфийское имя константы. Для выгрузки', 'SCHEMA', N'dbo', 'TABLE', N'UserRightsObjects', 'COLUMN', N'DelphiConst'
GO