SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Yuriy Oleynik$    $Create date:   13.05.2011$
--$Modify:     Yuriy Oleynik$    $Modify date:   13.05.2011$
--$Version:    1.00$   $Decription: двигаем проперти вниз вверх$
CREATE PROCEDURE [dbo].[sp_TmcTree_MoveProperty]
    @ID Int,
    @AMoveUp Int
AS
BEGIN
    IF @AMoveUp = 1 -- VK_UP
    BEGIN
        UPDATE #Properties
        SET SortOrder = SortOrder + 1 
        WHERE SortOrder = (SELECT SortOrder - 1 FROM #Properties WHERE ID = @ID)
        
        UPDATE #Properties
        SET SortOrder = CASE WHEN SortOrder > 1 THEN SortOrder - 1 ELSE SortOrder END
        WHERE ID = @ID
    END
    ELSE

    IF @AMoveUp = 0 -- VK_DOWN
    BEGIN        
        UPDATE #Properties
        SET SortOrder = SortOrder - 1 
        WHERE SortOrder = (SELECT SortOrder + 1 FROM #Properties WHERE ID = @ID)
        
        UPDATE #Properties
        SET SortOrder = CASE WHEN SortOrder < (SELECT COUNT(SortOrder) FROM #Properties) THEN SortOrder + 1 ELSE SortOrder END
        WHERE ID = @ID
    END
END
GO