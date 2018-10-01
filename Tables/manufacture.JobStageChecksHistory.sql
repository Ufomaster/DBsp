CREATE TABLE [manufacture].[JobStageChecksHistory] (
  [ID] [int] IDENTITY,
  [ModifyEmployeeID] [int] NOT NULL,
  [JobStageCheckID] [int] NULL,
  [OperationType] [tinyint] NULL,
  [ModifyDate] [datetime] NOT NULL,
  [Name] [varchar](255) NULL,
  [JobStageID] [int] NULL,
  [SortOrder] [tinyint] NOT NULL,
  [TmcID] [int] NULL,
  [AddPrefix] [varchar](20) NULL,
  [AddSufix] [varchar](20) NULL,
  [DelBefore] [tinyint] NULL,
  [DelAfter] [tinyint] NULL,
  [CheckMask] [varchar](1000) NULL,
  [CheckLink] [bit] NULL,
  [CheckSortTmcID] [int] NULL,
  [CheckSortMsg] [varchar](255) NULL,
  [CheckSort] [bit] NULL DEFAULT (0),
  [TypeID] [tinyint] NULL,
  [CheckOrder] [bit] NULL,
  [CheckCorrectPacking] [bit] NULL,
  [CheckDB] [bit] NULL,
  [isDeleted] [bit] NULL,
  [ImportTemplateColumnID] [int] NULL,
  [CheckUniqOnInsert] [bit] NULL,
  [MaxCount] [int] NULL,
  [MinCount] [int] NULL,
  [EqualityCheckID] [int] NULL,
  [UseMaskAsStaticValue] [bit] NULL,
  CONSTRAINT [PK_JobStageCheksHistory_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'manufacture.JobStageChecksHistory.ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверки для конкретного этапа работы', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на пользователя, внесшего изменения', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на проверку', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'JobStageCheckID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции 0-вставка, 1-апдейт, 2-удаление', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата внесения изменения', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание проверки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на этап работы', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'JobStageID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядковый номер проверки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на персонализированный материал', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Подстрока, которая будет дописыватся перед началом вводимой строки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'AddPrefix'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Подстрока, которая будет дописыватся после вводимой строки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'AddSufix'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Количество полей для удаления в начале исходной строки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'DelBefore'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Количество полей для удаления в начале исходной строки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'DelAfter'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Маска, накладываемая на выражение, если выражение не будет подходить под маску, то проверка не будет пройдена', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'CheckMask'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверка связи между текущим ТМЦ и другими ТМЦ этапа. Отключается, только когда неизвестно что с чем будет связано.', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'CheckLink'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на материал, при совпадении с идентифкатором которого, появляется определенное сообщение оператору. Применяется, например, когда надо выбрать определенные номера из общей базы. ', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'CheckSortTmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сообщение, выпадающее при сортировке', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'CheckSortMsg'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Включает сортировку', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'CheckSort'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на тип проверки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'TypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверка последовательности', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'CheckOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверка корректности упаковки. Проверяем первый, второй, предпоследний, последний номера внутри тары', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'CheckCorrectPacking'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверка в БД', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'CheckDB'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг, отображающий удалена ли запись', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'isDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на столбец шаблона импорта', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'ImportTemplateColumnID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Максимум элементов которые может вместить тара', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'MaxCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Минимум элементов которые может вместить тара', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'MinCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Поле условие равенства', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'EqualityCheckID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Использовать маску для сравнения статического значения', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecksHistory', 'COLUMN', N'UseMaskAsStaticValue'
GO