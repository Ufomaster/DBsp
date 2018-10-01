CREATE TABLE [manufacture].[StorageStructureSectors] (
  [ID] [tinyint] IDENTITY,
  [Name] [varchar](50) NULL,
  [UseCurrentUser] [bit] NULL,
  [ShiftsGroupsID] [int] NULL,
  [SortOrder] [smallint] NULL,
  [Multiplier] [smallint] NULL DEFAULT (1),
  [WarehouseCode1C] [varchar](36) NULL,
  [DepartmentCode1C] [varchar](36) NULL,
  [IsDeleted] [bit] NULL,
  [IsCS] [bit] NULL,
  [IsProductionStorage] [bit] NULL,
  CONSTRAINT [PK_StorageStructureSectors_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_StorageStructureSectors_Name] UNIQUE ([Name], [IsDeleted])
)
ON [PRIMARY]
GO

ALTER TABLE [manufacture].[StorageStructureSectors]
  ADD CONSTRAINT [FK_StorageStructureSectors_ShiftsGroups_ID] FOREIGN KEY ([ShiftsGroupsID]) REFERENCES [shifts].[ShiftsGroups] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectors', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование участка', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectors', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Использовать текущего пользователя в выработке', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectors', 'COLUMN', N'UseCurrentUser'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор группы смен', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectors', 'COLUMN', N'ShiftsGroupsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Порядок сортировки для участков', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectors', 'COLUMN', N'SortOrder'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Множитель - коеффициент на который необходимо умножать произведенную и отбракованную продукцию, прошедшую через участок', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectors', 'COLUMN', N'Multiplier'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код склада 1С, для формирования документ на списание материалов', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectors', 'COLUMN', N'WarehouseCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код подразделения 1С, для формирования документ на списание материалов', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectors', 'COLUMN', N'DepartmentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг 1-удален', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectors', 'COLUMN', N'IsDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'0-нет, 1-участок цеха сборки', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectors', 'COLUMN', N'IsCS'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг является ли участок складом для ГП. Вероятно временно. на этом складе не накапливается ТМЦ в работе', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectors', 'COLUMN', N'IsProductionStorage'
GO