CREATE TABLE [dbo].[NDSHistory] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NOT NULL,
  [NDSPercent] [float] NULL,
  [NDSMultiplier] [float] NULL,
  CONSTRAINT [PK_NDSHistory_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'NDSHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата начала действия ставки', 'SCHEMA', N'dbo', 'TABLE', N'NDSHistory', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Процент НДС', 'SCHEMA', N'dbo', 'TABLE', N'NDSHistory', 'COLUMN', N'NDSPercent'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Множитель', 'SCHEMA', N'dbo', 'TABLE', N'NDSHistory', 'COLUMN', N'NDSMultiplier'
GO