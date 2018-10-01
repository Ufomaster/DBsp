SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


/*$Create:     Zapadinskiy Anatoliy$    $Create date:   27.01.2017$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   27.01.2017$*/
/*$Version:    1.00$   $Decription: Заполнение средневзвешенных норм по участку.$*/
CREATE PROCEDURE [manufacture].[sp_StorageStructureSectorsNorms_Fill]
AS
BEGIN
	SET NOCOUNT ON
    
    UPDATE manufacture.StorageStructureSectorsNorms
    SET DateExpire = GetDate()
    WHERE SectorID in (SELECT o.StorageStructureSectorID as SectorID
                      FROM ProductionCardCustomizeTechOp t
                          LEFT JOIN TechOperations o on o.ID = t.TechOperationID
                          LEFT JOIN ProductionCardCustomize pcc on pcc.ID = t.ProductionCardCustomizeID
                      WHERE ISNull(t.Amount,0) <> 0 
                            AND IsNull(pcc.CardCountInvoice,0) <> 0
                      GROUP BY o.StorageStructureSectorID
                      HAVING CASE WHEN Sum(ISNull(pcc.CardCountInvoice,0)) <> 0 THEN Sum(t.Amount) / Sum(ISNull(pcc.CardCountInvoice,0)) ELSE 0 END > 0)
          AND DateExpire is null          
          
    INSERT INTO manufacture.StorageStructureSectorsNorms (Amount, SectorID)
    SELECT CASE WHEN Sum(ISNull(pcc.CardCountInvoice,0)) <> 0 THEN Sum(t.Amount) / Sum(ISNull(pcc.CardCountInvoice,0)) ELSE 0 END 
           , o.StorageStructureSectorID as SectorID
    FROM ProductionCardCustomizeTechOp t
        LEFT JOIN TechOperations o on o.ID = t.TechOperationID
        LEFT JOIN ProductionCardCustomize pcc on pcc.ID = t.ProductionCardCustomizeID
    WHERE ISNull(t.Amount,0) <> 0 
          AND IsNull(pcc.CardCountInvoice,0) <> 0
    GROUP BY o.StorageStructureSectorID
END
GO