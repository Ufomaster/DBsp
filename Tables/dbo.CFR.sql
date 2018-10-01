CREATE TABLE [dbo].[CFR] (
  [ID] [int] IDENTITY,
  [Code] [varchar](20) NULL,
  [Name] [varchar](100) NULL,
  CONSTRAINT [PK_CFR_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO