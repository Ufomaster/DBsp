SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    		$Create date:   07.04.2016$*/
/*$Modify:     Oleynik Yuriy$    		$Modify date:   06.11.2017$*/
/*$Version:    1.00$   $Description: Предзаполнение*/
CREATE PROCEDURE [manufacture].[sp_ProductionTasks_FuncProduce_Prepare]
    @CurrentSectorID Int,
    @PCCID int,
    @StorageStructureID int,
    @OutProdClass int,
    @OutStatusID int,
    @ProductionTasksID int,
    @CurStatusID int,
    @TMCID1 int,
    @TMCID2 int,
    @Status1 int,
    @Status2 int
AS
BEGIN
    DELETE FROM #WPProduce
    CREATE TABLE #CurMat(TMCID int, Name varchar(255), Amount decimal(38,10), isMajorTMC bit, StatusName varchar(50),
       ProductionTasksStatusID int, IsTL bit, ProductionCardCustomizeID int)

    --собираем список материалов по СЛ и привязке по участкам + всякие доп поля.
    -- это список необходимых к списанию материалов.
    SELECT 
        mat.ID, 
        mat.TMCID, 
        CASE WHEN otaNormSkip.ID IS NULL THEN mat.Norma ELSE 1 END AS NormaAmount, 
        mat.ProductionCardCustomizeID, 
        t.Name, 
        u.Name AS UnitName,
        CASE WHEN ota.ID IS NULL THEN 0 ELSE 1 END AS SkipZlSplit,
        CASE WHEN otaNormSkip.ID IS NULL THEN mat.Norma/pcc.CardCountInvoice ELSE 1 END AS Norma,
        pcc.Number,
        CASE WHEN otaNormSkip.ID IS NULL THEN 0 ELSE 1 END AS isNormaOverrideWithValueOne
    INTO #PCMat
    FROM dbo.ProductionCardCustomizeMaterials mat      
    INNER JOIN (SELECT MIN(m.ID) as ID FROM dbo.ProductionCardCustomizeMaterials m --Exclude materials with two and more Norms
                WHERE m.ProductionCardCustomizeID = @PCCID
                GROUP BY m.ProductionCardCustomizeID, m.TmcID
                HAVING count(*) = 1) as mToUse on mToUse.ID = mat.ID
    INNER JOIN tmc t ON t.ID = mat.TmcID
    INNER JOIN dbo.ProductionCardCustomize pcc ON pcc.ID = @PCCID    
    INNER JOIN ObjectTypes ot ON ot.ID = t.ObjectTypeID
    LEFT JOIN ObjectTypesAttributes ota ON ota.ObjectTypeID = ot.ID AND ota.AttributeID = 24
    LEFT JOIN ObjectTypesAttributes otaNormSkip ON otaNormSkip.ObjectTypeID = ot.ID AND otaNormSkip.AttributeID = 25
    LEFT JOIN Units u ON u.ID = t.UnitID
    WHERE mat.ProductionCardCustomizeID = @PCCID AND mat.TmcID IN (SELECT ID FROM dbo.fn_TMCLinkedToSectors_Select(@CurrentSectorID, mat.TmcID, NULL))
                        

    IF @OutProdClass = 0 OR @OutProdClass = 4 OR @OutProdClass = 2
    BEGIN
        --фильтруем текущие данные из сменок.
        INSERT INTO #CurMat(TMCID, Name, Amount, isMajorTMC, StatusName, ProductionTasksStatusID, IsTL, ProductionCardCustomizeID)
        SELECT
            ps.TMCID,
            ps.Name,
            SUM(ps.Amount) as Amount,
            ps.isMajorTMC,
            pts.[Name] AS StatusName,
            ps.ProductionTasksStatusID,
            CASE WHEN p.ID IS NULL THEN 0 ELSE 1 END AS IsTL,
            ps.ProductionCardCustomizeID
        FROM manufacture.vw_ProductionTasksAgregation_Select ps
        LEFT JOIN TmcPCC p ON p.TmcID = ps.TMCID AND p.ProductionCardCustomizeID = @PCCID
        --данные по тмц на РМ так как связь по ps
        LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ps.ProductionTasksID
        LEFT JOIN manufacture.StorageStructureSectors sss ON sss.ID = pt.StorageStructureSectorID
        LEFT JOIN manufacture.ProductionTasksStatuses pts ON pts.ID = ps.ProductionTasksStatusID
        WHERE ps.ProductionTasksID = @ProductionTasksID 
              AND (ps.ProductionCardCustomizeID = @PCCID OR ps.ProductionCardCustomizeID IS NULL)
              AND( 
               (ps.isMajorTMC = 0 AND ps.ProductionTasksStatusID NOT IN (2, 3, 5, 6, @OutStatusID))
               OR 
               (ps.isMajorTMC = 1 AND ps.ProductionTasksStatusID = @CurStatusID AND @CurStatusID NOT IN (2, 3, 5, 6, @OutStatusID))
                  )             
        GROUP BY ps.TMCID, ps.Name, ps.isMajorTMC, pts.[Name], ps.ProductionTasksStatusID, CASE WHEN p.ID IS NULL THEN 0 ELSE 1 END, ps.ProductionCardCustomizeID
        HAVING SUM(ps.Amount) > 0     
    END
    ELSE
    IF @OutProdClass = 1
    BEGIN        
        INSERT INTO #CurMat(TMCID, Name, Amount, isMajorTMC, StatusName, ProductionTasksStatusID, IsTL, ProductionCardCustomizeID)
        SELECT
            ps.TMCID,
            ps.Name,
            SUM(ps.Amount) as Amount,
            ps.isMajorTMC,
            pts.[Name] AS StatusName,
            ps.ProductionTasksStatusID,
            CASE WHEN p.ID IS NULL THEN 0 ELSE 1 END AS IsTL,
            ps.ProductionCardCustomizeID
        FROM manufacture.vw_ProductionTasksAgregation_Select ps
        LEFT JOIN TmcPCC p ON p.TmcID = ps.TMCID AND p.ProductionCardCustomizeID = @PCCID
        --данные по тмц на РМ так как связь по ps
        LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ps.ProductionTasksID
        LEFT JOIN manufacture.StorageStructureSectors sss ON sss.ID = pt.StorageStructureSectorID
        LEFT JOIN manufacture.ProductionTasksStatuses pts ON pts.ID = ps.ProductionTasksStatusID
        WHERE ps.ProductionTasksStatusID NOT IN (2, 3, 5, 6, @OutStatusID)
            AND (ps.ProductionCardCustomizeID = @PCCID OR ps.ProductionCardCustomizeID IS NULL) 
            AND ps.ProductionTasksID = @ProductionTasksID
            AND ps.Amount > 0
            -- для выбора тиражных листов - проверяем значения  'TMCID1', 'TMCID2', 'Status1', 'Status2'
            AND (
                 (p.ID IS NULL) --не тиражные пропускаем просто
                  OR
                 (p.ID IS NOT NULL AND 
                   (
                    (ps.TMCID = @TMCID1 AND ps.ProductionTasksStatusID = CASE WHEN @Status1 = -1 THEN ps.ProductionTasksStatusID ELSE @Status1 END)
                     OR
                    (ps.TMCID = @TMCID2 AND ps.ProductionTasksStatusID = CASE WHEN @Status2 = -1 THEN ps.ProductionTasksStatusID ELSE @Status2 END)
                     OR
                    (@TMCID1 = -1 AND @TMCID2 = -1)
                    )
                 )
               )           
        GROUP BY ps.TMCID, ps.Name, ps.isMajorTMC, pts.[Name], ps.ProductionTasksStatusID, CASE WHEN p.ID IS NULL THEN 0 ELSE 1 END, ps.ProductionCardCustomizeID
        HAVING SUM(ps.Amount) > 0
    END
    IF @OutProdClass = 3
    BEGIN
        INSERT INTO #CurMat(TMCID, Name, Amount, isMajorTMC, StatusName, ProductionTasksStatusID, IsTL, ProductionCardCustomizeID)
        SELECT
            ps.TMCID,
            ps.Name,
            SUM(ps.Amount) as Amount,
            ps.isMajorTMC,
            pts.[Name] AS StatusName,
            ps.ProductionTasksStatusID,
            CASE WHEN p.ID IS NULL THEN 0 ELSE 1 END AS IsTL,
            ps.ProductionCardCustomizeID
        FROM manufacture.vw_ProductionTasksAgregation_Select ps
        LEFT JOIN TmcPCC p ON p.TmcID = ps.TMCID AND p.ProductionCardCustomizeID = @PCCID
        --данные по тмц на РМ так как связь по ps
        LEFT JOIN manufacture.ProductionTasks pt on pt.ID = ps.ProductionTasksID
        LEFT JOIN manufacture.StorageStructureSectors sss ON sss.ID = pt.StorageStructureSectorID
        LEFT JOIN manufacture.ProductionTasksStatuses pts ON pts.ID = ps.ProductionTasksStatusID
        WHERE ps.isMajorTMC = 0 AND ps.ProductionTasksStatusID NOT IN (2, 3, 5, 6, @OutStatusID)
            AND (ps.ProductionCardCustomizeID = @PCCID OR ps.ProductionCardCustomizeID IS NULL) 
            AND ps.ProductionTasksID = @ProductionTasksID
            AND ps.Amount > 0
        GROUP BY ps.TMCID, ps.Name, ps.isMajorTMC, pts.[Name], ps.ProductionTasksStatusID, CASE WHEN p.ID IS NULL THEN 0 ELSE 1 END, ps.ProductionCardCustomizeID
        HAVING SUM(ps.Amount) > 0
    END

    --финальная выборка
    INSERT INTO #WPProduce(TMCID, Name, Amount, AmountMax, isMajorTMC, StatusName, StatusID, 
        UnitName, Number, IsTL, PCCID, Norma, NormaAmount, SkipZlSplit, FailAmount, IsDeleted, isNormaOverrideWithValueOne)
    SELECT 
        ISNULL(mat.TMCID, ps.TMCID) AS TMCID,
        ISNULL(mat.[Name], ps.Name) AS Name,
        ISNULL(ps.Amount,0) AS Amount,
        ISNULL(ps.Amount,0) AS AmountMax,
        ISNULL(ps.isMajorTMC, 0) AS isMajorTMC,
        ISNULL(ps.StatusName, 'нет материала'),
        ISNULL(ps.ProductionTasksStatusID, 1) AS ProductionTasksStatusID,
        mat.UnitName,
        pcc.Number,
        CASE WHEN ps.IsTL IS NULL THEN 0 ELSE ps.IsTL END AS IsTL,
        ps.ProductionCardCustomizeID AS PCCID,
        mat.Norma,
        mat.NormaAmount,
        ISNULL(mat.SkipZlSplit, 0),
        0,
        0,
        mat.isNormaOverrideWithValueOne
    FROM #PCMat mat
    FULL JOIN #CurMat ps ON ps.TMCID = mat.TMCID
    LEFT JOIN dbo.ProductionCardCustomize pcc ON pcc.ID = @PCCID
    WHERE (ps.TMCID IS NOT NULL AND mat.ID IS NULL AND ps.isMajorTMC = 1) OR (ISNULL(ps.isMajorTMC,0) = 0 AND mat.TMCID IS NOT NULL)   
        
    IF @OutProdClass = 1
    BEGIN
        --для типа 1 нужно удвоить списываение тиражных или оставить в том же кол-ве. это зависит от самого кол-ва тиражных.
        UPDATE #WPProduce
        SET CntID = (SELECT COUNT(TMCID) FROM #WPProduce WHERE IsTL = 1)
        WHERE IsTL = 1
    END

    DROP TABLE #CurMat   
    DROP TABLE #PCMat
END
GO