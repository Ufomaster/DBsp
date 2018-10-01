SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuiriy$    		$Create date:   10.11.2015$*/
/*$Modify:     Oleynik Yuiriy$    	$Modify date:   02.02.2018$*/
/*$Version:    1.00$   $Description: требование накладная$*/
CREATE PROCEDURE [sync].[sp_1CExpensesDetails_Select]
    @ExpensesID int
AS
BEGIN
    SET NOCOUNT ON    
    --Необходимо удалить из интерфейсов эти поля: @ManufactureID, @Date их нет смысла передавать
    DECLARE @StorageCode1C varchar(36), @DepartmentCode1C varchar(36), @DateT datetime, @ManufactureTID tinyint       
    IF object_id('tempdb..#ProdTasks') IS NOT NULL DROP TABLE #ProdTasks
    
    SELECT @StorageCode1C = e.StorageCode1C, @DepartmentCode1C = e.DepartmentCode1C, @ManufactureTID = e.ManufactureID, @DateT = e.[Date]
    FROM sync.[1CExpenses] e
    WHERE e.ID = @ExpensesID
    
/*    SELECT pt.ID
    INTO #ProdTasks
    FROM manufacture.ProductionTasks pt
         INNER JOIN shifts.Shifts s on s.ID = pt.ShiftID
         LEFT JOIN shifts.ShiftsTypes st on st.ID = s.ShiftTypeID
         LEFT JOIN manufacture.StorageStructureSectors sss on sss.ID = pt.StorageStructureSectorID
    WHERE DATEADD(dd, 0, DATEDIFF(dd, 0, s.PlanStartDate)) = DATEADD(dd, 0, DATEDIFF(dd, 0, @DateT))
         AND st.ManufactureStructureID = @ManufactureTID
         AND IsNull(sss.WarehouseCode1C,0) = IsNull(@StorageCode1C,0)
         AND IsNull(sss.DepartmentCode1C,0) = IsNull(@DepartmentCode1C,0)*/

    SELECT pt.ID, docDet.ProductionCardCustomizeID AS PCCID
    INTO #ProdTasks
    FROM manufacture.ProductionTasks pt
    LEFT JOIN manufacture.ProductionTasksDocs doc ON doc.ProductionTasksID = pt.ID
    LEFT JOIN manufacture.ProductionTasksDocDetails docDet ON docDet.ProductionTasksDocsID = doc.ID
    LEFT JOIN ProductionCardCustomize pc ON pc.ID = docDet.ProductionCardCustomizeID
    LEFT JOIN Tmc t ON t.ID = pc.TmcID
    LEFT JOIN ObjectTypes ot ON ot.ID = t.ObjectTypeID
    LEFT JOIN ObjectTypesAttributes ota ON ota.AttributeID = 27 AND ota.ObjectTypeID = t.ObjectTypeID
    INNER JOIN shifts.Shifts s on s.ID = pt.ShiftID
    LEFT JOIN shifts.ShiftsTypes st on st.ID = s.ShiftTypeID
    LEFT JOIN manufacture.StorageStructureSectors sss on sss.ID = pt.StorageStructureSectorID
    WHERE DATEADD(dd, 0, DATEDIFF(dd, 0, s.PlanStartDate)) = DATEADD(dd, 0, DATEDIFF(dd, 0, @DateT))
         AND st.ManufactureStructureID = @ManufactureTID
         AND IsNull(sss.WarehouseCode1C,0) = IsNull(@StorageCode1C,0)    
         AND CASE WHEN ota.AttributeID IS NOT NULL THEN 'a3e6531d-c749-11df-8255-001fc6cb17ac' 
             ELSE 'dec639db-e2f9-11e6-96da-0050569e8704' 
             END = @DepartmentCode1C
    GROUP BY pt.ID, docDet.ProductionCardCustomizeID
    
    SELECT 
        a.ID,
        a.[1CExpensesID],
        a.Norma,
        a.PCCCount,
        a.PCCID,
        a.PCCNumber,
        a.Qty,
        a.[TMCCode1С],
        ISNULL(t.Name, Actual.Name) AS Name,
        ISNULL(pc.[Name], Actual.ZLName) AS ZLName,
        pc.CardCountInvoice,
        ROW_NUMBER() OVER (PARTITION BY a.[1CExpensesID], a.PCCNumber ORDER BY a.PCCNumber, a.ID) AS RowNum,
        CAST(Actual.Amount AS decimal(15,3)) AS CurrentAmount,
        ISNULL(a.Skip, 0) AS Skip,
        a.SkipSpecificationCheck
    FROM [sync].[1CExpensesDetails] a 
         INNER JOIN TMC t ON t.Code1C = a.TMCCode1С
         LEFT JOIN ProductionCardCustomize pc ON pc.ID = a.PCCID 
         LEFT JOIN (
             SELECT t.Code1C, a.Amount, t.Name, pcc.[Name] AS ZLName, a.ProductionCardCustomizeID
             FROM 
                 (SELECT ptdd.TMCID, ptdd.ProductionCardCustomizeID, SUM(CASE WHEN ptd.ProductionTasksOperTypeID = 8 THEN -ptdd.Amount ELSE ptdd.Amount END) as Amount
                  FROM manufacture.ProductionTasksDocDetails ptdd 
                       LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
                       LEFT JOIN manufacture.ProductionTasks pt ON pt.ID = ptd.ProductionTasksID 
                       LEFT JOIN (SELECT TmcID FROM TmcPcc tp GROUP BY TmcID) tp on tp.TmcID = ptdd.TMCID
                       --GET all ProductionTasks for selected date and manufacture
                       INNER JOIN #ProdTasks a on a.ID = pt.ID AND a.PCCID = ptdd.ProductionCardCustomizeID
                  WHERE ((ptd.ProductionTasksOperTypeID IN (2,5,6) AND ptdd.StatusID IN (2,3)) OR 
                        (ptd.ProductionTasksOperTypeID IN (8) AND ptdd.StatusID IN (1)))
                       AND ptdd.isMajorTMC = 0
                       AND tp.TmcID is null	
                  GROUP BY ptdd.ProductionCardCustomizeID, ptdd.TMCID) a
             LEFT JOIN tmc t ON t.ID = a.TmcID
             LEFT JOIN ProductionCardCustomize pcc on pcc.ID = a.ProductionCardCustomizeID) AS Actual ON Actual.Code1C = a.TMCCode1С AND ISNULL(Actual.ProductionCardCustomizeID,0) = ISNULL(a.PCCID,0)
    WHERE a.[1CExpensesID] = @ExpensesID
    
    UNION ALL
    
    SELECT t.ID, NULL, NULL, NULL, NULL, pcc.Number, NULL, t.Code1C, t.Name, pcc.[Name], NULL, NULL, a.Amount, 2, NULL
    FROM 
        (SELECT ptdd.TMCID, ptdd.ProductionCardCustomizeID, SUM(CASE WHEN ptd.ProductionTasksOperTypeID = 8 THEN -ptdd.Amount ELSE ptdd.Amount END) AS Amount
         FROM manufacture.ProductionTasksDocDetails ptdd 
              LEFT JOIN manufacture.ProductionTasksDocs ptd ON ptd.ID = ptdd.ProductionTasksDocsID 
              LEFT JOIN manufacture.ProductionTasks pt ON pt.ID = ptd.ProductionTasksID 
              LEFT JOIN (SELECT TmcID FROM TmcPcc tp GROUP BY TmcID) tp ON tp.TmcID = ptdd.TMCID
              --GET all ProductionTasks for selected date and manufacture
              INNER JOIN #ProdTasks a ON a.ID = pt.ID AND a.PCCID = ptdd.ProductionCardCustomizeID
         WHERE ((ptd.ProductionTasksOperTypeID IN (2,5,6) AND ptdd.StatusID IN (2,3)) OR 
                        (ptd.ProductionTasksOperTypeID IN (8) AND ptdd.StatusID IN (1)))
              AND ptdd.isMajorTMC = 0
              AND tp.TmcID IS NULL	
         GROUP BY ptdd.ProductionCardCustomizeID, ptdd.TMCID) a
        LEFT JOIN tmc t ON t.ID = a.TmcID
        LEFT JOIN ProductionCardCustomize pcc on pcc.ID = a.ProductionCardCustomizeID
        LEFT JOIN [sync].[1CExpensesDetails] ed ON ISNULL(ed.PCCID,0) = ISNULL(a.ProductionCardCustomizeID,0) AND t.Code1C = ed.[TMCCode1С] AND ed.[1CExpensesID] = @ExpensesID       
    WHERE ed.ID IS NULL
            
    ORDER BY a.PCCNumber, a.ID
END
GO