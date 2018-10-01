SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   26.07.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   16.02.2016$*/
/*$Version:    2.00$   $Decription: Выбор дерева схемы хранилища$*/
CREATE PROCEDURE [manufacture].[sp_StorageStructure_Select]
    @VisibleOnly int = 0
AS
BEGIN
    SET NOCOUNT ON

    SELECT
        ss.ID,
        ss.ParentID,
        ss.NodeOrder
    INTO #tmp
    FROM manufacture.StorageStructure ss;

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
        ss.ID,
        ss.ParentID,
        ss.NodeOrder,
        ss.NodeImageIndex,
        ss.NodeLevel,
        ss.NodeExpanded,
        ss.Name,
        ss.IP,
        ss.HiddenForSelect
        , ssParent.[Name] as [ParentName],
        ss.[Name] + CASE WHEN ISNULL(ss.IP, '') = '' THEN '' ELSE '*' END AS [NameAlt]
    FROM ResultTable a
        LEFT JOIN ResultTable b on a.ParentID = b.ID   
        INNER JOIN manufacture.StorageStructure ss ON ss.ID = a.ID
        LEFT JOIN manufacture.StorageStructure ssParent ON ssParent.ID = b.ID
    WHERE (@VisibleOnly = 1 AND ISNULL(ss.HiddenForSelect, 0) = 0) OR (@VisibleOnly = 0) 
    ORDER BY a.Sort

    DROP TABLE #tmp
END
GO