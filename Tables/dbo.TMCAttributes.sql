CREATE TABLE [dbo].[TMCAttributes] (
  [ID] [int] IDENTITY,
  [TMCID] [int] NULL,
  [AttributeID] [int] NULL,
  CONSTRAINT [PK_TMCAttributes_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

CREATE UNIQUE INDEX [UQ_TMCAttributes_TMCID_AttributeID]
  ON [dbo].[TMCAttributes] ([TMCID], [AttributeID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[TMCAttributes]
  ADD CONSTRAINT [FK_TMCAttributes_Attributes_ID] FOREIGN KEY ([AttributeID]) REFERENCES [dbo].[Attributes] ([ID])
GO

ALTER TABLE [dbo].[TMCAttributes]
  ADD CONSTRAINT [FK_TMCAttributes_Tmc_ID] FOREIGN KEY ([TMCID]) REFERENCES [dbo].[Tmc] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'TMCAttributes', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'TMCAttributes', 'COLUMN', N'TMCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентифкатор атрибута', 'SCHEMA', N'dbo', 'TABLE', N'TMCAttributes', 'COLUMN', N'AttributeID'
GO