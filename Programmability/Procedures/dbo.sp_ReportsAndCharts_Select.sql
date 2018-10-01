SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$	$Create date:   31.08.2012$*/
/*$Modify:     Yuriy Oleynik$	$Modify date:	05.04.2017$*/
/*$Version:    1.00$   $Description: Выборка доступных пользователю отчетов$*/
CREATE PROCEDURE [dbo].[sp_ReportsAndCharts_Select]
    @UserID int
AS
BEGIN
    SET NOCOUNT ON

    SELECT
        g.ID,
        g.ParentID,
        ROW_NUMBER() OVER (ORDER by g.ID, g.ParentID) AS NodeOrder
    INTO #tmp
    FROM ReportsAndChartsGroup g;

    WITH ResultTable (ID, ParentID, NodeOrder, Sort)
    AS
    (
    /* Anchor member definition*/
        SELECT
            fc.ID, fc.ParentID, fc.NodeOrder,
            CONVERT(Varchar(MAX), RIGHT(REPLICATE('0',10 - LEN(CAST(fc.NodeOrder AS Varchar(10)))) + cast(fc.NodeOrder AS Varchar(10)), 10)) AS [Sort]
        FROM #tmp fc
        WHERE fc.ParentID IS NULL

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
        g.[Name],
        g.ID,
        g.[Name] AS [Caption],
        g.ImageID AS ImageIndex,
        a.Sort,
        0 AS [Type],
        CAST(0 AS bit) AS AutoExec
    FROM ResultTable a
    INNER JOIN ReportsAndChartsGroup g ON g.ID = a.ID

    UNION ALL

    SELECT 
        r.[Name],
        r.ID,
        r.[Caption],
        CASE
            WHEN r.[Type] = 0 THEN 36
            WHEN r.[Type] = 1 THEN 75
        END AS ImageIndex,
        a.Sort,
        1,
        r.AutoExec
    FROM ReportsAndCharts r
    INNER JOIN ResultTable a ON a.ID = r.GroupID
    INNER JOIN UserReportsAndCharts ur ON ur.UserID = @UserID AND ur.ReportsAndChartsID = r.ID  
    WHERE ISNULL(r.IsDeleted,0) = 0
    
    UNION ALL --отчеты без группы, в корень

    SELECT 
        r.[Name],
        r.ID,
        r.[Caption],
        CASE
            WHEN r.[Type] = 0 THEN 36
            WHEN r.[Type] = 1 THEN 75
        END AS ImageIndex,
        'zzzz',
        -1,
        r.AutoExec
    FROM ReportsAndCharts r
    INNER JOIN UserReportsAndCharts ur ON ur.UserID = @UserID AND ur.ReportsAndChartsID = r.ID    
    WHERE r.GroupID IS NULL
        AND ISNULL(r.IsDeleted,0) = 0
    ORDER BY a.Sort, [Type]

    DROP TABLE #tmp
END
GO