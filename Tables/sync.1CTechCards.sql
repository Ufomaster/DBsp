CREATE TABLE [sync].[1CTechCards] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NOT NULL,
  [ParentCode1C] [varchar](36) NULL,
  [Code1C] [varchar](36) NULL,
  [Name] [varchar](255) NULL,
  [UserCode] [varchar](15) NULL,
  [DepartmentCode1C] [varchar](36) NULL,
  [StateID] [tinyint] NULL,
  [AcceptDate] [datetime] NULL,
  [IsDeleted] [bit] NULL,
  [IsFolder] [bit] NULL,
  CONSTRAINT [PK_1CTechCards_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.[1CTechCards].CreateDate'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [TR_1CTechCards_AFT_IU] ON [sync].[1CTechCards]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS(SELECT * FROM manufacture.TechnologicalCards a
              INNER JOIN INSERTED b ON a.Code1C = b.Code1C)
    BEGIN
    --update table
        UPDATE a
        SET 
           a.CreateDate = b.CreateDate,           
           a.IsDeleted = b.IsDeleted,
           a.IsFolder = b.IsFolder,
           a.Name = b.Name,
           a.ParentID = c.ID,
           a.DepartmentID = dep.ID,
           a.UserCode = b.UserCode,
           a.StateID = b.StateID,
           a.AcceptDate = b.AcceptDate
        FROM manufacture.TechnologicalCards a
        INNER JOIN INSERTED b ON a.Code1C = b.Code1C
        LEFT JOIN manufacture.TechnologicalCards c ON c.Code1C = b.ParentCode1C   
        LEFT JOIN Departments dep ON dep.Code1C = b.DepartmentCode1C

        DELETE a
        FROM manufacture.TechnologicalCardsTOLinks a
        INNER JOIN manufacture.TechnologicalCards c ON c.ID = a.TechnologicalCardID    
        INNER JOIN INSERTED b ON b.Code1C = c.Code1C
    END
    ELSE
    --insert into
        INSERT INTO  manufacture.TechnologicalCards(Code1C, CreateDate, IsDeleted,IsFolder,Name, ParentID, DepartmentID, UserCode, StateID, AcceptDate)
        SELECT b.Code1C, b.CreateDate, b.IsDeleted, b.IsFolder, b.Name, c.ID, dep.ID, b.UserCode, b.StateID, b.AcceptDate
        FROM INSERTED b
        LEFT JOIN manufacture.TechnologicalCards c ON c.Code1C = b.ParentCode1C
        LEFT JOIN Departments dep ON dep.Code1C = b.DepartmentCode1C
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CTechCards', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'дата загрузки из 1с', 'SCHEMA', N'sync', 'TABLE', N'1CTechCards', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с родительской папки', 'SCHEMA', N'sync', 'TABLE', N'1CTechCards', 'COLUMN', N'ParentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CTechCards', 'COLUMN', N'Code1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Наименование', 'SCHEMA', N'sync', 'TABLE', N'1CTechCards', 'COLUMN', N'Name'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Видимый код 1с', 'SCHEMA', N'sync', 'TABLE', N'1CTechCards', 'COLUMN', N'UserCode'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'код 1с подразделения', 'SCHEMA', N'sync', 'TABLE', N'1CTechCards', 'COLUMN', N'DepartmentCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'состояние', 'SCHEMA', N'sync', 'TABLE', N'1CTechCards', 'COLUMN', N'StateID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'дата утверждения', 'SCHEMA', N'sync', 'TABLE', N'1CTechCards', 'COLUMN', N'AcceptDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг удален в 1с', 'SCHEMA', N'sync', 'TABLE', N'1CTechCards', 'COLUMN', N'IsDeleted'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг папки в 1с', 'SCHEMA', N'sync', 'TABLE', N'1CTechCards', 'COLUMN', N'IsFolder'
GO