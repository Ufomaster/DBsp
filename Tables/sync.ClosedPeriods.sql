CREATE TABLE [sync].[ClosedPeriods] (
  [ID] [tinyint] NULL,
  [Date] [datetime] NULL,
  [ModifyDate] [datetime] NULL
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [TR_ClosedPeriods_AFT_U] ON [sync].[ClosedPeriods]

FOR UPDATE
AS
BEGIN
    UPDATE sync.ClosedPeriods
    SET ModifyDate = GetDate()
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи, возможно в будущем пользователя 1с', 'SCHEMA', N'sync', 'TABLE', N'ClosedPeriods', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата периода из 1с', 'SCHEMA', N'sync', 'TABLE', N'ClosedPeriods', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата изменений', 'SCHEMA', N'sync', 'TABLE', N'ClosedPeriods', 'COLUMN', N'ModifyDate'
GO