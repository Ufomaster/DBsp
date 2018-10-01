CREATE TABLE [dbo].[ProductionCardAdaptingGroups] (
  [ID] [int] IDENTITY,
  [Name] [varchar](30) NOT NULL,
  [ProductionCardTypeID] [smallint] NOT NULL,
  CONSTRAINT [PK_ProductionCardAdaptingGroups_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductionCardAdaptingGroups]
  ADD CONSTRAINT [FK_ProductionCardAdaptingGroups_ProductionCardTypes_ID] FOREIGN KEY ([ProductionCardTypeID]) REFERENCES [dbo].[ProductionCardTypes] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Группы согласователей', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingGroups'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingGroups', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Название группы согласователей', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingGroups', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на тип заказных листов', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardAdaptingGroups', 'COLUMN', N'ProductionCardTypeID'
GO