CREATE TABLE [manufacture].[StorageStructureSectorFunctionRights] (
  [ID] [int] IDENTITY,
  [SectorID] [tinyint] NULL,
  [EmployeeID] [int] NULL,
  [fAddNonStandart] [bit] NULL,
  [fAddStandart] [bit] NULL,
  [fAdd] [bit] NULL,
  [fWriteOff] [bit] NULL,
  [fProduce] [bit] NULL,
  [fSetFail] [bit] NULL,
  [fReturnFailed] [bit] NULL,
  [fMoveProduct] [bit] NULL,
  [fMoveToStorage] [bit] NULL,
  [fUtilizeFailed] [bit] NULL,
  [fChangePCC] [bit] NULL,
  [fEditHistory] [bit] NULL,
  [fShip] [bit] NULL,
  [fPRecalc] [bit] NULL,
  [fProduceDelete] [bit] NULL,
  [fConfirmRemains] [bit] NULL,
  CONSTRAINT [PK_StorageStructureSectorFunctionRights_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [manufacture].[StorageStructureSectorFunctionRights]
  ADD CONSTRAINT [FK_StorageStructureSectorFunctionRights_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [manufacture].[StorageStructureSectorFunctionRights]
  ADD CONSTRAINT [FK_StorageStructureSectorFunctionRights_StorageStructureSectors_ID] FOREIGN KEY ([SectorID]) REFERENCES [manufacture].[StorageStructureSectors] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор участка', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'SectorID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Добавить не стандартный материал', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fAddNonStandart'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Добавить стандартный материал', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fAddStandart'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Добавить полуфабрикат', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fAdd'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Списать', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fWriteOff'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Произвести продукцию', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fProduce'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Создать брак', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fSetFail'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вернуть брак', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fReturnFailed'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Перемещение только ГП', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fMoveProduct'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Перемещение любых материалов на склад.', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fMoveToStorage'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Утилизировать', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fUtilizeFailed'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сменить ЗЛ у тмц', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fChangePCC'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Показывать историю', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fEditHistory'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Отгрузить', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fShip'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пресчет ГП в ЦС', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fPRecalc'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Удаление из спысываемых ТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fProduceDelete'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Принятие остатков', 'SCHEMA', N'manufacture', 'TABLE', N'StorageStructureSectorFunctionRights', 'COLUMN', N'fConfirmRemains'
GO