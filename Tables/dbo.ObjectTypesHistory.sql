CREATE TABLE [dbo].[ObjectTypesHistory] (
  [ID] [int] IDENTITY,
  [Name] [varchar](100) NULL,
  [XMLSchema] [xml] NULL,
  [ModifyDate] [datetime] NOT NULL,
  [ModifyEmployeeID] [int] NULL,
  [ObjectTypeID] [int] NULL,
  [OperationTypeID] [smallint] NULL,
  CONSTRAINT [PK_ObjectTypesHistory_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.ObjectTypesHistory.ModifyDate'
GO

ALTER TABLE [dbo].[ObjectTypesHistory]
  ADD CONSTRAINT [FK_ObjectTypesHistory_Employees_ID] FOREIGN KEY ([ModifyEmployeeID]) REFERENCES [dbo].[Employees] ([ID])
GO

ALTER TABLE [dbo].[ObjectTypesHistory]
  ADD CONSTRAINT [FK_ObjectTypesHistory_ObjectTypes_ID] FOREIGN KEY ([ObjectTypeID]) REFERENCES [dbo].[ObjectTypes] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesHistory', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя объекта', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesHistory', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Схема свойств ТМЦ', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesHistory', 'COLUMN', N'XMLSchema'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата и время изменения', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesHistory', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор пользователя, изменившего данные', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesHistory', 'COLUMN', N'ModifyEmployeeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Ссылка на идентификатор объекта', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesHistory', 'COLUMN', N'ObjectTypeID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции: 0-insert, 1-update, 2-delete', 'SCHEMA', N'dbo', 'TABLE', N'ObjectTypesHistory', 'COLUMN', N'OperationTypeID'
GO