CREATE TABLE [QualityControl].[ActTemplates] (
  [ID] [smallint] IDENTITY,
  [CreateDate] [datetime] NULL,
  [Name] [varchar](255) NULL,
  [Version] [varchar](50) NULL,
  [Description] [varchar](255) NULL,
  [ModifyEmployeeID] [int] NULL,
  [ModifyDate] [datetime] NULL,
  [ArrayOfEmployeeID] [varchar](255) NULL,
  [NotifyEventID] [int] NULL,
  CONSTRAINT [PK_ActTemplates_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

ALTER TABLE [QualityControl].[ActTemplates]
  ADD CONSTRAINT [FK_ActTemplates_Employees_ID] FOREIGN KEY ([ModifyEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [QualityControl].[ActTemplates]
  ADD CONSTRAINT [FK_ActTemplates_NotifyEvents_ID] FOREIGN KEY ([NotifyEventID]) REFERENCES [dbo].[NotifyEvents] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplates', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplates', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplates', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Версия', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplates', 'COLUMN', N'Version'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание шаблона', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplates', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сотрудника изменившего запись', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplates', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата последних изменений', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplates', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Список идентифкаторов сотрудников, которые будут получать сообщение при создании Акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplates', 'COLUMN', N'ArrayOfEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор сообщения при создании акта', 'SCHEMA', N'QualityControl', 'TABLE', N'ActTemplates', 'COLUMN', N'NotifyEventID'
GO