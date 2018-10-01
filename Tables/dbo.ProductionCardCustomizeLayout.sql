CREATE TABLE [dbo].[ProductionCardCustomizeLayout] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NOT NULL,
  [Data] [varbinary](max) NULL,
  [EmployeeID] [int] NOT NULL,
  [ProductionCardCustomizeID] [int] NOT NULL,
  [PictureTypeID] [int] NOT NULL,
  [FileName] [varchar](255) NULL,
  [LinkType] [bit] NOT NULL,
  CONSTRAINT [PK_ProductionCardCustomizeLayout_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_ProductionCardCustomizeLayout_ProductionCardCustomizeID]
  ON [dbo].[ProductionCardCustomizeLayout] ([ProductionCardCustomizeID])
  ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'dbo.ProductionCardCustomizeLayout.LinkType'
GO

ALTER TABLE [dbo].[ProductionCardCustomizeLayout]
  ADD CONSTRAINT [FK_ProductionCardCustomizeLayout_Employees_ID] FOREIGN KEY ([EmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomizeLayout]
  ADD CONSTRAINT [FK_ProductionCardCustomizeLayout_PictureTypes_ID] FOREIGN KEY ([PictureTypeID]) REFERENCES [dbo].[PictureTypes] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomizeLayout]
  ADD CONSTRAINT [FK_ProductionCardCustomizeLayout_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeLayout', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата добавления', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeLayout', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Картинка лицо + оборот jpg', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeLayout', 'COLUMN', N'Data'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Менеджер - дизайнер', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeLayout', 'COLUMN', N'EmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeLayout', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор типа картинки', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeLayout', 'COLUMN', N'PictureTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование файла', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeLayout', 'COLUMN', N'FileName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вид связи. 0 только заказной лист, 1 - зл + спецификация', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeLayout', 'COLUMN', N'LinkType'
GO