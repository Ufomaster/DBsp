CREATE TABLE [StorageData].[Pallets_1177] (
  [ID] [int] IDENTITY,
  [Value] [varchar](255) NULL,
  CONSTRAINT [PK_Pallets_1177_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_Pallets_1177_Value]
  ON [StorageData].[Pallets_1177] ([Value])
  ON [PRIMARY]
GO