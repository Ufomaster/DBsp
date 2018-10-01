﻿CREATE TABLE [dod].[DodImportTable] (
  [ID] [int] IDENTITY,
  [UID] [varchar](14) NULL,
  [CardMasterKey] [varchar](32) NULL,
  [CardConfigurationKey] [varchar](32) NULL,
  [CardLevel3SwitchKey] [varchar](32) NULL,
  [MTrack1] [varchar](255) NULL,
  [MTrack2] [varchar](255) NULL,
  [MTrack3] [varchar](255) NULL,
  [Sector] [tinyint] NULL,
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
  [AESkeyB] [varchar](32) NULL
)
ON [PRIMARY]
GO