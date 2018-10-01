CREATE TABLE [dbo].[ProductionCardCancelReasons] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NOT NULL,
  CONSTRAINT [PK_ProductionCardCancelReasons_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCancelReasons', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание причины', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCancelReasons', 'COLUMN', N'Name'
GO