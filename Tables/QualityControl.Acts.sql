CREATE TABLE [QualityControl].[Acts] (
  [ID] [int] IDENTITY,
  [Number] [int] NULL,
  [CreateDate] [datetime] NULL,
  [TestCount] [int] NULL,
  [Description] [varchar](max) NULL,
  [ViolationPlaceID] [tinyint] NULL,
  [ActTemplatesID] [smallint] NOT NULL,
  [PVREmployeeID] [int] NULL,
  [AuthorEmployeeID] [int] NULL,
  [PartCount] [int] NULL,
  [ProtocolID] [int] NULL,
  [StatusID] [tinyint] NOT NULL,
  [CancelComment] [varchar](max) NULL,
  [ClassID] [tinyint] NULL,
  [AllSeeAll] [bit] NOT NULL,
  [Properties] [varchar](max) NULL,
  [MasterActID] [int] NULL,
  [ResultComment] [varchar](max) NULL,
  [FaultsReasonsClassID] [int] NULL,
  [CustomerID] [int] NULL,
  [MainReasonID] [int] NULL,
  [AmountMoney] [int] NULL,
  [FilePath] [varchar](255) NULL,
  CONSTRAINT [PK_Acts_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'QualityControl.Acts.AllSeeAll'
GO

ALTER TABLE [QualityControl].[Acts]
  ADD CONSTRAINT [FK_Acts_Acts_ID] FOREIGN KEY ([MasterActID]) REFERENCES [QualityControl].[Acts] ([ID])
GO

ALTER TABLE [QualityControl].[Acts]
  ADD CONSTRAINT [FK_Acts_ActsMainReason_ID] FOREIGN KEY ([MainReasonID]) REFERENCES [QualityControl].[ActsMainReason] ([ID])
GO

ALTER TABLE [QualityControl].[Acts]
  ADD CONSTRAINT [FK_Acts_ActStatuses (QualityControl)_ID] FOREIGN KEY ([StatusID]) REFERENCES [QualityControl].[ActStatuses] ([ID])
GO

ALTER TABLE [QualityControl].[Acts]
  ADD CONSTRAINT [FK_Acts_ActTemplates_ID] FOREIGN KEY ([ActTemplatesID]) REFERENCES [QualityControl].[ActTemplates] ([ID])
GO

ALTER TABLE [QualityControl].[Acts]
  ADD CONSTRAINT [FK_Acts_Customers_ID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID])
GO

ALTER TABLE [QualityControl].[Acts]
  ADD CONSTRAINT [FK_Acts_Employees_ID] FOREIGN KEY ([AuthorEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[Acts]
  ADD CONSTRAINT [FK_Acts_Employees_ID2] FOREIGN KEY ([PVREmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[Acts]
  ADD CONSTRAINT [FK_Acts_FaultsReasonsClass (QualityControl)_ID] FOREIGN KEY ([FaultsReasonsClassID]) REFERENCES [QualityControl].[FaultsReasonsClass] ([ID])
GO

ALTER TABLE [QualityControl].[Acts]
  ADD CONSTRAINT [FK_Acts_Protocols (QualityControl)_ID] FOREIGN KEY ([ProtocolID]) REFERENCES [QualityControl].[Protocols] ([ID])
GO

ALTER TABLE [QualityControl].[Acts]
  ADD CONSTRAINT [FK_Acts_ViolationPlaces (QualityControl)_ID] FOREIGN KEY ([ViolationPlaceID]) REFERENCES [QualityControl].[ViolationPlaces] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Акты несоответствия', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'Number'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Объем несоответствующей продукции', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'TestCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание неоответствующей продукции', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор места нарушения', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'ViolationPlaceID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор шаблона акта', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'ActTemplatesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор начальника управления качеством', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'PVREmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор автора акта. В случае оавтосоздания - это автор протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'AuthorEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Объем партии продукции', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'PartCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'ProtocolID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Причина отмены', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'CancelComment'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Класс несоответствия', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'ClassID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Все видят комментарии всех', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'AllSeeAll'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Свойства протокола.', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'Properties'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор агрегирующего акта', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'MasterActID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Общее решение', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'ResultComment'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Класс несоответствия', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'FaultsReasonsClassID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор поставщика', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор - основная причина НС', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'MainReasonID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сумма, грн', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'AmountMoney'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Путь к документу СУЯ', 'SCHEMA', N'QualityControl', 'TABLE', N'Acts', 'COLUMN', N'FilePath'
GO