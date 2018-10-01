CREATE TABLE [manufacture].[PTmcFailRegister] (
  [ID] [int] IDENTITY,
  [TmcID] [int] NOT NULL,
  [EmployeeGroupFactID] [int] NOT NULL,
  [Amount] [decimal](38, 10) NOT NULL,
  [CreateDate] [datetime] NOT NULL,
  [FailTypeID] [int] NOT NULL,
  CONSTRAINT [PK_PTmcFailRegister_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'manufacture.PTmcFailRegister.CreateDate'
GO

ALTER TABLE [manufacture].[PTmcFailRegister]
  ADD CONSTRAINT [FK_PTmcFailRegister_EmployeeGroupsFact_ID] FOREIGN KEY ([EmployeeGroupFactID]) REFERENCES [shifts].[EmployeeGroupsFact] ([ID])
GO

ALTER TABLE [manufacture].[PTmcFailRegister]
  ADD CONSTRAINT [FK_PTmcFailRegister_FailTypes_ID] FOREIGN KEY ([FailTypeID]) REFERENCES [manufacture].[FailTypes] ([ID])
GO

ALTER TABLE [manufacture].[PTmcFailRegister]
  ADD CONSTRAINT [FK_PTmcFailRegister_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcFailRegister', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор бракуемого ТМЦ', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcFailRegister', 'COLUMN', N'TmcID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи данных о работе в цс', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcFailRegister', 'COLUMN', N'EmployeeGroupFactID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кол-во', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcFailRegister', 'COLUMN', N'Amount'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата регистрации', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcFailRegister', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип брака', 'SCHEMA', N'manufacture', 'TABLE', N'PTmcFailRegister', 'COLUMN', N'FailTypeID'
GO