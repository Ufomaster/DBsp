CREATE TABLE [manufacture].[PTmcOperationTmcs] (
  [ID] [int] IDENTITY,
  [OperationID] [int] NOT NULL,
  [TmcID] [int] NOT NULL,
  CONSTRAINT [PK_PTmcOperationTmcs_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_PTmcOperationTmcs_TmcID]
  ON [manufacture].[PTmcOperationTmcs] ([TmcID])
  INCLUDE ([OperationID])
  ON [PRIMARY]
GO

ALTER TABLE [manufacture].[PTmcOperationTmcs]
  ADD CONSTRAINT [FK_PTmcOperationTmcs_PTmcOperations (manufacture)_ID] FOREIGN KEY ([OperationID]) REFERENCES [manufacture].[PTmcOperations] ([ID]) ON DELETE CASCADE
GO

ALTER TABLE [manufacture].[PTmcOperationTmcs]
  ADD CONSTRAINT [FK_PTmcOperationTmcs_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperationTmcs', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на операцию', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperationTmcs', 'COLUMN', N'OperationID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на ТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcOperationTmcs', 'COLUMN', N'TmcID'
GO