CREATE TABLE [Library].[CartonCalc] (
  [ID] [int] IDENTITY,
  [Value] [varchar](255) NOT NULL,
  [Count] [varchar](255) NOT NULL,
  CONSTRAINT [PK_CartonCalc_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'Library', 'TABLE', N'CartonCalc', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Значение для поиска', 'SCHEMA', N'Library', 'TABLE', N'CartonCalc', 'COLUMN', N'Value'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Результат', 'SCHEMA', N'Library', 'TABLE', N'CartonCalc', 'COLUMN', N'Count'
GO