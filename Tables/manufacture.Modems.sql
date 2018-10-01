CREATE TABLE [manufacture].[Modems] (
  [ID] [tinyint] IDENTITY,
  [Name] [varchar](50) NOT NULL,
  CONSTRAINT [PK_Modems_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'manufacture', 'TABLE', N'Modems', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наимениование', 'SCHEMA', N'manufacture', 'TABLE', N'Modems', 'COLUMN', N'Name'
GO