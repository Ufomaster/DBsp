SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   08.08.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   08.08.2012$*/
/*$Version:    1.00$   $Decription: выбор ноды дерева по парент ID$*/
create FUNCTION [unknown].[fn_AStorageSchemeNode_Select] (@ParentID int = NULL)
RETURNS @T TABLE(ID int)
AS
BEGIN
    DECLARE @tmp TABLE(ID int, ParentID int, NodeOrder int)
    
    INSERT INTO @tmp
    SELECT
        ss.ID,
        ss.ParentID,
        ss.NodeOrder
    FROM AStorageScheme ss;
    /*получаем список чаилдов*/
    WITH ResultTable (ID, ParentID, NodeOrder, Sort)
    AS
    (
    /* Anchor member definition*/
        SELECT
            ID, ParentID, NodeOrder,
            CONVERT(Varchar(MAX), RIGHT(REPLICATE('0',10 - LEN(CAST(NodeOrder AS Varchar(10)))) + cast(NodeOrder AS Varchar(10)), 10)) AS [Sort]
        FROM @tmp e
        WHERE ID = @ParentID

        UNION ALL
    /* Recursive member definition*/

        SELECT
            e.ID, e.ParentID, e.NodeOrder,
            CONVERT (Varchar(MAX), RTRIM(Sort) + '|' + RIGHT(REPLICATE('0',10 - LEN(cast(e.NodeOrder AS Varchar(10)))) + cast(e.NodeOrder AS Varchar(10)), 10)) AS [Sort]
        FROM @tmp AS e
        INNER JOIN ResultTable AS d
            ON e.ParentID = d.ID
    )    
	
    INSERT INTO @T
    SELECT ID 
    FROM ResultTable    
    
    Return
END
GO