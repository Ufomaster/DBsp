SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$	$Create date:   01.02.2018$
--$Modify:     Yuriy Oleynik$	$Modify date:   01.02.2018$
--$Version:    1.00$   $Decription: выбор ноды дерева по парент ID$
create FUNCTION [dbo].[fn_ObjectTypesNode_SelectRoot] (@ID Int)
RETURNS int  --@T TABLE (ID INT, ObjectTypeID int)
AS
BEGIN
    DECLARE @outID int;
    
    WITH ResultTable (ID, ParentID, Sort)
    AS
    (
    /* Anchor member definition*/
        SELECT
            ot.ID, ot.ParentID
            ,0 AS [Sort]
        FROM ObjectTypes ot
        WHERE ot.ID = @ID
        
        UNION ALL
    /* Recursive member definition*/

        SELECT
            ot.ID, ot.ParentID
            ,Sort + 1
        FROM ObjectTypes ot
        INNER JOIN ResultTable AS d
            ON ot.ID = d.ParentID
    )

    --INSERT INTO @T
    SELECT @outID = ID FROM ResultTable WHERE ParentID IS NULL
    
    RETURN @outID       
END
GO