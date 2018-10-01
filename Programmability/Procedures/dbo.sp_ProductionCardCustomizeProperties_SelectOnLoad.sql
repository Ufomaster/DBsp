SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   29.12.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   04.03.2015$
--$Version:    1.00$   $Decription: Выбор технологии производства заказного листа$
CREATE PROCEDURE [dbo].[sp_ProductionCardCustomizeProperties_SelectOnLoad]
    @ParentID Int,
    @Date Datetime,
    @ProductionCardCustomizeID Int = NULL,
    @Type Int = 0
AS
BEGIN
    DECLARE @HiveID Int, @DefaultSourceTypeID Int, @DefaultSourceTypeName Varchar(30)
    SELECT TOP 1 @HiveID = a.ID 
    FROM ProductionCardPropertiesHistory a
    WHERE a.StartDate <= @Date AND a.RootProductionCardPropertiesID = @Type
    ORDER BY a.StartDate DESC
    
    SELECT 
        @DefaultSourceTypeID = st.ID, 
        @DefaultSourceTypeName = st.[Name] 
    FROM vw_ProductionPropertiesSourceType st WHERE st.IsDefault = 1

    SELECT
        CASE WHEN pccp.PropHistoryValueID IS NULL THEN pccp.HandMadeValueOwnerID ELSE phValParent.ID END AS [ID],    
        CASE WHEN pccp.PropHistoryValueID IS NULL THEN phValParentVal.ID ELSE phValParentVal.ParentID END AS [ParentID],
        CASE WHEN pccp.PropHistoryValueID IS NULL THEN otVal.[Name] ELSE otValParent.[Name] END AS [Dictionary],       
        CASE WHEN pccp.PropHistoryValueID IS NULL THEN pccp.HandMadeValue ELSE otVal.[Name] END AS [Value],
        pccp.PropHistoryValueID,
        phValParent.ParentID AS [ParentForEmpty],       
        CASE WHEN pccp.PropHistoryValueID IS NULL THEN otVal.NodeImageIndex ELSE otValParent.NodeImageIndex END AS NodeImageIndex,
        pccp.HandMadeValueOwnerID,
        pccp.SourceType,
        ppst.[Name] AS SourceTypeName,
        CASE WHEN pccp.PropHistoryValueID IS NULL THEN phHandParent.NodeLevel ELSE phValParent.NodeLevel END AS NodeLevel,
        CASE WHEN pccp.PropHistoryValueID IS NULL THEN phHandParent.NodeOrder ELSE phValParent.NodeOrder END AS NodeOrder,
        CASE WHEN pccp.PropHistoryValueID IS NULL THEN phHandParent.ObjectTypeID ELSE phValParent.ObjectTypeID END AS ObjectTypeID,
        0 AS IsFirst
    INTO #tmp
    FROM ProductionCardPropertiesHistoryDetails phVal                                                                                       --ValueID                         --DictionarytID
    INNER JOIN ProductionCardCustomizeProperties pccp ON pccp.ProductionCardCustomizeID = @ProductionCardCustomizeID AND (phVal.ID = pccp.PropHistoryValueID OR phVal.ID = pccp.HandMadeValueOwnerID)
    LEFT JOIN ObjectTypes otVal ON otVal.ID = phVal.ObjectTypeID
    --к нашим валлю из ЗЛ нужно взять родительский справочник. Для ручного значения, это будет не Справочник, а Валью.
    LEFT JOIN ProductionCardPropertiesHistoryDetails phValParent ON phValParent.ID = phVal.ParentID
    LEFT JOIN ObjectTypes otValParent ON otValParent.ID = phValParent.ObjectTypeID
    --для связи родительского справочника с верхним уровнем - берём РОдителя у валью, с которым связан phValParent. Для ручных значений, это будет не валью а справочник.
    LEFT JOIN ProductionCardPropertiesHistoryDetails phValParentVal ON phValParentVal.ID = phValParent.ParentID  
    LEFT JOIN vw_ProductionPropertiesSourceType ppst ON ppst.ID = pccp.SourceType
    -- ХендМейды уже имеют HandMadeValueOwnerID в кач. справочника, валью есть в pccp, поэтому берем только справочник
    LEFT JOIN ProductionCardPropertiesHistoryDetails phHandParent ON (phHandParent.ID = pccp.HandMadeValueOwnerID AND pccp.HandMadeValue IS NOT NULL)
    
    UNION --for insert 1-st node init
    
    SELECT
        p.ID,
        NULL,
        ot.[Name],
        NULL,
        NULL,
        NULL,
        ot.NodeImageIndex,           
        NULL,
        NULL,
        NULL,
        p.NodeLevel,
        p.NodeOrder,
        p.ObjectTypeID,
        1
    FROM ProductionCardPropertiesHistoryDetails p
    LEFT JOIN ObjectTypes ot ON ot.ID = p.ObjectTypeID       
    WHERE p.ProductionCardPropertiesHistoryID = @HiveID AND p.ParentID IS NULL AND NOT EXISTS(SELECT ID FROM ProductionCardCustomizeProperties 
                                                                                              WHERE ProductionCardCustomizeID = @ProductionCardCustomizeID)
    
    INSERT INTO #tmp
    SELECT
       phEmpty.ID, 
       phValParentVal.ParentID,
       otEmpty.[Name],
       NULL,
       NULL,
       NULL,       
       otEmpty.NodeImageIndex,
       NULL,
       NULL,
       NULL,
       phEmpty.NodeLevel,
       phEmpty.NodeOrder,
       phEmpty.ObjectTypeID,
       0
    FROM ProductionCardPropertiesHistoryDetails phEmpty    
     --нужно присоединить к phValP - ещё раз ph - чтобы вытянуть значения которые не сохранены в рсср, но есть в дереве .
    INNER JOIN (SELECT ParentForEmpty FROM #tmp WHERE PropHistoryValueID IS NOT NULL GROUP BY ParentForEmpty 
                UNION 
                SELECT PropHistoryValueID FROM #tmp WHERE PropHistoryValueID IS NOT NULL GROUP BY PropHistoryValueID) AS a 
        ON phEmpty.ParentID = a.ParentForEmpty
    INNER JOIN ObjectTypes otEmpty ON otEmpty.ID = phEmpty.ObjectTypeID
    --для связи родительского справочника с верхним уровнем - берём РОдителя у валью, с которым связан phValParent.
    LEFT JOIN ProductionCardPropertiesHistoryDetails phValParentVal ON phValParentVal.ID = phEmpty.ParentID     
    WHERE phEmpty.ProductionCardPropertiesHistoryID = @HiveID AND phEmpty.ID NOT IN (SELECT ID FROM #tmp /*WHERE ParentID = phEmpty.ParentID*/)
    ;
           
    WITH ResultTable (ID, ParentID, NodeOrder, Sort)
    AS
    (
        SELECT
            ID, ParentID, NodeOrder,
            CONVERT(Varchar(MAX), RIGHT(REPLICATE('0',10 - LEN(CAST(NodeOrder AS Varchar(10)))) + cast(NodeOrder AS Varchar(10)), 10)) AS [Sort]
        FROM #tmp e
        WHERE ParentID IS NULL        
        
        UNION ALL

        SELECT
            e.ID, e.ParentID, e.NodeOrder,
            CONVERT (Varchar(MAX), RTRIM(Sort) + '|' + RIGHT(REPLICATE('0',10 - LEN(cast(e.NodeOrder AS Varchar(10)))) + cast(e.NodeOrder AS Varchar(10)), 10)) AS [Sort]
        FROM #tmp AS e
        INNER JOIN ResultTable AS d
            ON e.ParentID = d.ID
    )
      
    SELECT 
        a.*,
        @DefaultSourceTypeID AS DefaultSourceTypeID,
        @DefaultSourceTypeName AS DefaultSourceTypeName
    FROM ResultTable as rt
    INNER JOIN #tmp a ON a.ID = rt.ID
    ORDER BY rt.Sort
    
    
    DROP TABLE #tmp
END
GO