CREATE TABLE [sync].[1CSpecDetail] (
  [ID] [int] IDENTITY,
  [Position1C] [tinyint] NULL,
  [NormKind] [tinyint] NULL,
  [TMCCode1C] [varchar](36) NULL,
  [1CSpecNodeID] [int] NULL,
  [Amount] [numeric](38, 10) NULL,
  [UnitCode1C] [varchar](36) NULL,
  [1CSpecID] [int] NOT NULL,
  [ProductionCardCustomizeMaterialsID] [int] NULL,
  CONSTRAINT [PK__1CSpecDe__3214EC2758EBCE17] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [sync].[1CSpecDetail]
  ADD CONSTRAINT [FK_1CSpecDetail_1CSpec (sync)_ID] FOREIGN KEY ([1CSpecID]) REFERENCES [sync].[1CSpec] ([ID])
GO

ALTER TABLE [sync].[1CSpecDetail]
  ADD CONSTRAINT [FK_1CSpecDetail_1CSpec (sync)_ID2] FOREIGN KEY ([1CSpecNodeID]) REFERENCES [sync].[1CSpec] ([ID])
GO

ALTER TABLE [sync].[1CSpecDetail]
  ADD CONSTRAINT [FK_1CSpecDetail_ProductionCardCustomizeMaterials_ID] FOREIGN KEY ([ProductionCardCustomizeMaterialsID]) REFERENCES [dbo].[ProductionCardCustomizeMaterials] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CSpecDetail', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер по порядку Вносится в Спеклере', 'SCHEMA', N'sync', 'TABLE', N'1CSpecDetail', 'COLUMN', N'Position1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вид Норматива. Вносится в Спеклере.
1 – Номенклатура;
2 – Узел.', 'SCHEMA', N'sync', 'TABLE', N'1CSpecDetail', 'COLUMN', N'NormKind'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор Номенклатуры Вносится в Спеклере', 'SCHEMA', N'sync', 'TABLE', N'1CSpecDetail', 'COLUMN', N'TMCCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор узловой спецификации. Вносится в Спеклере', 'SCHEMA', N'sync', 'TABLE', N'1CSpecDetail', 'COLUMN', N'1CSpecNodeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Количество Вносится в Спеклере', 'SCHEMA', N'sync', 'TABLE', N'1CSpecDetail', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'гуид ед. измерения. Вносится в Спеклере', 'SCHEMA', N'sync', 'TABLE', N'1CSpecDetail', 'COLUMN', N'UnitCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор шапки', 'SCHEMA', N'sync', 'TABLE', N'1CSpecDetail', 'COLUMN', N'1CSpecID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи детальной части сопроводительного листа', 'SCHEMA', N'sync', 'TABLE', N'1CSpecDetail', 'COLUMN', N'ProductionCardCustomizeMaterialsID'
GO