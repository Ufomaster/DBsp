CREATE TABLE [shifts].[ShiftsTypesNames] (
  [ID] [int] NOT NULL,
  [Name] [varchar](250) NULL,
  [Ico] [tinyint] NULL,
  CONSTRAINT [PK__ShiftsTy__3214EC273E5D62CD] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Имя для описания схемы', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsTypesNames', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Иконки для наименований', 'SCHEMA', N'shifts', 'TABLE', N'ShiftsTypesNames', 'COLUMN', N'Ico'
GO