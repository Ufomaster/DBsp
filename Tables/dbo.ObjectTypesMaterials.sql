CREATE TABLE [dbo].[ObjectTypesMaterials] (
  [ID] [int] IDENTITY,
  [ObjectTypeID] [int] NOT NULL,
  [BeginDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [TmcID] [int] NOT NULL,
  [GroupName] [varchar](30) NULL,
  CONSTRAINT [PK_ObjectTypesMatarials_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ObjectTypesMaterials]
  ADD CONSTRAINT [FK_ObjectTypesMaterials_ObjectTypes_ID] FOREIGN KEY ([ObjectTypeID]) REFERENCES [dbo].[ObjectTypes] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[ObjectTypesMaterials]
  ADD CONSTRAINT [FK_ObjectTypesMaterials_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesMaterials', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор значения справочника', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesMaterials', 'COLUMN', N'ObjectTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата, когда начала действовать норма расхода на материал', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesMaterials', 'COLUMN', N'BeginDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата, когда истек срок действия данной нормы расхода', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesMaterials', 'COLUMN', N'EndDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор материала', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesMaterials', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'группировка для одинакового материала', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesMaterials', 'COLUMN', N'GroupName'
GO