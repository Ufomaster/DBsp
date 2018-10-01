CREATE TABLE [manufacture].[Jobs] (
  [ID] [int] IDENTITY,
  [Name] [varchar](255) NULL,
  [UserID] [int] NULL,
  [Date] [datetime] NULL,
  [ProductionCardCustomizeID] [int] NULL,
  [StatusID] [tinyint] NULL,
  [isDeleted] [bit] NULL DEFAULT (0),
  CONSTRAINT [PK_Jobs_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [manufacture].[Jobs]
  ADD CONSTRAINT [FK_Jobs_JobStatuses (mds)_ID] FOREIGN KEY ([StatusID]) REFERENCES [manufacture].[JobStatuses] ([ID])
GO

ALTER TABLE [manufacture].[Jobs]
  ADD CONSTRAINT [FK_Jobs_ProductionCardCustomize_ID] FOREIGN KEY ([ProductionCardCustomizeID]) REFERENCES [dbo].[ProductionCardCustomize] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Таблица для работ над заказными листами', 'SCHEMA', N'manufacture', 'TABLE', N'Jobs'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'manufacture', 'TABLE', N'Jobs', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование работы', 'SCHEMA', N'manufacture', 'TABLE', N'Jobs', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя создавшего работу', 'SCHEMA', N'manufacture', 'TABLE', N'Jobs', 'COLUMN', N'UserID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания работы', 'SCHEMA', N'manufacture', 'TABLE', N'Jobs', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор заказного листа', 'SCHEMA', N'manufacture', 'TABLE', N'Jobs', 'COLUMN', N'ProductionCardCustomizeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор статуса работы', 'SCHEMA', N'manufacture', 'TABLE', N'Jobs', 'COLUMN', N'StatusID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг, отображающий удалена ли запись', 'SCHEMA', N'manufacture', 'TABLE', N'Jobs', 'COLUMN', N'isDeleted'
GO