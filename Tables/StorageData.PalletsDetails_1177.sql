CREATE TABLE [StorageData].[PalletsDetails_1177] (
  [ID] [int] IDENTITY,
  [PalletID] [int] NULL,
  [BoxID] [int] NULL,
  [Status] [tinyint] NULL,
  [ModifyDate] [datetime] NOT NULL,
  [ModifyEmployeeID] [int] NOT NULL,
  CONSTRAINT [PK_PalletsDetails_1177_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'StorageData.PalletsDetails_1177.ModifyDate'
GO

ALTER TABLE [StorageData].[PalletsDetails_1177]
  ADD CONSTRAINT [FK_PalletsDetails_1177_Pallet_ID] FOREIGN KEY ([PalletID]) REFERENCES [StorageData].[Pallets_1177] ([ID])
GO