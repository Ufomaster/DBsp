CREATE TABLE [manufacture].[PTmcStatuses] (
  [ID] [tinyint] NOT NULL,
  [Name] [varchar](30) NOT NULL,
  [AttachedToStorage] [bit] NOT NULL DEFAULT (1),
  [isEnabled] [bit] NOT NULL,
  [Short] [varchar](1) NULL,
  CONSTRAINT [PK_PTmcStatuses_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.PTmcStatuses.isEnabled'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcStatuses', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcStatuses', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Показывает нужно ли выводить все ТМЦ в данном статусе вне зависимости от выбранного склада', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcStatuses', 'COLUMN', N'AttachedToStorage'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Начальное состояние галочки с данным статусом на интерфейсе складов. 1 - показывать ТМЦ с данным статусом, 0 - не показывать.', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcStatuses', 'COLUMN', N'isEnabled'
GO