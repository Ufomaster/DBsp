SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   30.10.2017$
--$Modify:     Yuriy Oleynik$    $Modify date:   30.10.2017$
--$Version:    1.00$   $Decription: vw_TechnologicalOperations
create VIEW [manufacture].[vw_TechnologicalOperations]
AS
    WITH ResultTable (ID, ParentID)
    AS
    (
        SELECT
            ID, ParentID
        FROM manufacture.TechnologicalOperations o
        WHERE ParentID IS NULL        
        
        UNION ALL

        SELECT
            o.ID, o.ParentID
        FROM manufacture.TechnologicalOperations o
        INNER JOIN ResultTable AS d ON o.ParentID = d.ID
    )
    
    SELECT 
        o.*
    FROM ResultTable as rt
    INNER JOIN manufacture.TechnologicalOperations o ON o.ID = rt.ID
GO