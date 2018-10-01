CREATE TABLE [unknown].[Houses] (
  [ID] [int] IDENTITY,
  [StreetID] [int] NOT NULL,
  [ZipCodeID] [int] NOT NULL,
  [Name] [varchar](255) NOT NULL,
  CONSTRAINT [PK_Houses_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_Houses_StreetID]
  ON [unknown].[Houses] ([StreetID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Houses_ZipCodeID]
  ON [unknown].[Houses] ([ZipCodeID])
  ON [PRIMARY]
GO

ALTER TABLE [unknown].[Houses]
  ADD CONSTRAINT [FK_Houses_Streets_ID] FOREIGN KEY ([StreetID]) REFERENCES [unknown].[Streets] ([ID])
GO

ALTER TABLE [unknown].[Houses]
  ADD CONSTRAINT [FK_Houses_ZipCode_ID] FOREIGN KEY ([ZipCodeID]) REFERENCES [dbo].[ZipCode] ([ID])
GO