CREATE TABLE [dbo].[ProductionCardCustomizeAdaptingsMesChat] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NULL,
  [Body] [varchar](max) NOT NULL,
  [SenderEmployeeID] [int] NOT NULL,
  [ProductionCardCustomizeAdaptingsMesID] [int] NOT NULL,
  CONSTRAINT [PK_ProductionCardCustomizeAdaptingsMesChat_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.ProductionCardCustomizeAdaptingsMesChat.CreateDate'
GO

ALTER TABLE [dbo].[ProductionCardCustomizeAdaptingsMesChat]
  ADD CONSTRAINT [FK_ProductionCardCustomizeAdaptingsMesChat_Employees_ID] FOREIGN KEY ([SenderEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[ProductionCardCustomizeAdaptingsMesChat]
  ADD CONSTRAINT [FK_ProductionCardCustomizeAdaptingsMesChat_ProductionCardCustomizeAdaptingsMes_ID] FOREIGN KEY ([ProductionCardCustomizeAdaptingsMesID]) REFERENCES [dbo].[ProductionCardCustomizeAdaptingsMes] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptingsMesChat', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата сообщения', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptingsMesChat', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Текст сообщения', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptingsMesChat', 'COLUMN', N'Body'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор автора сообщения', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptingsMesChat', 'COLUMN', N'SenderEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор претензии', 'SCHEMA', N'dbo', 'TABLE', N'ProductionCardCustomizeAdaptingsMesChat', 'COLUMN', N'ProductionCardCustomizeAdaptingsMesID'
GO