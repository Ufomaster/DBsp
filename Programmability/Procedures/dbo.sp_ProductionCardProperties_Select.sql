SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Oleynik Yuriy$    $Create date:   07.06.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   24.07.2017$*/
/*$Version:    1.00$   $Description: Выборка узла дерева по корневому уровню (по виду ЗЛ)$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardProperties_Select]
    @ParentID Int
AS
BEGIN
    SET NOCOUNT ON;

    WITH ResultTable (ID, ParentID, NodeLevel, NodeOrder, Sort)
    AS
    (
        /* Anchor member definition*/
        SELECT
            ID, ParentID, NodeLevel, NodeOrder
            --,CONVERT(Varchar(300), RIGHT(REPLICATE('0',2 - LEN(CAST(e.NodeOrder AS Varchar(2)))) + CAST(e.NodeOrder AS Varchar(2)), 2))
            ,CONVERT(Varchar(300), RIGHT('00' + CAST(e.NodeOrder AS Varchar(2)), 2))            
        FROM ProductionCardProperties e
        WHERE ID = @ParentID
        UNION ALL
        /* Recursive member definition*/
        SELECT
            e.ID, e.ParentID, e.NodeLevel, e.NodeOrder
            --, CONVERT (Varchar(300), d.Sort /*+ '|'*/ + RIGHT(REPLICATE('0',2 - LEN(CAST(e.NodeOrder AS Varchar(2)))) + CAST(e.NodeOrder AS Varchar(2)), 2))
            ,CONVERT(Varchar(300), d.Sort + RIGHT('00' + CAST(e.NodeOrder AS Varchar(2)), 2))
        FROM ProductionCardProperties AS e
        INNER JOIN ResultTable AS d ON e.ParentID = d.ID
    )

    SELECT 
        a.ID,
        a.ParentID,
        CAST(a.NodeOrder AS Varchar) + '.' + 
        CAST(a.NodeLevel AS Varchar) + ' ' + ot.[Name] +
        CASE 
           WHEN Materials.ObjectTypeID IS NOT NULL THEN ' [М]'
           WHEN MaterialsDet.ObjectTypeID IS NOT NULL THEN ' [м]'
        ELSE ''
        END
        +
        CASE
            WHEN ota_HandInput.ObjectTypeID IS NOT NULL THEN '[*]'
        ELSE ''    
        END
        +             
        CASE
           WHEN ota_SpecUse.ObjectTypeID IS NOT NULL THEN '[C]'
        ELSE ''
        END
        +
        CASE
           WHEN ot.ParameterName IS NOT NULL THEN '[P]'
        ELSE ''
        END
         AS [Name],        
        ot.NodeImageIndex,
        CAST(ISNULL(p.NodeExpanded, 0) AS Int) AS NodeExpanded,
        a.NodeLevel--,
        --a.NodeOrder
        --,       a.Sort
    FROM ResultTable a
    INNER JOIN ProductionCardProperties p ON p.ID = a.ID
    INNER JOIN ObjectTypes ot ON p.ObjectTypeID = ot.ID
    LEFT JOIN ObjectTypesAttributes ota_HandInput ON ota_HandInput.ObjectTypeID = ot.ID AND ota_HandInput.AttributeID = 7 --Hand value input
    LEFT JOIN ObjectTypesAttributes ota_SpecUse ON ota_SpecUse.ObjectTypeID = ot.ID AND ota_SpecUse.AttributeID = 12 /*исп в спецификации*/     
    LEFT JOIN (SELECT otm.ObjectTypeID 
               FROM ObjectTypesMaterials otm 
               WHERE otm.EndDate IS NULL AND otm.BeginDate IS NOT NULL
               GROUP BY otm.ObjectTypeID) Materials ON Materials.ObjectTypeID = ot.ID
    LEFT JOIN (SELECT crd.ObjectTypeID 
               FROM dbo.ConsumptionRatesDetails crd
               INNER JOIN dbo.ConsumptionRates cr ON cr.ID = crd.ConsumptionRateID
               INNER JOIN ObjectTypesMaterials otm1 ON otm1.ID = cr.ObjectTypesMaterialID
               WHERE otm1.EndDate IS NULL AND otm1.BeginDate IS NOT NULL
               GROUP BY crd.ObjectTypeID) MaterialsDet ON MaterialsDet.ObjectTypeID = ot.ID
    ORDER BY a.Sort
END
GO