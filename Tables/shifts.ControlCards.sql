CREATE TABLE [shifts].[ControlCards] (
  [ID] [int] IDENTITY,
  [UserID] [int] NOT NULL,
  [RegisterDate] [datetime] NOT NULL,
  [WorkPlaceID] [smallint] NOT NULL,
  [ProductionCardCustomizeID] [int] NULL,
  CONSTRAINT [PK_ControlCards_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ControlCards_RegisterDate]
  ON [shifts].[ControlCards] ([RegisterDate])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ControlCards_RegisterDate_WorkPlaceID]
  ON [shifts].[ControlCards] ([RegisterDate], [WorkPlaceID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ControlCards_UserID]
  ON [shifts].[ControlCards] ([UserID])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ControlCards_WorkPlaceID]
  ON [shifts].[ControlCards] ([WorkPlaceID])
  ON [PRIMARY]
GO

ALTER TABLE [shifts].[ControlCards]
  ADD CONSTRAINT [FK_ControlCards_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

ALTER TABLE [shifts].[ControlCards]
  ADD CONSTRAINT [FK_ControlCards_StorageStructure (manufacture)_ID] FOREIGN KEY ([WorkPlaceID]) REFERENCES [manufacture].[StorageStructure] ([ID])
GO

ALTER TABLE [shifts].[ControlCards]
  ADD CONSTRAINT [FK_ControlCards_Users_ID] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'shifts', 'TABLE', N'ControlCards', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя', 'SCHEMA', N'shifts', 'TABLE', N'ControlCards', 'COLUMN', N'UserID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата регистрации', 'SCHEMA', N'shifts', 'TABLE', N'ControlCards', 'COLUMN', N'RegisterDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор рабочего места', 'SCHEMA', N'shifts', 'TABLE', N'ControlCards', 'COLUMN', N'WorkPlaceID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'shifts', 'TABLE', N'ControlCards', 'COLUMN', N'ProductionCardCustomizeID'
GO