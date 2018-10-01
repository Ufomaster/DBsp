CREATE TABLE [unknown].[Streets] (
  [ID] [int] IDENTITY,
  [PlaceID] [int] NOT NULL,
  [StreetTypeID] [int] NOT NULL,
  [Name] [varchar](255) NOT NULL,
  CONSTRAINT [PK_Streets_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_Streets_PlaceID]
  ON [unknown].[Streets] ([PlaceID])
  ON [PRIMARY]
GO

ALTER TABLE [unknown].[Streets]
  ADD CONSTRAINT [FK_Streets_Places_ID] FOREIGN KEY ([PlaceID]) REFERENCES [unknown].[Places] ([ID])
GO

ALTER TABLE [unknown].[Streets]
  ADD CONSTRAINT [FK_Streets_StreetTypes_ID] FOREIGN KEY ([StreetTypeID]) REFERENCES [unknown].[StreetTypes] ([ID])
GO