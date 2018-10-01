CREATE TABLE [unknown].[Districts] (
  [ID] [int] IDENTITY,
  [RegionID] [int] NOT NULL,
  [Name] [varchar](30) NOT NULL,
  CONSTRAINT [PK_Districts_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_Districts_RegionID]
  ON [unknown].[Districts] ([RegionID])
  ON [PRIMARY]
GO

ALTER TABLE [unknown].[Districts]
  ADD CONSTRAINT [FK_Districts_Regions_ID] FOREIGN KEY ([RegionID]) REFERENCES [unknown].[Regions] ([ID])
GO