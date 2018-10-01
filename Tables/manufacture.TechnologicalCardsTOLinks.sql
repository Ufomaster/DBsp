CREATE TABLE [manufacture].[TechnologicalCardsTOLinks] (
  [ID] [int] IDENTITY,
  [TechnologicalCardID] [int] NULL,
  [TechnologicalOperationID] [int] NULL,
  [Number] [tinyint] NULL,
  [IsMDS] [bit] NULL,
  CONSTRAINT [PK_TechnologicalCardsTOLinks_ID] PRIMARY KEY CLUSTERED ([ID]),
  CONSTRAINT [UQ_TechnologicalCardsTOLinks_TechnologicalCardID_TechnologicalOperationID] UNIQUE ([TechnologicalCardID], [TechnologicalOperationID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCardsTOLinks', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТК', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCardsTOLinks', 'COLUMN', N'TechnologicalCardID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТО', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCardsTOLinks', 'COLUMN', N'TechnologicalOperationID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер этапа', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCardsTOLinks', 'COLUMN', N'Number'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг работ в МДС', 'SCHEMA', N'manufacture', 'TABLE', N'TechnologicalCardsTOLinks', 'COLUMN', N'IsMDS'
GO