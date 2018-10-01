SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$	$Create date:   26.12.2011$
--$Modify:     Yuriy Oleynik$	$Modify date:   08.08.2012$
--$Version:    1.00$   $Decription: выбор нод дерева по парент ID$
CREATE FUNCTION [dbo].[fn_ProductionCardPropertiesNode_Select] (@ParentID Int = NULL)
RETURNS @T TABLE(ID Int)
AS
BEGIN
/*   old recursion
    DECLARE @tmp TABLE(ID Int)
    DECLARE @CurParentID Int
    INSERT INTO @Tmp(ID)
    SELECT a.ID FROM ProductionCardProperties a WHERE a.ParentID = @ParentID
        
    WHILE EXISTS(SELECT * FROM @tmp)
    BEGIN
        SELECT TOP 1 @CurParentID = ID FROM @tmp
            
        INSERT INTO @T(ID)
        SELECT @CurParentID
            
        INSERT INTO @T(ID)
        SELECT ID
        FROM dbo.fn_ProductionCardPropertiesNode_Select(@CurParentID)
            
        DELETE FROM @tmp WHERE ID = @CurParentID
    END*/
    WITH ResultTable (ID, ParentID, Sort)
    AS
    (
    /* Anchor member definition*/
        SELECT
            ot.ID, ot.ParentID
            --CONVERT(Varchar(MAX), RIGHT(REPLICATE('0',10 - LEN(CAST(ot.NodeOrder AS Varchar(10)))) + CAST(ot.NodeOrder AS Varchar(10)), 10)) AS [Sort]
            --,CONVERT(Varchar(300), RIGHT('00' + CAST(ot.NodeOrder AS Varchar(2)), 2))   
            ,0 AS [Sort]
        FROM ProductionCardProperties ot
        WHERE (ot.ParentID = @ParentID AND @ParentID IS NOT NULL) OR (@ParentID IS NULL AND ot.ParentID IS NULL)
        
        UNION ALL
    /* Recursive member definition*/

        SELECT
            ot.ID, ot.ParentID
            --CONVERT (Varchar(MAX), RTRIM(d.Sort) + '|' + RIGHT(REPLICATE('0',10 - LEN(cast(ot.NodeOrder AS Varchar(10)))) + cast(ot.NodeOrder AS Varchar(10)), 10)) AS [Sort]
            --,CONVERT(Varchar(300), d.Sort + RIGHT('00' + CAST(ot.NodeOrder AS Varchar(2)), 2))
            ,Sort + 1
        FROM ProductionCardProperties ot
        INNER JOIN ResultTable AS d
            ON ot.ParentID = d.ID
    )

    INSERT INTO @T(ID)
    SELECT ID
    FROM ResultTable
    ORDER BY Sort

    RETURN        
END
GO