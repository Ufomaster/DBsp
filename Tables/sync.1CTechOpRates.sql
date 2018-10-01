CREATE TABLE [sync].[1CTechOpRates] (
  [ID] [int] IDENTITY,
  [CreateDate] [datetime] NOT NULL,
  [TOCode1C] [varchar](36) NULL,
  [Amount] [decimal](18, 4) NULL,
  [AmountUpr] [decimal](18, 4) NULL,
  [DateFrom] [datetime] NULL,
  [IsDeleted] [bit] NULL,
  [s] [bit] NULL,
  CONSTRAINT [PK_1CTechOpRates_ID] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

EXEC sp_bindefault @defname = N'dbo.DF_CurrentDate', @objname = N'sync.[1CTechOpRates].CreateDate'
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [TR_1CTechOpRates_AFT_IU] ON [sync].[1CTechOpRates]

FOR INSERT, UPDATE
AS
BEGIN        
    SET NOCOUNT ON
    DECLARE @ToCode1C varchar(36), @TechnologicalOperationID int
    DECLARE #cur CURSOR STATIC LOCAL FOR SELECT TOCode1C FROM Inserted GROUP BY TOCode1C
    OPEN #Cur
    FETCH NEXT FROM #Cur INTO @ToCode1C
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @TechnologicalOperationID = a.ID
        FROM manufacture.TechnologicalOperations a
        WHERE a.Code1C = @ToCode1C
        
        IF EXISTS(SELECT * FROM manufacture.TechnologicalOperationsRates p
                  INNER JOIN manufacture.TechnologicalOperations a ON a.ID = p.TechnologicalOperationID 
                  INNER JOIN INSERTED b ON a.Code1C = b.TOCode1C AND b.DateFrom = p.DateFrom
                  WHERE b.TOCode1C = @ToCode1C)
        BEGIN
        --update table
            UPDATE p
            SET 
               p.Amount = b.Amount,           
               p.AmountUpr = b.AmountUpr,
               p.CreateDate = b.CreateDate,
               p.IsDeleted = b.IsDeleted
            FROM manufacture.TechnologicalOperationsRates p
--            INNER JOIN manufacture.TechnologicalOperations a ON a.ID = p.TechnologicalOperationID 
            INNER JOIN INSERTED b ON /*a.Code1C = b.TOCode1C AND */b.DateFrom = p.DateFrom
            WHERE b.TOCode1C = @ToCode1C AND p.TechnologicalOperationID = @TechnologicalOperationID                                    
        END
        ELSE
        --insert into
            INSERT INTO manufacture.TechnologicalOperationsRates(Amount, AmountUpr, CreateDate, DateFrom, IsDeleted, TechnologicalOperationID)
            SELECT b.Amount, b.AmountUpr, b.CreateDate, b.DateFrom, b.IsDeleted, @TechnologicalOperationID
            FROM INSERTED b
            WHERE b.TOCode1C = @ToCode1C AND b.IsDeleted = 0
            
        --апдейтим дату финиша предыдущей записи тарифа.            
        UPDATE p1
        SET 
           p1.DateTo = b.DateFrom
        FROM manufacture.TechnologicalOperationsRates p1
        INNER JOIN(SELECT ID, ROW_NUMBER() OVER (ORDER BY DateFrom) AS Num
                   FROM manufacture.TechnologicalOperationsRates
                   WHERE TechnologicalOperationID = @TechnologicalOperationID AND IsDeleted = 0) AS p11 ON p11.ID = p1.ID
        INNER JOIN (SELECT *, ROW_NUMBER() OVER (ORDER BY DateFrom) -1 AS Num 
                    FROM manufacture.TechnologicalOperationsRates 
                    WHERE TechnologicalOperationID = @TechnologicalOperationID AND IsDeleted = 0) b ON b.Num = p11.Num
        WHERE p1.TechnologicalOperationID = @TechnologicalOperationID AND p1.IsDeleted = 0
            
        FETCH NEXT FROM #cur INTO @ToCode1C
    END
    CLOSE #cur
    DEALLOCATE #Cur  
END
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'сис', 'SCHEMA', N'sync', 'TABLE', N'1CTechOpRates', 'COLUMN', N's'
GO