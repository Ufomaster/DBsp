CREATE TABLE [manufacture].[TechnologicalOperations] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NOT NULL,
  [ParentID] [int] NULL,
  [Code1C] [varchar](36) NULL,
  [Name] [varchar](255) NULL,
  [UserCode] [varchar](15) NULL,
  [UnitID] [int] NULL,
  [IsDeleted] [bit] NULL,
  [IsFolder] [bit] NULL,
  CONSTRAINT [PK_TechnologicalOperations_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UQ_TechnologicalOperations_Code1C]
  ON [manufacture].[TechnologicalOperations] ([Code1C])
  ON [PRIMARY]
GO

ALTER TABLE [manufacture].[TechnologicalOperations]
  ADD CONSTRAINT [FK_TechnologicalOperations_Units_ID] FOREIGN KEY ([UnitID]) REFERENCES [dbo].[Units] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperations', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата выгрузки в спеклер', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperations', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор родительской папки', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperations', 'COLUMN', N'ParentID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperations', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperations', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый код 1С', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperations', 'COLUMN', N'UserCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор единицы измерения', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperations', 'COLUMN', N'UnitID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг удален в 1с', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperations', 'COLUMN', N'IsDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг папка в 1с', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalOperations', 'COLUMN', N'IsFolder'
GO