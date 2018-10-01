CREATE TABLE [dbo].[ObjectTypesSchemes] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NOT NULL,
  [FilterType] [int] NULL,
  [XMLSchema] [xml] NULL,
  CONSTRAINT [PK_ObjectTypesSchemes_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_ObjectTypesSchemes_Name] UNIQUE ([Name])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesSchemes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование схемы', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesSchemes', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Фильтрация сехмы по принадлежности к отделам 1-тор, 2-ит, 3-для всех', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesSchemes', 'COLUMN', N'FilterType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Схема', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesSchemes', 'COLUMN', N'XMLSchema'
GO