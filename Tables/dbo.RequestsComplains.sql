CREATE TABLE [dbo].[RequestsComplains] (
  [ID] [int] IDENTITY,
  [Description] [varchar](1000) NOT NULL,
  [RequestID] [int] NOT NULL,
  [Date] [datetime] NOT NULL,
  CONSTRAINT [PK_RequestsComplains_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'dbo.RequestsComplains.Date'
GO

ALTER TABLE [dbo].[RequestsComplains]
  ADD CONSTRAINT [FK_RequestsComplains_Requests_ID] FOREIGN KEY ([RequestID]) REFERENCES [dbo].[Requests] ([ID])
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'RequestsComplains', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Описание жалобы', 'SCHEMA', N'dbo', 'TABLE', N'RequestsComplains', 'COLUMN', N'Description'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Заявка по которой идет жалоба', 'SCHEMA', N'dbo', 'TABLE', N'RequestsComplains', 'COLUMN', N'RequestID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата жалобы', 'SCHEMA', N'dbo', 'TABLE', N'RequestsComplains', 'COLUMN', N'Date'
GO