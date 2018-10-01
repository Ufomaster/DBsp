CREATE TABLE [dbo].[Tmc] (
  [ID] [int] IDENTITY,
  [XMLData] [xml] NULL,
  [ObjectTypeID] [int] NOT NULL,
  [RegistrationDate] [datetime] NOT NULL CONSTRAINT [DF_Tmc_RegistrationDate] DEFAULT (getdate()),
  [Name] [nvarchar](500) NOT NULL,
  [DeadCount] [int] NOT NULL CONSTRAINT [DF_Tmc_DeadCount] DEFAULT (0),
  [PartNumber] [varchar](50) NULL,
  [Code1C] [varchar](36) NULL,
  [IsHidden] [bit] NULL,
  [UserCode1C] [varchar](30) NULL,
  [UnitID] [int] NULL,
  [ProdCardNumber] [varchar](10) NULL,
  [LastAccessDate] [datetime] NULL,
  CONSTRAINT [PK_Tmc_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_Tmc_Code1C]
  ON [dbo].[Tmc] ([Code1C])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Tmc_ObjectTypeID]
  ON [dbo].[Tmc] ([ObjectTypeID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[Tmc]
  ADD CONSTRAINT [FK_Tmc_ObjectTypes_ID] FOREIGN KEY ([ObjectTypeID]) REFERENCES [dbo].[ObjectTypes] ([ID])
GO

ALTER TABLE [dbo].[Tmc]
  ADD CONSTRAINT [FK_Tmc_Units_ID] FOREIGN KEY ([UnitID]) REFERENCES [dbo].[Units] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Tmc', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Данные атома ТМЦ в формате XML', 'SCHEMA', N'dbo', 'TABLE', N'Tmc', 'COLUMN', N'XMLData'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор схемы наполнения свойств', 'SCHEMA', N'dbo', 'TABLE', N'Tmc', 'COLUMN', N'ObjectTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата регистрации ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'Tmc', 'COLUMN', N'RegistrationDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Общее описание', 'SCHEMA', N'dbo', 'TABLE', N'Tmc', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Выделять цветом если остатки меньще чем указано. 0- не выделять', 'SCHEMA', N'dbo', 'TABLE', N'Tmc', 'COLUMN', N'DeadCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Артикул', 'SCHEMA', N'dbo', 'TABLE', N'Tmc', 'COLUMN', N'PartNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', 'Code1C', 'SCHEMA', N'dbo', 'TABLE', N'Tmc', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг скрытая ли запись', 'SCHEMA', N'dbo', 'TABLE', N'Tmc', 'COLUMN', N'IsHidden'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый пользователю код 1С', 'SCHEMA', N'dbo', 'TABLE', N'Tmc', 'COLUMN', N'UserCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор единицы измерения', 'SCHEMA', N'dbo', 'TABLE', N'Tmc', 'COLUMN', N'UnitID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'№ заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'Tmc', 'COLUMN', N'ProdCardNumber'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата последней операции над ТМЦ в цс. Отслеживается в операторе мдс, и функциях перемещения и импорта', 'SCHEMA', N'dbo', 'TABLE', N'Tmc', 'COLUMN', N'LastAccessDate'
GO