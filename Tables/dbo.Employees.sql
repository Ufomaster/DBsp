CREATE TABLE [dbo].[Employees] (
  [ID] [int] IDENTITY,
  [EMail] [varchar](255) NULL,
  [DepartmentPositionID] [int] NULL,
  [Comments] [varchar](max) NULL,
  [IsDismissed] [bit] NOT NULL DEFAULT (0),
  [Cellular] [varchar](30) NULL,
  [FullName] [varchar](100) NULL,
  [ContractType] [varchar](50) NULL,
  [Code1C] [varchar](36) NULL,
  [UserCode1C] [varchar](10) NULL,
  [IsHidden] [bit] NULL,
  [INN] [varchar](30) NULL,
  CONSTRAINT [PK_Employees_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [IDX_Employees_DepartmentPositionID]
  ON [dbo].[Employees] ([DepartmentPositionID])
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[Employees]
  ADD CONSTRAINT [FK_Employees_DepartmentPositions_ID] FOREIGN KEY ([DepartmentPositionID]) REFERENCES [dbo].[DepartmentPositions] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Employees', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'EMail', 'SCHEMA', N'dbo', 'TABLE', N'Employees', 'COLUMN', N'EMail'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Занимаемая должность, вакансия', 'SCHEMA', N'dbo', 'TABLE', N'Employees', 'COLUMN', N'DepartmentPositionID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Заметки', 'SCHEMA', N'dbo', 'TABLE', N'Employees', 'COLUMN', N'Comments'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Пометка об увольнении', 'SCHEMA', N'dbo', 'TABLE', N'Employees', 'COLUMN', N'IsDismissed'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Мобильный телефон', 'SCHEMA', N'dbo', 'TABLE', N'Employees', 'COLUMN', N'Cellular'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ФИО', 'SCHEMA', N'dbo', 'TABLE', N'Employees', 'COLUMN', N'FullName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Вид Договора', 'SCHEMA', N'dbo', 'TABLE', N'Employees', 'COLUMN', N'ContractType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', 'Code1C', 'SCHEMA', N'dbo', 'TABLE', N'Employees', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый пользователю код 1С, он же табельный номер', 'SCHEMA', N'dbo', 'TABLE', N'Employees', 'COLUMN', N'UserCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Флаг скрытая ли запись', 'SCHEMA', N'dbo', 'TABLE', N'Employees', 'COLUMN', N'IsHidden'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ИНН', 'SCHEMA', N'dbo', 'TABLE', N'Employees', 'COLUMN', N'INN'
GO