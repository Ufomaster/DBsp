﻿CREATE TABLE [dod].[XCardsData_5] (
  [ID] [int] IDENTITY,
  [UID] [varchar](14) NULL,
  [CardMasterKey] [varchar](32) NULL,
  [CardConfigurationKey] [varchar](32) NULL,
  [CardLevel3SwitchKey] [varchar](32) NULL,
  [ModifyDate] [datetime] NULL,
  [MTrack1] [varchar](255) NULL,
  [MTrack2] [varchar](255) NULL,
  [MTrack3] [varchar](255) NULL,
  [Status] [tinyint] NULL,
  CONSTRAINT [PK_XCardsData_5_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [IDX_XCardsData_5UID]
  ON [dod].[XCardsData_5] ([UID])
  ON [PRIMARY]
GO