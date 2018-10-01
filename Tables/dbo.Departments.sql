CREATE TABLE [dbo].[Departments] (
  [ID] [int] IDENTITY,
  [Name] [varchar](100) NOT NULL,
  [ParentID] [int] NULL,
  [NodeState] [bit] NOT NULL CONSTRAINT [DF_Departments_NodeState] DEFAULT (0),
  [NodeImageIndex] [int] NULL CONSTRAINT [DF_Departments_NodeImageIndex] DEFAULT (33),
  [Level] [int] NULL CONSTRAINT [DF_Departments_Level] DEFAULT (0),
  [TechResponsible] [bit] NOT NULL DEFAULT (0),
  [Code1C] [varchar](36) NULL,
  [UserCode1C] [varchar](30) NULL,
  [IsHidden] [bit] NULL,
  [MajorDepartmentID] [int] NULL,
  [ObjectTypeID] [int] NULL,
  CONSTRAINT [PK_Departments_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[Departments]
  ADD CONSTRAINT [FK_Departments_Departments_ID] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[Departments] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название подразделения', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор родительского подразделения', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'ParentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Состояние 0-Collapsed 1-Expanded', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'NodeState'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Индекс иконки', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'NodeImageIndex'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уровень ветви', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'Level'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Принадлежность подразделения к подразделениям решающим заявки.', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'TechResponsible'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', 'Code1C', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый пользователю код 1С', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'UserCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг скрытая ли запись', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'IsHidden'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор основного подраздления, для дублирующихся подразделений', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'MajorDepartmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор виртуального подразделения', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'ObjectTypeID'
GO