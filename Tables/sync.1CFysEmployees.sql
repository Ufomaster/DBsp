CREATE TABLE [sync].[1CFysEmployees] (
  [ID] [int] IDENTITY,
  [Date] [datetime] NOT NULL,
  [VisibleCode] [varchar](30) NULL,
  [Code1C] [varchar](36) NOT NULL,
  [Name] [varchar](100) NULL,
  [OperationType] [tinyint] NOT NULL,
  [ModifyName] [varchar](100) NULL,
  [ModifyDate] [datetime] NULL,
  [INN] [varchar](12) NULL,
  CONSTRAINT [PK_1CFysEmployees_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.[1CFysEmployees].Date'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [TR_1CFysEmployees_IOF_I] ON [sync].[1CFysEmployees]

INSTEAD OF INSERT
AS
BEGIN    
    IF EXISTS(SELECT a.ID FROM sync.[1CFysEmployees] a INNER JOIN INSERTED b ON a.Code1C = b.Code1C)
    BEGIN
        UPDATE a
        SET a.[Date] = GETDATE(),
            a.INN = b.INN,
            a.ModifyDate = b.ModifyDate,
            a.ModifyName = b.ModifyName,
            a.[Name] = b.[Name],
            a.OperationType = b.OperationType,
            a.VisibleCode = b.VisibleCode
        FROM sync.[1CFysEmployees] a
        INNER JOIN INSERTED b ON a.Code1C = b.Code1C
        
        UPDATE a
        SET a.INN = b.INN
        FROM dbo.Employees a
        INNER JOIN INSERTED b ON a.Code1C = b.Code1C       
    END
    ELSE
        INSERT INTO sync.[1CFysEmployees]([Date], Code1C, INN, ModifyDate, ModifyName, [Name], OperationType, VisibleCode)
        SELECT GETDATE(), Code1C, INN, ModifyDate, ModifyName, [Name], OperationType, VisibleCode
        FROM INSERTED
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CFysEmployees', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата', 'SCHEMA', N'sync', 'TABLE', N'1CFysEmployees', 'COLUMN', N'Date'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый пользователю код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CFysEmployees', 'COLUMN', N'VisibleCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Уникальный идентификатор 1с', 'SCHEMA', N'sync', 'TABLE', N'1CFysEmployees', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Полное наименование', 'SCHEMA', N'sync', 'TABLE', N'1CFysEmployees', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Тип операции (0-Insert, 1-Update, 2-Delete)', 'SCHEMA', N'sync', 'TABLE', N'1CFysEmployees', 'COLUMN', N'OperationType'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Кто модицифировал запись', 'SCHEMA', N'sync', 'TABLE', N'1CFysEmployees', 'COLUMN', N'ModifyName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Дата изменений записи в 1с', 'SCHEMA', N'sync', 'TABLE', N'1CFysEmployees', 'COLUMN', N'ModifyDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'ИНН', 'SCHEMA', N'sync', 'TABLE', N'1CFysEmployees', 'COLUMN', N'INN'
GO