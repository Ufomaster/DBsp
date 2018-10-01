CREATE TABLE [manufacture].[TechnologicalCards] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NOT NULL,
  [ParentID] [int] NULL,
  [Code1C] [varchar](36) NULL,
  [Name] [varchar](255) NULL,
  [UserCode] [varchar](15) NULL,
  [DepartmentID] [int] NULL,
  [StateID] [tinyint] NULL,
  [AcceptDate] [datetime] NULL,
  [IsDeleted] [bit] NULL,
  [IsFolder] [bit] NULL,
  CONSTRAINT [PK_TechnologicalCards_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'manufacture.TechnologicalCards.CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCards', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'дата загрузки из 1с', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCards', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор родительской папки', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCards', 'COLUMN', N'ParentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCards', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCards', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый код 1с', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCards', 'COLUMN', N'UserCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор подразделения', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCards', 'COLUMN', N'DepartmentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'состояние', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCards', 'COLUMN', N'StateID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'дата утверждения', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCards', 'COLUMN', N'AcceptDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг удален в 1с', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCards', 'COLUMN', N'IsDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг папки в 1с', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCards', 'COLUMN', N'IsFolder'
GO