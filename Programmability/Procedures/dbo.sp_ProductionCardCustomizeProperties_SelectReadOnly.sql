SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   07.03.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   26.11.2012$*/
/*$Version:    1.00$   $Decription: Выбор технологии производства заказного листа ReadOnly InfoOnly режим$*/
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeProperties_SelectReadOnly]
    @ProductionCardCustomizeID Int = NULL,
    @SourceType int = NULL
AS
BEGIN
    SET NOCOUNT ON
    
    SELECT
       ISNULL(ph.ID, phParent.ID) AS ID,
       ISNULL(phValP.ParentID, phParent.ParentID) AS ParentID,
       ISNULL(otValP.NodeImageIndex, otParent.NodeImageIndex) AS NodeImageIndex,
       LEFT('                                          ', (
           CASE WHEN pccp.HandMadeValue IS NULL THEN phValP.NodeLevel ELSE phParent.NodeLevel END 
           -2)*2) + 
           CASE WHEN pccp.HandMadeValue IS NULL THEN otValP.[Name] ELSE otParent.[Name] END AS Parent,
       CASE WHEN pccp.HandMadeValue IS NOT NULL THEN pccp.HandMadeValue ELSE otVal.[Name] END AS [Name],
       ISNULL(phValP.NodeLevel, phParent.NodeLevel) AS NodeLevel,
       ISNULL(phValP.NodeOrder, phParent.NodeOrder) AS NodeOrder,
       pccp.ProductionCardCustomizeID,
       pccp.PropHistoryValueID,
       ISNULL(otValP.ID, otParent.ID) AS ObjectTypeID,
       pccp.SourceType
    INTO #tmp
    FROM ProductionCardCustomizeProperties pccp
        -- список выбранных пользователем значений справочников ph-otVal значение, phValP-otValP справочник
        LEFT JOIN ProductionCardPropertiesHistoryDetails ph ON ph.ID = pccp.PropHistoryValueID    
        LEFT JOIN ObjectTypes otVal ON otVal.ID = ph.ObjectTypeID                  
        LEFT JOIN ProductionCardPropertiesHistoryDetails phValP ON phValP.ID = ph.ParentID
        LEFT JOIN ObjectTypes otValP ON otValP.ID = phValP.ObjectTypeID        
        -- ХендМейды уже имеют HandMadeValueOwnerID, валью есть в pccp, поэтому берем только справочник phParent-otParent
        LEFT JOIN ProductionCardPropertiesHistoryDetails phParent ON (phParent.ID = pccp.HandMadeValueOwnerID AND pccp.HandMadeValue IS NOT NULL)
        LEFT JOIN ObjectTypes otParent ON otParent.ID = phParent.ObjectTypeID   
    WHERE pccp.ProductionCardCustomizeID = @ProductionCardCustomizeID;

    WITH ResultTable (ID, ParentID, NodeImageIndex, Parent, [Name], NodeLevel, NodeOrder, Sort, ObjectTypeID, SourceType)
    AS
    (
    /* Anchor member definition*/
        SELECT
            ID, ParentID, NodeImageIndex, Parent, [Name], NodeLevel, NodeOrder,
            CONVERT(Varchar(MAX), RIGHT(REPLICATE('0',10 - LEN(CAST(NodeOrder AS Varchar(10)))) + cast(NodeOrder AS Varchar(10)), 10)) AS [Sort],
            e.ObjectTypeID,
            e.SourceType
        FROM #tmp e
        WHERE ParentID IS NULL        
        
        UNION ALL
    /* Recursive member definition*/

        SELECT
            e.ID, e.ParentID, e.NodeImageIndex, e.Parent, e.[Name], e.NodeLevel, e.NodeOrder,
            CONVERT (Varchar(MAX), RTRIM(Sort) + '|' + RIGHT(REPLICATE('0',10 - LEN(cast(e.NodeOrder AS Varchar(10)))) + cast(e.NodeOrder AS Varchar(10)), 10)) AS [Sort],
            e.ObjectTypeID,
            e.SourceType
        FROM #tmp AS e
        INNER JOIN ResultTable AS d
            ON e.ParentID = d.ID
    )

    SELECT rt.*,
    	   ppst.[Name] as SourceTypeName
    FROM ResultTable as rt
    	 LEFT JOIN vw_ProductionPropertiesSourceType ppst ON ppst.ID = rt.SourceType
    WHERE (rt.SourceType = @SourceType)
          OR @SourceType is null
    ORDER BY Sort
    
    DROP TABLE #tmp
END
GO