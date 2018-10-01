CREATE TABLE [dbo].[Versions] (
  [ID] [int] NOT NULL,
  [Major] [int] NULL,
  [Minor] [int] NULL,
  [DBMajor] [int] NULL,
  [DBMinor] [int] NULL,
  [Name] [varchar](100) NULL,
  [UpdateTime] [datetime] NOT NULL,
  CONSTRAINT [PK_Versions_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TR_Versions_Update] ON [Versions]

FOR UPDATE
AS
--$Create:     Yuriy Oleynik$    $Create date:   19.03.2012$
--$Modify:     Yuriy Oleynik$    $Modify date:   19.03.2012$
--$Version:    1.00$   $Decription: триггер, устанавливающий дату апдейта автоматом, если только версия была изменена$
BEGIN
    IF EXISTS(SELECT * FROM inserted WHERE INSERTED.UpdateTime < GETDATE())
        UPDATE a
        SET a.UpdateTime = DATEADD(n, 10, GetDate())
        FROM Versions a
        INNER JOIN INSERTED b ON b.ID = a.ID        
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'dbo', 'TABLE', N'Versions', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Major версия ЕХЕ', 'SCHEMA', N'dbo', 'TABLE', N'Versions', 'COLUMN', N'Major'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Minor версия ЕХЕ', 'SCHEMA', N'dbo', 'TABLE', N'Versions', 'COLUMN', N'Minor'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Major версия базы', 'SCHEMA', N'dbo', 'TABLE', N'Versions', 'COLUMN', N'DBMajor'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Minor версия базы', 'SCHEMA', N'dbo', 'TABLE', N'Versions', 'COLUMN', N'DBMinor'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование элемента контроля версий', 'SCHEMA', N'dbo', 'TABLE', N'Versions', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Приблизительное время окончания обновления', 'SCHEMA', N'dbo', 'TABLE', N'Versions', 'COLUMN', N'UpdateTime'
GO