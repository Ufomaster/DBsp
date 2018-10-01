CREATE TABLE [dod].[XCardsData_4Details] (
  [ID] [int] IDENTITY,
  [XCardsDataID] [int] NULL,
  [Sector] [int] NULL,
  [Block0] [varchar](32) NULL,
  [Block1] [varchar](32) NULL,
  [Block2] [varchar](32) NULL,
  [Block3] [varchar](32) NULL,
  [Block4] [varchar](32) NULL,
  [Block5] [varchar](32) NULL,
  [Block6] [varchar](32) NULL,
  [Block7] [varchar](32) NULL,
  [Block8] [varchar](32) NULL,
  [Block9] [varchar](32) NULL,
  [Block10] [varchar](32) NULL,
  [Block11] [varchar](32) NULL,
  [Block12] [varchar](32) NULL,
  [Block13] [varchar](32) NULL,
  [Block14] [varchar](32) NULL,
  [Block15] [varchar](32) NULL,
  [AESkeyA] [varchar](32) NULL,
  [AESkeyB] [varchar](32) NULL,
  CONSTRAINT [PK_XCardsData_4Details_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_XCardsData_4DetailsSector]
  ON [dod].[XCardsData_4Details] ([Sector])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_XCardsData_4DetailsXCardsDataID]
  ON [dod].[XCardsData_4Details] ([XCardsDataID])
  ON [PRIMARY]
GO

ALTER TABLE [dod].[XCardsData_4Details]
  ADD CONSTRAINT [FK_XCardsData_4Details_XCardsData_ID] FOREIGN KEY ([XCardsDataID]) REFERENCES [dod].[XCardsData_4] ([ID])
GO