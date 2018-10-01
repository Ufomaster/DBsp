CREATE TABLE [dbo].[TmcCustomers] (
  [ID] [int] IDENTITY,
  [CustomerID] [int] NOT NULL,
  [Comments] [varchar](max) NULL,
  [Date] [datetime] NOT NULL DEFAULT (getdate()),
  [TmcID] [int] NOT NULL,
  CONSTRAINT [PK_TmcCustomers_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TmcCustomers]
  ADD CONSTRAINT [FK_TmcCustomers_Customers_ID] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([ID])
GO

ALTER TABLE [dbo].[TmcCustomers]
  ADD CONSTRAINT [FK_TmcCustomers_Tmc_ID] FOREIGN KEY ([TmcID]) REFERENCES [dbo].[Tmc] ([ID]) ON DELETE CASCADE
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Список поставщиков', 'SCHEMA', N'dbo', 'TABLE', N'TmcCustomers'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'TmcCustomers', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор поставщика', 'SCHEMA', N'dbo', 'TABLE', N'TmcCustomers', 'COLUMN', N'CustomerID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Комментарии', 'SCHEMA', N'dbo', 'TABLE', N'TmcCustomers', 'COLUMN', N'Comments'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата создания записи', 'SCHEMA', N'dbo', 'TABLE', N'TmcCustomers', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор номенклатурной единицы', 'SCHEMA', N'dbo', 'TABLE', N'TmcCustomers', 'COLUMN', N'TmcID'
GO