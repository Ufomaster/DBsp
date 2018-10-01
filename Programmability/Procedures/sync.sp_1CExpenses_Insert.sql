SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuiriy$    		$Create date:   21.11.2016$*/
/*$Modify:     Poliatykin Oleksii$  	$Modify date:   05.03.2018$*/
/*$Version:    1.00$   $Description: создание материалов в требование накладную$*/
CREATE PROCEDURE [sync].[sp_1CExpenses_Insert]
    @ManufactureID int,
    @Date datetime,
    @EmployeeID int = NULL
AS
BEGIN
    CREATE TABLE #Res (TMCID int, ProductionCardCustomizeID int, Amount decimal(15,3))
    CREATE TABLE #ActiveRes (TMCCode1С varchar(36), ProductionCardCustomizeID int, Amount decimal(15,3), TMCID int)
    IF EXISTS(SELECT *
	          FROM (SELECT count(*) as cnt FROM sync.[1CExpenses] a WHERE a.ManufactureID = @ManufactureID AND dbo.fn_DateCropTime(a.Date) = @Date AND a.Status <> 4) a
	          WHERE a.Cnt > 10)
    BEGIN
        SELECT NULL
        RETURN
    END
    ELSE
    BEGIN
        DECLARE @ExpensesID int, @StorageCode1C varchar(36), @EmployeeFysCode1C varchar(36), @DepartmentCode1C varchar(36), @PCCID int          
        DECLARE @t TABLE(ID int)

        SELECT @EmployeeFysCode1C = fe.Code1C 
        FROM vw_Employees e
        INNER JOIN sync.[1CFysEmployees] fe ON fe.Code1C = e.Code1C        
        WHERE ISNULL(e.IsDismissed, 0) = 0 AND e.ID = @EmployeeID

        SELECT sss.WarehouseCode1C, pt.ID, docDet.ProductionCardCustomizeID AS PCCID,
             CASE WHEN ota.AttributeID IS NOT NULL THEN 'a3e6531d-c749-11df-8255-001fc6cb17ac' 
             ELSE 'dec639db-e2f9-11e6-96da-0050569e8704' 
             END AS DepartmentCode1C
        INTO #PreparedData
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
        WHERE DATEADD(dd, 0, DATEDIFF(dd, 0, s.PlanStartDate)) = DATEADD(dd, 0, DATEDIFF(dd, 0, @Date))
             AND st.ManufactureStructureID = @ManufactureID      
        GROUP BY sss.WarehouseCode1C, pt.ID, docDet.ProductionCardCustomizeID, ota.AttributeID 

        DECLARE Cur CURSOR STATIC LOCAL FOR SELECT WarehouseCode1C, DepartmentCode1C
                                            FROM #PreparedData
                                            GROUP BY WarehouseCode1C, DepartmentCode1C
        OPEN Cur
        FETCH NEXT FROM Cur INTO @StorageCode1C, @DepartmentCode1C
        WHILE @@FETCH_STATUS = 0 
        BEGIN
            DELETE FROM #Res
            -- 1.  выборка текущих данных по сменкам.
            INSERT INTO #Res (TMCID, ProductionCardCustomizeID, Amount)
            SELECT ptdd.TMCID, ptdd.ProductionCardCustomizeID, SUM(CASE WHEN ptd.ProductionTasksOperTypeID = 8 THEN -ptdd.Amount ELSE ptdd.Amount END) as Amount
            FROM manufacture.ProductionTasksDocDetails ptdd 
            LEFT JOIN manufacture.ProductionTasksDocs ptd on ptd.ID = ptdd.ProductionTasksDocsID 
            LEFT JOIN manufacture.ProductionTasks pt ON pt.ID = ptd.ProductionTasksID 
            LEFT JOIN (SELECT TmcID FROM TmcPcc tp GROUP BY TmcID) tp on tp.TmcID = ptdd.TMCID
            INNER JOIN (SELECT ID, ISNULL(PCCID, 0) AS PCCID
                        FROM #PreparedData 
                        WHERE WarehouseCode1C = @StorageCode1C AND DepartmentCode1C = @DepartmentCode1C
                        GROUP BY ID, ISNULL(PCCID, 0)) a on a.ID = pt.ID AND a.PCCID = ISNULL(ptdd.ProductionCardCustomizeID, 0)
            WHERE ((ptd.ProductionTasksOperTypeID IN (2,5,6) AND ptdd.StatusID IN (2,3)) OR 
                       (ptd.ProductionTasksOperTypeID IN (8) AND ptdd.StatusID IN (1)))
                AND ptdd.isMajorTMC = 0
                AND tp.TmcID IS NULL
            GROUP BY ptdd.ProductionCardCustomizeID, ptdd.TMCID
            HAVING SUM(ptdd.Amount) <> 0

            DELETE FROM #ActiveRes
            -- 2. выборка выгруженных данных по сменкам на дату.
            INSERT INTO #ActiveRes (TMCCode1С, ProductionCardCustomizeID, Amount, TMCID)
            SELECT ed.TMCCode1С, ed.PCCID, SUM(ed.Qty) AS Amount, t.ID
            FROM sync.[1CExpensesDetails] ed
            INNER JOIN TMC t ON t.Code1C = ed.[TMCCode1С]
            INNER JOIN sync.[1CExpenses] ex ON ex.ID = ed.[1CExpensesID] AND ex.Date = DATEADD(hh, 23, DATEADD(mi, 59, DATEADD(ss, 00, @Date)))
                AND ex.Status <> 4
                AND ex.ManufactureID = @ManufactureID
                AND ex.StorageCode1C = @StorageCode1C
                AND ex.DepartmentCode1C = @DepartmentCode1C                                
            GROUP BY ed.PCCID, ed.[TMCCode1С], t.ID

            -- 3. Если не существует ничего не создаем документ          
            IF EXISTS(SELECT a.TMCID
                      FROM #Res a
                      FULL JOIN #ActiveRes z ON z.TmcID = a.TmcID
                      GROUP BY a.TMCID
                      HAVING SUM(ISNULL(a.Amount,0) - ISNULL(z.Amount,0)) <> 0)
            BEGIN
                INSERT INTO [sync].[1CExpenses](DocDate, ManufactureID, Date, Status, StorageCode1C, EmployeeFysCode1C, DepartmentCode1C) 
                OUTPUT INSERTED.ID INTO @t       
                SELECT GetDate(), @ManufactureID, DATEADD(hh, 23, DATEADD(mi, 59, DATEADD(ss, 00, @Date))), 0, @StorageCode1C, @EmployeeFysCode1C, @DepartmentCode1C

                SELECT @ExpensesID = ID FROM @t

                INSERT INTO sync.[1CExpensesDetails]([1CExpensesID], [TMCCode1С], Qty, PCCNumber, PCCID, OrderSelector, Skip, SkipSpecificationCheck)
                SELECT @ExpensesID, t.Code1C, ISNULL(a.Amount,0) - ISNULL(oldExp.Amount, 0), pcc.Number, pcc.ID, 
                    CASE WHEN otaOrder.ID IS NULL THEN 0 ELSE 1 END,
                    CASE
                        WHEN otaFILTER.ID IS NULL THEN NULL
                        WHEN LTRIM(RTRIM(ISNULL(t.ProdCardNumber, ''))) = '' AND otaFILTER.ID IS NOT NULL THEN 1
                    ELSE NULL END,
                    CASE WHEN otaFILTERTrafaret.ID IS NULL THEN 0 ELSE 1 END
                FROM #Res a
                INNER JOIN Tmc t on t.ID = a.TmcID
                INNER JOIN ObjectTypes ot ON ot.ID = t.ObjectTypeID
                LEFT JOIN ObjectTypesAttributes otaOrder ON otaOrder.ObjectTypeID = ot.ID AND otaOrder.AttributeID = 22
                LEFT JOIN ObjectTypesAttributes otaFILTER ON otaFILTER.ObjectTypeID = ot.ID AND otaFILTER.AttributeID = 21
                LEFT JOIN ObjectTypesAttributes otaFILTERTrafaret ON otaFILTERTrafaret.ObjectTypeID = ot.ID AND otaFILTERTrafaret.AttributeID = 23                
                LEFT JOIN ProductionCardCustomize pcc on pcc.ID = a.ProductionCardCustomizeID
                LEFT JOIN #ActiveRes oldExp ON oldExp.ProductionCardCustomizeID = pcc.ID AND oldExp.TMCID = a.TmcID
                WHERE (ISNULL(a.Amount,0) - ISNULL(oldExp.Amount, 0)) > 0
            END

            FETCH NEXT FROM Cur INTO @StorageCode1C, @DepartmentCode1C
        END
        CLOSE Cur
        DEALLOCATE Cur
    END
    DROP TABLE #ActiveRes
    DROP TABLE #Res
    DROP TABLE #PreparedData
    SELECT @ExpensesID
END
GO