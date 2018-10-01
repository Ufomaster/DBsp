CREATE TABLE [sync].[1CSpec] (
  [ID] [int] IDENTITY,
  [VisibleCode] [varchar](10) NULL,
  [Code1C] [varchar](36) NULL,
  [Name] [varchar](100) NULL,
  [Kind] [tinyint] NULL,
  [TMCCode1C] [varchar](36) NULL,
  [DepartmentCode1C] [varchar](36) NULL,
  [ModifyName1C] [varchar](100) NULL,
  [ModifyDate1C] [datetime] NULL,
  [Status] [tinyint] NULL,
  [CreateDate] [datetime] NOT NULL,
  [EmployeeID] [int] NOT NULL,
  [ProductionCardCustomizeID] [int] NOT NULL,
  [TechCardNum] [varchar](30) NULL,
  [ReleaseDate] [datetime] NULL,
  [Amount] [int] NULL,
  [ZLDepartmentCode1C] [varchar](36) NULL,
  [ErrorMessage] [varchar](max) NULL,
  [ProductClassCode1C] [varchar](36) NULL,
  [WeightGross] [decimal](18, 2) NULL,
  [WeightNet] [decimal](18, 2) NULL,
  [PackingID] [tinyint] NULL,
  [PackingName] [varchar](255) NULL,
  [PackingNameEng] [varchar](255) NULL,
  [WeightPlaceCount] [smallint] NULL,
  [TCCode1C] [varchar](36) NULL,
  [ParentZLNumber] [varchar](30) NULL,
  CONSTRAINT [PK__1CSpec__3214EC27551B3D33] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.[1CSpec].CreateDate'
GO

ALTER TABLE [sync].[1CSpec]
  ADD CONSTRAINT [FK_1CSpec_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'VisibleCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Гуид 1c', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вид cпецификации 1 – Сборочная 2 – Узел.', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'Kind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Гуид Номенклатуры', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'TMCCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Гуид Подразделения, если вид спецификации «Узел».', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'DepartmentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя пользователя 1с', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'ModifyName1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата модификации в 1с', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'ModifyDate1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус записи 0 – не готово к обработке, 1 – запись готова к загрузке в 1С, 2 – ошибка, 3 – помечен на удаление в 1С, 4-элемент записан в 1С', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания записи', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника создателя ', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'тех. карта', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'TechCardNum'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'дата сдачи', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'ReleaseDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во по зл', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код департамента производства ЗЛ', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'ZLDepartmentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Текст ошибки синхронизации', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'ErrorMessage'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Гуид 1С класса продукта', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'ProductClassCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вес брутто', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'WeightGross'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'вес нетто', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'WeightNet'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип упаковки', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'PackingID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя типа упаковки', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'PackingName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя типа упаковки англ', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'PackingNameEng'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во мест груза', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'WeightPlaceCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с ТК из ЗЛ', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'TCCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер Зл сборки', 'SCHEMA', N'sync', 'TABLE', N'1CSpec', 'COLUMN', N'ParentZLNumber'
GO