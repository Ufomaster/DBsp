CREATE TABLE [dbo].[ProductionCardCustomizeAdaptingsMes] (
  [ID] [int] IDENTITY,
  [ProductionCardCustomizeAdaptingsID] [int] NOT NULL,
  [CreateDate] [datetime] NOT NULL,
  [CompleteDate] [datetime] NULL,
  [Status] [tinyint] NOT NULL,
  [ComplainBody] [varchar](2000) NULL,
  CONSTRAINT [PK_ProductionCardCustomizeAdaptingsMes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.ProductionCardCustomizeAdaptingsMes.CreateDate'
GO

ALTER TABLE [dbo].[ProductionCardCustomizeAdaptingsMes]
  ADD CONSTRAINT [FK_ProductionCardCustomizeAdaptingsMes_ProductionCardCustomizeAdaptings_ID] FOREIGN KEY ([ProductionCardCustomizeAdaptingsID]) REFERENCES [dbo].[ProductionCardCustomizeAdaptings] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptingsMes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор звена согласования', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptingsMes', 'COLUMN', N'ProductionCardCustomizeAdaptingsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptingsMes', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата закрытия претензии', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptingsMes', 'COLUMN', N'CompleteDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Статус претензии 0-Новая,1-Решена', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptingsMes', 'COLUMN', N'Status'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Текст претензии', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptingsMes', 'COLUMN', N'ComplainBody'
GO