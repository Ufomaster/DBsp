CREATE TABLE [manufacture].[JobStageNonPersTMC] (
  [ID] [int] IDENTITY,
  [TMCID] [int] NOT NULL,
  [JobStageID] [int] NOT NULL,
  [Koef] [decimal](38, 10) NOT NULL,
  [AddAmount] [decimal](38, 10) NOT NULL,
  CONSTRAINT [PK_JobStageNonPersTMC_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_False', @objname = N'manufacture.JobStageNonPersTMC.AddAmount'
GO

ALTER TABLE [manufacture].[JobStageNonPersTMC]
  ADD CONSTRAINT [FK_JobStageNonPersTMC_JobStages_ID] FOREIGN KEY ([JobStageID]) REFERENCES [manufacture].[JobStages] ([ID])
GO

ALTER TABLE [manufacture].[JobStageNonPersTMC]
  ADD CONSTRAINT [FK_JobStageNonPersTMC_Tmc_ID] FOREIGN KEY ([TMCID]) REFERENCES [dbo].[Tmc] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageNonPersTMC', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор ТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageNonPersTMC', 'COLUMN', N'TMCID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор этапа работы', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageNonPersTMC', 'COLUMN', N'JobStageID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Коэффициент на карту', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageNonPersTMC', 'COLUMN', N'Koef'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дополнительнок кол-во на брак', 'SCHEMA', N'manufacture', 'TABLE', N'JobStageNonPersTMC', 'COLUMN', N'AddAmount'
GO