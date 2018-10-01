SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$	$Create date:   21.04.2011$
--$Modify:     Yuriy Oleynik$	$Modify date:   17.01.2017$
--$Version:    1.00$   $Decription: Дерево справочников$
CREATE PROCEDURE [dbo].[sp_Tables_Tree_select]
AS
BEGIN
    SET NOCOUNT ON
    --деревья строить будем вручную, чтобы не париться с левелом, парентом и тд.
    --справочников будет не очень много
        
    SELECT
        CAST(-10 AS Int) AS ParentID,
        t.ID,
        t.[Name],
        t.[Description],
        t.FilteringTables, 
        t.MainField,
        CAST(1 AS Int) AS ImageIndex,
        CAST(1 AS Int) AS [Type],
        t.VisibleFields,
        1 AS Editable,
        CAST(t.ColumnWidths AS Varchar(1000)) AS ColumnWidths,
        t.OrderByClause
    FROM Tables t
    WHERE t.[Type] = 1 --users

    UNION ALL
    
    SELECT
        CAST(-9 AS Int) AS ParentID,
        t.ID,
        t.[Name],
        t.[Description],
        t.FilteringTables, 
        t.MainField,
        CAST(1 AS Int) AS ImageIndex,
        CAST(1 AS Int) AS [Type],
        t.VisibleFields,
        0 AS Editable,
        CAST(t.ColumnWidths AS Varchar(1000)) AS ColumnWidths,
        t.OrderByClause        
    FROM Tables t
    WHERE t.[Type] = 0 --system

    UNION ALL

    SELECT 
        NULL,
        -10,
        'Пользовательские',
        'Пользовательские',
        '', 
        '',
        CAST(0 AS Int) AS ImageIndex,
        0,
        NULL,
        0,
        NULL,
        NULL
    UNION ALL

    SELECT 
        NULL,
        -9,
        'Системные',
        'Системные',
        '', 
        '',
        CAST(0 AS Int) AS ImageIndex,
        0,
        NULL,
        0,
        NULL,
        NULL
/*    UNION ALL
    SELECT
        -2
        t.ID,
        t.[Name],
        t.[Description],
        t.FilteringTables, 
        t.MainField,
        CAST(1 AS int) AS ImageIndex,
        CAST(1 AS int) AS [Type],
        t.VisibleFields,
        1 AS Editable
    FROM vw_ObjectTypeStatuses*/
    
    ORDER BY ParentID, [Type], [Description], ID
END
GO