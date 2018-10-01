CREATE TABLE [StorageData].[G_1177] (
  [ID] [int] IDENTITY,
  [OperationID] [int] NULL,
  [Column_1] [int] NULL,
  [Column_2] [int] NULL,
  [Column_3] [int] NULL,
  CONSTRAINT [PK_G_1177_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_G_1177_Column_1]
  ON [StorageData].[G_1177] ([Column_1])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_G_1177_Column_2]
  ON [StorageData].[G_1177] ([Column_2])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_G_1177_Column_3]
  ON [StorageData].[G_1177] ([Column_3])
  ON [PRIMARY]
GO

ALTER TABLE [StorageData].[G_1177]
  ADD CONSTRAINT [FK_G_1177_Operations_ID] FOREIGN KEY ([OperationID]) REFERENCES [manufacture].[PTmcOperations] ([ID])
GO