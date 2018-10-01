SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   22.08.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   22.08.2012$*/
/*$Version:    1.00$   $Decription: Выбор элементов хранилища в дерево$*/
create PROCEDURE [unknown].[sp_AStorageStructure_SelectTree]
AS
BEGIN
    SET NOCOUNT ON
    SELECT
        ss.ID,
        ss.ParentID,
        ISNULL(s.NodeOrder, 10000) AS NodeOrder,
        ISNULL(s.NodeLevel, 0) AS NodeLevel
    INTO #tmp
    FROM AStorageStructure ss
    LEFT JOIN AStorageScheme s ON s.ID = ss.AStorageSchemeID
    INNER JOIN vw_AStorageItems i ON i.ID = s.AStorageItemID
    WHERE ISNULL(i.isAtomic, 0) = 0;

    WITH ResultTable (ID, ParentID, NodeOrder, Sort)
    AS
    (
    /* Anchor member definition*/
        SELECT
            ID, ParentID, NodeOrder,
            CONVERT(Varchar(MAX), REPLICATE(RIGHT(REPLICATE('0',10 - LEN(CAST(NodeOrder AS Varchar(10)))) + CAST(NodeOrder AS Varchar(10)), 10) + '|', NodeLevel + 1))
             AS [Sort]
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
        a.Sort,
        a.NodeOrder,
        ss.*,
        ISNULL(i.[Name] + ' ', '') + ss.Number AS FullName,
        ISNULL(s.NodeImageIndex, 59) AS NodeImageIndex,
        ISNULL(s.NodeLevel, 0) AS NodeLevel
    FROM ResultTable a
    INNER JOIN AStorageStructure ss ON ss.ID = a.ID
    LEFT JOIN AStorageScheme s ON s.ID = ss.AStorageSchemeID
    INNER JOIN vw_AStorageItems i ON i.ID = s.AStorageItemID
    ORDER BY a.Sort

    DROP TABLE #tmp

END
GO