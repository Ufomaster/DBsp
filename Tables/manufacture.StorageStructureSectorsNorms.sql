CREATE TABLE [manufacture].[StorageStructureSectorsNorms] (
  [ID] [int] IDENTITY,
  [SectorID] [tinyint] NULL,
  [Amount] [decimal](38, 10) NOT NULL,
  [DateExpire] [datetime] NULL,
  CONSTRAINT [PK_StorageStructureSectorsNorms_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorsNorms', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на сектор', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorsNorms', 'COLUMN', N'SectorID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Значение нормы', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorsNorms', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата окончания действия нормы', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorsNorms', 'COLUMN', N'DateExpire'
GO