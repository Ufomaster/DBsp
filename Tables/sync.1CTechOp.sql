CREATE TABLE [sync].[1CTechOp] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NOT NULL,
  [ParentCode1C] [varchar](36) NULL,
  [Code1C] [varchar](36) NULL,
  [Name] [varchar](255) NULL,
  [UserCode] [varchar](15) NULL,
  [UnitCode1C] [varchar](36) NULL,
  [UnitName] [varchar](25) NULL,
  [IsDeleted] [bit] NULL,
  [IsFolder] [bit] NULL,
  CONSTRAINT [PK_1CTechOp_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.[1CTechOp].CreateDate'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [TR_1CTechOp_AFT_IU] ON [sync].[1CTechOp]

FOR INSERT, UPDATE
AS
BEGIN
--заметка. в таблицу данные только вставлюятся. то есть через время будут дубликаты с разной КриетДэйт
--Триггер не отслеживает очередность появления нод дерева, то есть сначала паренты потом чайлды. ПОэтому может произойти кака.
    IF EXISTS(SELECT * FROM manufacture.TechnologicalOperations a
              INNER JOIN INSERTED b ON a.Code1C = b.Code1C)
    --update table
        UPDATE a
        SET 
           a.CreateDate = b.CreateDate,           
           a.IsDeleted = b.IsDeleted,
           a.IsFolder = b.IsFolder,
           a.Name = b.Name,
           a.ParentID = c.ID,
           a.UnitID = u.ID,
           a.UserCode = b.UserCode
        FROM manufacture.TechnologicalOperations a
        INNER JOIN INSERTED b ON a.Code1C = b.Code1C
        LEFT JOIN manufacture.TechnologicalOperations c ON c.Code1C = b.ParentCode1C
        LEFT JOIN Units u ON u.Code1C = b.UnitCode1C    
    ELSE
    --insert into
        INSERT INTO  manufacture.TechnologicalOperations(Code1C, CreateDate,IsDeleted,IsFolder,Name,ParentID,UnitID,UserCode)
        SELECT b.Code1C, b.CreateDate, b.IsDeleted, b.IsFolder, b.Name, c.ID, u.ID, b.UserCode
        FROM INSERTED b
        LEFT JOIN manufacture.TechnologicalOperations c ON c.Code1C = b.ParentCode1C
        LEFT JOIN Units u ON u.Code1C = b.UnitCode1C
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CTechOp', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'дата загрузки из 1с', 'SCHEMA', N'sync', 'TABLE', N'1CTechOp', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с родительской папки', 'SCHEMA', N'sync', 'TABLE', N'1CTechOp', 'COLUMN', N'ParentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CTechOp', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'sync', 'TABLE', N'1CTechOp', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CTechOp', 'COLUMN', N'UserCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с единицы измерения', 'SCHEMA', N'sync', 'TABLE', N'1CTechOp', 'COLUMN', N'UnitCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование единицы измерения', 'SCHEMA', N'sync', 'TABLE', N'1CTechOp', 'COLUMN', N'UnitName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг удален в 1с', 'SCHEMA', N'sync', 'TABLE', N'1CTechOp', 'COLUMN', N'IsDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг папки в 1с', 'SCHEMA', N'sync', 'TABLE', N'1CTechOp', 'COLUMN', N'IsFolder'
GO