SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   26.07.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   07.08.2012$*/
/*$Version:    1.00$   $Decription: Выбор дерева схемы хранилища$*/
create PROCEDURE [unknown].[sp_AStorageScheme_Select]
AS
BEGIN
    SET NOCOUNT ON

    SELECT
        ss.ID,
        ss.ParentID,
        ss.NodeOrder
    INTO #tmp
    FROM AStorageScheme ss;

    WITH ResultTable (ID, ParentID, NodeOrder, Sort)
    AS
    (
    /* Anchor member definition*/
        SELECT
            ID, ParentID, NodeOrder,
            CONVERT(Varchar(MAX), RIGHT(REPLICATE('0',10 - LEN(CAST(NodeOrder AS Varchar(10)))) + cast(NodeOrder AS Varchar(10)), 10)) AS [Sort]
        FROM #tmp e
        WHERE ParentID IS NULL

        UNION ALL
    /* Recursive member definition*/

        SELECT
            e.ID, e.ParentID, e.NodeOrder,
            CONVERT (Varchar(MAX), RTRIM(Sort) + '|' + RIGHT(REPLICATE('0',10 - LEN(cast(e.NodeOrder AS Varchar(10)))) + cast(e.NodeOrder AS Varchar(10)), 10)) AS [Sort]
        FROM #tmp AS e
        INNER JOIN ResultTable AS d
            ON e.ParentID = d.ID
    )

    SELECT
        ss.*,
        sit.[Name] + ' ' + si.[Name] as [Name],
        sit.LastIndex,
        sit.[Prefix],
        sit.CharCount,
        sit.Suffix,         
        sit.DefaultImageIndex,
        si.AStorageItemsTypeID,
        ExistingStruct.cnt AS ExistingStructCount,
        IsNull(sim.MaxCount,0) as MaxCount
    FROM ResultTable a
        LEFT JOIN ResultTable b on a.ParentID = b.ID   
        INNER JOIN AStorageScheme ss ON ss.ID = a.ID
        INNER JOIN AStorageItems si ON si.ID = ss.AStorageItemID
        INNER JOIN AStorageItemsTypes sit ON sit.ID = si.AStorageItemsTypeID
        LEFT JOIN AStorageScheme ssParent ON ssParent.ID = b.ID
        LEFT JOIN AStorageItemsMaxs sim ON sim.AStorageItemID = ss.AStorageItemID AND sim.ParentAStorageItemID = ssParent.AStorageItemID
        LEFT JOIN (SELECT COUNT(asi.AStorageItemsTypeID) AS cnt, asi.AStorageItemsTypeID 
                   FROM AStorageStructure ast
                         INNER JOIN AStorageScheme ass ON ass.ID = ast.AStorageSchemeID
                         INNER JOIN AStorageItems asi ON asi.ID = ass.AStorageItemID
                   GROUP BY asi.AStorageItemsTypeID) AS ExistingStruct ON ExistingStruct.AStorageItemsTypeID = si.AStorageItemsTypeID        
    ORDER BY a.Sort

    DROP TABLE #tmp
END
GO