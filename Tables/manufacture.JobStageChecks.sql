CREATE TABLE [manufacture].[JobStageChecks] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  [JobStageID] [int] NULL,
  [SortOrder] [tinyint] NOT NULL,
  [TmcID] [int] NULL,
  [AddPrefix] [varchar](20) NULL,
  [AddSufix] [varchar](20) NULL,
  [DelBefore] [tinyint] NULL,
  [DelAfter] [tinyint] NULL,
  [CheckMask] [varchar](1000) NULL,
  [CheckLink] [bit] NULL DEFAULT (1),
  [CheckSortTmcID] [int] NULL,
  [CheckSortMsg] [varchar](255) NULL,
  [CheckSort] [bit] NULL,
  [TypeID] [tinyint] NOT NULL,
  [CheckOrder] [bit] NULL DEFAULT (1),
  [CheckCorrectPacking] [bit] NULL,
  [CheckDB] [bit] NULL DEFAULT (1),
  [isDeleted] [bit] NULL,
  [ImportTemplateColumnID] [int] NULL,
  [CheckUniqOnInsert] [bit] NULL,
  [MaxCount] [int] NULL,
  [MinCount] [int] NULL,
  [EqualityCheckID] [int] NULL,
  [UseMaskAsStaticValue] [bit] NOT NULL,
  [BarCodeDeviceKind] [smallint] NOT NULL,
  [BarCodeType] [smallint] NULL,
  CONSTRAINT [PK_JobStageChecks_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.JobStageChecks.CheckSort'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.JobStageChecks.CheckCorrectPacking'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.JobStageChecks.isDeleted'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.JobStageChecks.CheckUniqOnInsert'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.JobStageChecks.UseMaskAsStaticValue'
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.JobStageChecks.BarCodeDeviceKind'
GO

ALTER TABLE [manufacture].[JobStageChecks]
  ADD CONSTRAINT [FK_JobStageChecks_BarCodeTypes (manufacture)_ID] FOREIGN KEY ([BarCodeType]) REFERENCES [manufacture].[BarCodeTypes] ([ID])
GO

ALTER TABLE [manufacture].[JobStageChecks]
  ADD CONSTRAINT [FK_JobStageChecks_JobStageChecks (manufacture)_ID] FOREIGN KEY ([EqualityCheckID]) REFERENCES [manufacture].[JobStageChecks] ([ID])
GO

ALTER TABLE [manufacture].[JobStageChecks]
  ADD CONSTRAINT [FK_JobStageChecks_JobStageCheckTypes (manufacture)_ID] FOREIGN KEY ([TypeID]) REFERENCES [manufacture].[JobStageChecksTypes] ([ID])
GO

ALTER TABLE [manufacture].[JobStageChecks]
  ADD CONSTRAINT [FK_JobStageChecks_PTmcImportTemplateColumns (manufacture)_ID] FOREIGN KEY ([ImportTemplateColumnID]) REFERENCES [manufacture].[PTmcImportTemplateColumns] ([ID])
GO

ALTER TABLE [manufacture].[JobStageChecks]
  ADD CONSTRAINT [FK_JobStagesChecks_JobStages (manufacture)_ID] FOREIGN KEY ([JobStageID]) REFERENCES [manufacture].[JobStages] ([ID])
GO

ALTER TABLE [manufacture].[JobStageChecks]
  ADD CONSTRAINT [FK_JobStagesChecks_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверки для конкретного этапа работы', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание проверки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор этапа работы', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'JobStageID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядковый номер проверки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор персонализированного материала', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Подстрока, которая будет дописыватся перед началом вводимой строки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'AddPrefix'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Подстрока, которая будет дописыватся после вводимой строки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'AddSufix'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Количество полей для удаления в начале исходной строки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'DelBefore'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Количество полей для удаления в начале исходной строки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'DelAfter'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Маска, накладываемая на выражение, если выражение не будет подходить под маску, то проверка не будет пройдена', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'CheckMask'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверка связи между текущим ТМЦ и другими ТМЦ этапа. Отключается, только когда неизвестно что с чем будет связано.', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'CheckLink'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на материал, при совпадении с идентифкатором которого, появляется определенное сообщение оператору. Применяется, например, когда надо выбрать определенные номера из общей базы. ', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'CheckSortTmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сообщение, выпадающее при сортировке', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'CheckSortMsg'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Включает сортировку', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'CheckSort'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа проверки', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'TypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверка последовательности', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'CheckOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверка корректности упаковки. Проверяем первый, второй, предпоследний, последний номера внутри тары', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'CheckCorrectPacking'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Проверка в БД', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'CheckDB'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг, отображающий удалена ли запись', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'isDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор столбца группирующей таблицы', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'ImportTemplateColumnID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Максимум элементов которые может вместить тара', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'MaxCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Минимум элементов которые может вместить тара', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'MinCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Поле условие равенства', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'EqualityCheckID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Использовать маску для сравнения статического значения', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'UseMaskAsStaticValue'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Устройство считывания', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'BarCodeDeviceKind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип штрихкода', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageChecks', 'COLUMN', N'BarCodeType'
GO