CREATE TABLE [Library].[PlasticCalc] (
  [ID] [int] IDENTITY,
  [Value] [varchar](255) NOT NULL,
  [Count] [varchar](255) NOT NULL,
  CONSTRAINT [PK_PlasticCalc_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'Library', 'TABLE', N'PlasticCalc', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Значение для поиска', 'SCHEMA', N'Library', 'TABLE', N'PlasticCalc', 'COLUMN', N'Value'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Результат', 'SCHEMA', N'Library', 'TABLE', N'PlasticCalc', 'COLUMN', N'Count'
GO