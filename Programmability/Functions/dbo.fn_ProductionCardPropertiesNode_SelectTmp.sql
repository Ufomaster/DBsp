SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Yuriy Oleynik$    $Create date:   26.12.2011$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   26.12.2011$*/
/*$Version:    1.00$   $Decription: выбор ноды дерева по парент ID$*/
CREATE FUNCTION [dbo].[fn_ProductionCardPropertiesNode_SelectTmp] (@ParentID Int, @Alevel Int)
RETURNS @T TABLE(ID Int, NodeLevel Int, NodeOrder Int, ParentID Int)
AS
BEGIN
        DECLARE @tmp TABLE(ID Int, NodeOrder Int)
        DECLARE @CurParentID Int, @NodeOrder Int
        INSERT INTO @Tmp(ID, NodeOrder)
        SELECT 
            a.ID, 
            ROW_NUMBER() OVER (ORDER BY a.ID) 
        FROM ProductionCardProperties a WHERE a.ParentID = @ParentID
        
        WHILE EXISTS(SELECT * FROM @tmp)
        BEGIN
            SELECT TOP 1 @CurParentID = ID, @NodeOrder = NodeOrder FROM @tmp
            
            INSERT INTO @T(ID, NodeLevel, NodeOrder, ParentID)
            SELECT @CurParentID, @Alevel + 1, @NodeOrder, @ParentID
            
            INSERT INTO @T(ID, NodeLevel, NodeOrder, ParentID)
            SELECT 
                b.ID, 
                b.NodeLevel, 
                b.NodeOrder,
                b.ParentID
            FROM dbo.fn_ProductionCardPropertiesNode_SelectTmp(@CurParentID, @Alevel + 1) b
            
            DELETE FROM @tmp WHERE ID = @CurParentID
        END
    RETURN        
END
GO