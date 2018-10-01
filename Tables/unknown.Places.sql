CREATE TABLE [unknown].[Places] (
  [ID] [int] IDENTITY,
  [RegionID] [int] NULL,
  [DistrictID] [int] NULL,
  [PlaceTypeID] [int] NOT NULL,
  [Name] [varchar](30) NOT NULL,
  CONSTRAINT [PK_Places_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_Places_DistrictID]
  ON [unknown].[Places] ([DistrictID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Places_RegionID]
  ON [unknown].[Places] ([RegionID])
  ON [PRIMARY]
GO

ALTER TABLE [unknown].[Places]
  ADD CONSTRAINT [FK_Place_PlaceTypes_ID] FOREIGN KEY ([PlaceTypeID]) REFERENCES [unknown].[PlaceTypes] ([ID])
GO

ALTER TABLE [unknown].[Places]
  ADD CONSTRAINT [FK_Places_Districts_ID] FOREIGN KEY ([DistrictID]) REFERENCES [unknown].[Districts] ([ID])
GO

ALTER TABLE [unknown].[Places]
  ADD CONSTRAINT [FK_Places_Regions_ID] FOREIGN KEY ([RegionID]) REFERENCES [unknown].[Regions] ([ID])
GO