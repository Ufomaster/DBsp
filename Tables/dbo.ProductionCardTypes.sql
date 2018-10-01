CREATE TABLE [dbo].[ProductionCardTypes] (
  [ID] [smallint] NOT NULL,
  [Name] [varchar](30) NOT NULL,
  [ProductionCardPropertiesID] [int] NOT NULL,
  [AdaptingGroupMaxCount] [smallint] NULL DEFAULT (1),
  [PrintReportID] [int] NULL,
  [ImageID] [int] NOT NULL,
  [StartStatusID] [smallint] NOT NULL,
  [ManufactureID] [smallint] NULL,
  [DepartmentCode1C] [varchar](36) NULL,
  [ProductClassCode1C] [varchar](36) NULL,
  [ProductClassName1C] [varchar](50) NULL,
  CONSTRAINT [PK_ProductionCardTypes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardTypes]
  ADD CONSTRAINT [FK_ProductionCardTypes_ManufactureStructure (manufacture)_ID] FOREIGN KEY ([ManufactureID]) REFERENCES [manufacture].[ManufactureStructure] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardTypes]
  ADD CONSTRAINT [FK_ProductionCardTypes_ProductionCardProperties_ID] FOREIGN KEY ([ProductionCardPropertiesID]) REFERENCES [dbo].[ProductionCardProperties] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardTypes]
  ADD CONSTRAINT [FK_ProductionCardTypes_ProductionCardStatuses_ID] FOREIGN KEY ([StartStatusID]) REFERENCES [dbo].[ProductionCardStatuses] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardTypes]
  ADD CONSTRAINT [FK_ProductionCardTypes_Reports_ID] FOREIGN KEY ([PrintReportID]) REFERENCES [dbo].[Reports] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Типы заказных листов', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardTypes'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardTypes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование типа заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardTypes', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на начальный узел дерева-конструктора технологии, который будет определять набор возможностей производства', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardTypes', 'COLUMN', N'ProductionCardPropertiesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Максимальное количество групп для согласования: null - количество не ограничено, Х - указанное количество групп.', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardTypes', 'COLUMN', N'AdaptingGroupMaxCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на печатную форму, которая будет запускаться для данного типа ЗЛ', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardTypes', 'COLUMN', N'PrintReportID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Индекс иконки', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardTypes', 'COLUMN', N'ImageID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Начальный статус', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardTypes', 'COLUMN', N'StartStatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'1c Код цеха производства', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardTypes', 'COLUMN', N'DepartmentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Гуид 1с класса продукта', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardTypes', 'COLUMN', N'ProductClassCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование класса продукта 1с', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardTypes', 'COLUMN', N'ProductClassName1C'
GO