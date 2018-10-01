CREATE TABLE [sync].[1CTechCardsTOLinks] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NOT NULL,
  [ТechСardCode1C] [varchar](36) NULL,
  [TechOpCode1C] [varchar](36) NULL,
  [Number] [tinyint] NULL,
  [IsMDS] [bit] NULL,
  CONSTRAINT [PK_1CTechCardsTOLinks_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.[1CTechCardsTOLinks].CreateDate'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [TR_1CTechCardsTOLinks_AFT_IU] ON [sync].[1CTechCardsTOLinks]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN
    IF NOT EXISTS(SELECT c.ID, o.ID, b.Number, b.IsMDS
                  FROM manufacture.TechnologicalCardsTOLinks b
                  INNER JOIN manufacture.TechnologicalCards c ON c.ID = b.TechnologicalCardID
                  INNER JOIN manufacture.TechnologicalOperations o ON o.ID = b.TechnologicalOperationID
                  INNER JOIN INSERTED a ON a.[ТechСardCode1C] = c.Code1C AND a.TechOpCode1C  = o.Code1C)                            
        INSERT INTO  manufacture.TechnologicalCardsTOLinks(TechnologicalCardID, TechnologicalOperationID, Number, IsMDS)
        SELECT c.ID, o.ID, b.Number, b.IsMDS
        FROM INSERTED b
        INNER JOIN manufacture.TechnologicalCards c ON c.Code1C = b.[ТechСardCode1C]
        INNER JOIN manufacture.TechnologicalOperations o ON o.Code1C = b.TechOpCode1C 
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Идентификатор записи', 'SCHEMA', N'sync', 'TABLE', N'1CTechCardsTOLinks', 'COLUMN', N'ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'дата выгрузки', 'SCHEMA', N'sync', 'TABLE', N'1CTechCardsTOLinks', 'COLUMN', N'CreateDate'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'код 1с ТК', 'SCHEMA', N'sync', 'TABLE', N'1CTechCardsTOLinks', 'COLUMN', N'ТechСardCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'код 1с ТО', 'SCHEMA', N'sync', 'TABLE', N'1CTechCardsTOLinks', 'COLUMN', N'TechOpCode1C'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'номер этапа', 'SCHEMA', N'sync', 'TABLE', N'1CTechCardsTOLinks', 'COLUMN', N'Number'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'флаг - работы в мдс', 'SCHEMA', N'sync', 'TABLE', N'1CTechCardsTOLinks', 'COLUMN', N'IsMDS'
GO