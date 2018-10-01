CREATE TABLE [dbo].[ElectricityMeterReadings] (
  [ID] [smallint] IDENTITY,
  [ElectricityMeterID] [tinyint] NULL,
  [Date] [datetime] NULL,
  [OldValue] [int] NULL,
  [NewValue] [int] NULL,
  CONSTRAINT [PK_ElectricityMeterReadings_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'dbo', 'TABLE', N'ElectricityMeterReadings', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на идентификатор счетчика', 'SCHEMA', N'dbo', 'TABLE', N'ElectricityMeterReadings', 'COLUMN', N'ElectricityMeterID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата занесения информации', 'SCHEMA', N'dbo', 'TABLE', N'ElectricityMeterReadings', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Предыдущее показание счетчика', 'SCHEMA', N'dbo', 'TABLE', N'ElectricityMeterReadings', 'COLUMN', N'OldValue'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Текущее показание счетчика', 'SCHEMA', N'dbo', 'TABLE', N'ElectricityMeterReadings', 'COLUMN', N'NewValue'
GO