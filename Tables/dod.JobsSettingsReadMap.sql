CREATE TABLE [dod].[JobsSettingsReadMap] (
  [ID] [int] IDENTITY,
  [JobsSettingsID] [int] NOT NULL,
  [Sector] [tinyint] NULL,
  [B0] [bit] NULL,
  [B1] [bit] NULL,
  [B2] [bit] NULL,
  [B3] [bit] NULL,
  [B4] [bit] NULL,
  [B5] [bit] NULL,
  [B6] [bit] NULL,
  [B7] [bit] NULL,
  [B8] [bit] NULL,
  [B9] [bit] NULL,
  [B10] [bit] NULL,
  [B11] [bit] NULL,
  [B12] [bit] NULL,
  [B13] [bit] NULL,
  [B14] [bit] NULL,
  [B15] [bit] NULL,
  CONSTRAINT [PK_JobsSettingsReadMap_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dod].[JobsSettingsReadMap]
  ADD CONSTRAINT [FK_JobsSettingsReadMap_JobsSettings_ID] FOREIGN KEY ([JobsSettingsID]) REFERENCES [dod].[JobsSettings] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор работы', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'JobsSettingsID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Номер сектора', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'Sector'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 0', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B0'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 1', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B1'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 2', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B2'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 3', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B3'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 4', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B4'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 5', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B5'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 6', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B6'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 7', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B7'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 8', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B8'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 9', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B9'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 10', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B10'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 11', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B11'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 12', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B12'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 13', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B13'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 14', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B14'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг-вычитывать ли блок 15', 'SCHEMA', N'dod', 'TABLE', N'JobsSettingsReadMap', 'COLUMN', N'B15'
GO