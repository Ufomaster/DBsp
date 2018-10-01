CREATE TABLE [shifts].[MDSCacheDetails] (
  [ID] [int] NOT NULL,
  [MDSCacheID] [int] NULL,
  [AVGChallengeTime] [decimal](18, 4) NULL,
  [Day] [tinyint] NULL,
  [Month] [tinyint] NULL,
  [Year] [smallint] NULL,
  [MINPackedDate] [datetime] NULL,
  [MAXPackedDate] [datetime] NULL,
  [EmployeeID] [int] NULL,
  [StorageStructureID] [int] NULL,
  [ShiftID] [int] NULL,
  [TotalCount] [int] NULL,
  CONSTRAINT [PK_MDSCacheDetails_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'MDSCacheDetails', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор шапки кеша', 'SCHEMA', N'shifts', 'TABLE', N'MDSCacheDetails', 'COLUMN', N'MDSCacheID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Апроксимированное время (в секундах) упаковки 1 ед продукции с фильтрацией пиков. 0 = пиковое время.', 'SCHEMA', N'shifts', 'TABLE', N'MDSCacheDetails', 'COLUMN', N'AVGChallengeTime'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'День операции', 'SCHEMA', N'shifts', 'TABLE', N'MDSCacheDetails', 'COLUMN', N'Day'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Месяц операции', 'SCHEMA', N'shifts', 'TABLE', N'MDSCacheDetails', 'COLUMN', N'Month'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Год операции', 'SCHEMA', N'shifts', 'TABLE', N'MDSCacheDetails', 'COLUMN', N'Year'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Минимальная дата упаковки в группированной выборке', 'SCHEMA', N'shifts', 'TABLE', N'MDSCacheDetails', 'COLUMN', N'MINPackedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Максимальная дата упаковки в группированной выборке', 'SCHEMA', N'shifts', 'TABLE', N'MDSCacheDetails', 'COLUMN', N'MAXPackedDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника оператора', 'SCHEMA', N'shifts', 'TABLE', N'MDSCacheDetails', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор рабочего места упаковки', 'SCHEMA', N'shifts', 'TABLE', N'MDSCacheDetails', 'COLUMN', N'StorageStructureID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор рабочей смены', 'SCHEMA', N'shifts', 'TABLE', N'MDSCacheDetails', 'COLUMN', N'ShiftID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Общее ко-во упакованных в групповой выборке', 'SCHEMA', N'shifts', 'TABLE', N'MDSCacheDetails', 'COLUMN', N'TotalCount'
GO