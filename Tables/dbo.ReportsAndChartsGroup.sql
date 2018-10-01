CREATE TABLE [dbo].[ReportsAndChartsGroup] (
  [ID] [int] IDENTITY,
  [ParentID] [int] NULL,
  [Name] [varchar](255) NOT NULL,
  [ImageID] [int] NULL CONSTRAINT [DF_ReportsAndChartsGroup_ImageID] DEFAULT (0),
  [NodeState] [bit] NULL,
  CONSTRAINT [PK_ReportsAndChartsGroup_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsGroup', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Родитель', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsGroup', 'COLUMN', N'ParentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование группы', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsGroup', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Индекс иконки', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsGroup', 'COLUMN', N'ImageID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'0-Свернуто, 1-Развернуто', 'SCHEMA', N'dbo', 'TABLE', N'ReportsAndChartsGroup', 'COLUMN', N'NodeState'
GO