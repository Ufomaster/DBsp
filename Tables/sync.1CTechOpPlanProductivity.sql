CREATE TABLE [sync].[1CTechOpPlanProductivity] (
  [ID] [int] IDENTITY,
  [TOCode1C] [varchar](36) NULL,
  [Amount] [decimal](18, 4) NULL,
  [DateFrom] [datetime] NULL,
  [IsDeleted] [bit] NULL,
  CONSTRAINT [PK__1CTechOp__3214EC274AE33543] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE TRIGGER [TR_1CTechOpPlanProductivity_AFT_IU] ON [sync].[1CTechOpPlanProductivity]
WITH EXECUTE AS CALLER
FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @ToCode1C varchar(36)
    DECLARE #cur CURSOR STATIC LOCAL FOR SELECT TOCode1C FROM Inserted GROUP BY TOCode1C
    OPEN #Cur
    FETCH NEXT FROM #Cur INTO @ToCode1C
    WHILE @@FETCH_STATUS = 0
    BEGIN    
        IF EXISTS(SELECT * FROM manufacture.TechnologicalOperationsPlanProductivity p
                  INNER JOIN manufacture.TechnologicalOperations a ON a.ID = p.TechnologicalOperationID 
                  INNER JOIN INSERTED b ON a.Code1C = b.TOCode1C AND b.DateFrom = p.DateFrom
                  WHERE b.TOCode1C = @ToCode1C)
        --update table
            UPDATE p
            SET 
               p.Amount = b.Amount,           
               p.IsDeleted = b.IsDeleted
            FROM manufacture.TechnologicalOperationsPlanProductivity p
            INNER JOIN manufacture.TechnologicalOperations a ON a.ID = p.TechnologicalOperationID 
            INNER JOIN INSERTED b ON a.Code1C = b.TOCode1C AND b.DateFrom = p.DateFrom
            WHERE b.TOCode1C = @ToCode1C
        ELSE
        --insert into
            INSERT INTO  manufacture.TechnologicalOperationsPlanProductivity(Amount, DateFrom, IsDeleted, TechnologicalOperationID)
            SELECT b.Amount, b.DateFrom, b.IsDeleted, c.ID
            FROM INSERTED b
            INNER JOIN manufacture.TechnologicalOperations c ON c.Code1C = b.TOCode1C
            WHERE b.TOCode1C = @ToCode1C
        FETCH NEXT FROM #cur into @ToCode1C
    END
    CLOSE #cur
    DEALLOCATE #Cur    
END
GO