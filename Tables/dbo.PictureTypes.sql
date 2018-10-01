CREATE TABLE [dbo].[PictureTypes] (
  [ID] [int] NOT NULL,
  [Name] [varchar](60) NOT NULL,
  CONSTRAINT [PK_PictureTypes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор записи', 'SCHEMA', N'dbo', 'TABLE', N'PictureTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'dbo', 'TABLE', N'PictureTypes', 'COLUMN', N'Name'
GO