SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


--$Create:     Yuriy Oleynik$    $Create date:   29.03.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   29.03.2011$
--$Version:    1.00$   $Decription: выбор ноды дерева по парент ID$
CREATE FUNCTION [dbo].[fn_UserRightsObjectsNode_Select](@ParentID int = NULL)
RETURNS @T TABLE(ID int)
AS
BEGIN
    DECLARE @tmp TABLE(ID int)
    DECLARE @CurParentID int
    INSERT INTO @Tmp(ID)
    SELECT a.ID FROM UserRightsObjects a WHERE a.ParentID = @ParentID
        
    WHILE EXISTS(SELECT * FROM @tmp)
    BEGIN
        SELECT TOP 1 @CurParentID = ID FROM @tmp
            
        INSERT INTO @T(ID)
        SELECT @CurParentID
            
        INSERT INTO @T(ID)
        SELECT ID
        FROM dbo.fn_UserRightsObjectsNode_Select(@CurParentID)
            
        DELETE FROM @tmp WHERE ID = @CurParentID
    END
    RETURN        
END
GO