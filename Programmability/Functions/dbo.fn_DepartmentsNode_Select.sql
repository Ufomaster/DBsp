SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   01.03.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   08.08.2011$
--$Version:    1.00$   $Decription: выбор ноды дерева по парент ID$
CREATE FUNCTION [dbo].[fn_DepartmentsNode_Select] (@ParentID Int = NULL)
RETURNS @T TABLE(ID Int)
AS
BEGIN
/*  --old recursion
    DECLARE @tmp TABLE(ID Int)
    DECLARE @CurParentID Int
    INSERT INTO @Tmp(ID)
    SELECT ID FROM Departments WHERE ParentID = @ParentID AND ClosedDate IS NULL
        
    WHILE EXISTS(SELECT * FROM @tmp)
    BEGIN
        SELECT TOP 1 @CurParentID = ID FROM @tmp
            
        INSERT INTO @T(ID)
        SELECT @CurParentID
            
        INSERT INTO @T(ID)
        SELECT ID
        FROM dbo.fn_DepartmentsNode_Select(@CurParentID)
            
        DELETE FROM @tmp WHERE ID = @CurParentID
    END*/
    WITH ResultTable (ID, ParentID, Sort)
    AS
    (
    /* Anchor member definition*/
        SELECT
            ot.ID, ot.ParentID
            --,CONVERT(Varchar(300), RIGHT('00' + CAST(ot.NodeOrder AS Varchar(2)), 2)) --нормированный сорт "как в дереве"
            ,0 AS [Sort]
        FROM Departments ot
        WHERE (ot.ParentID = @ParentID AND @ParentID IS NOT NULL) OR (@ParentID IS NULL AND ot.ParentID IS NULL)
        
        UNION ALL
    /* Recursive member definition*/

        SELECT
            ot.ID, ot.ParentID
            --,CONVERT(Varchar(300), d.Sort + RIGHT('00' + CAST(ot.NodeOrder AS Varchar(2)), 2)) --нормированный сорт "как в дереве"
            ,Sort + 1
        FROM Departments ot
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