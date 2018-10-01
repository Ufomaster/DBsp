CREATE TABLE [dbo].[ZipCode] (
  [ID] [int] IDENTITY,
  [Name] [varchar](10) NOT NULL,
  CONSTRAINT [PK_ZipCode_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO