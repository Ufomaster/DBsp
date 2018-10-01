CREATE TABLE [unknown].[Regions] (
  [ID] [int] IDENTITY,
  [CountryID] [int] NOT NULL,
  [Name] [varchar](30) NOT NULL,
  CONSTRAINT [PK_Regions_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_Regions_CountryID]
  ON [unknown].[Regions] ([CountryID])
  ON [PRIMARY]
GO

ALTER TABLE [unknown].[Regions]
  ADD CONSTRAINT [FK_Regions_Countries_ID] FOREIGN KEY ([CountryID]) REFERENCES [unknown].[Countries] ([ID])
GO