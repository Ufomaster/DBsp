CREATE TABLE [QualityControl].[ActsHistory] (
  [ID] [int] IDENTITY,
  [ActsID] [int] NOT NULL,
  [OperationType] [int] NOT NULL,
  [ModifyDate] [datetime] NOT NULL,
  [ModifyEmployeeID] [int] NOT NULL,
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
  [FaultsReasonsClassID] [int] NULL,
  [MainReasonID] [int] NULL,
  [AmountMoney] [int] NULL,
  [FilePath] [varchar](255) NULL,
  [MasterActID] [int] NULL,
  [ResultComment] [varchar](max) NULL,
  [CustomerID] [int] NULL,
  CONSTRAINT [PK_ActsHistory_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'QualityControl.ActsHistory.ModifyDate'
GO

ALTER TABLE [QualityControl].[ActsHistory]
  ADD CONSTRAINT [FK_ActsHistory_Acts (QualityControl)_ID] FOREIGN KEY ([ActsID]) REFERENCES [QualityControl].[Acts] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Акты несоответствия История', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'ActsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции 0-insert, 1-update, 2-delete', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата изменений', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника который изменил запись', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'Number'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Объем несоответствующей продукции', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'TestCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание неоответствующей продукции', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор места нарушения', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'ViolationPlaceID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор шаблона акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'ActTemplatesID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор начальника управления качеством', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'PVREmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор автора акта. В случае оавтосоздания - это автор протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'AuthorEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Объем партии продукции', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'PartCount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор протокола', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'ProtocolID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Причина отмены', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'CancelComment'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Класс несоответствия', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'ClassID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Все видят комментарии всех', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'AllSeeAll'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Свойства протокола.', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'Properties'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Класс несоответствия', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'FaultsReasonsClassID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор - основная причина НС', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'MainReasonID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Сумма, грн', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'AmountMoney'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Путь к документу СУЯ', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'FilePath'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор агрегирующего акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'MasterActID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Общее решение', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'ResultComment'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор поставщика', 'SCHEMA', N'QualityControl', 'TABLE', N'ActsHistory', 'COLUMN', N'CustomerID'
GO