SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   07.08.2012$*/
/*$Modify:     Yuriy Oleynik$    $Modify date:   17.08.2012$*/
/*$Version:    1.00$   $Decription: Добавление максимальной вместимости одного объекта в другом$*/
create PROCEDURE [unknown].[sp_AStorageScheme_SelectMaxCount]
    @NodeID Int,        
    @AStorageItemID Int,
    @NodeType Int
    /*NodeTypeID: 0 - Parent, 1 - Self*/
AS
BEGIN
	DECLARE @ParentAStorageItemID Int, @Res Int

    IF @NodeType = 0
		SELECT @ParentAStorageItemID = AStorageItemID 
        FROM AStorageScheme AS ss 
             LEFT JOIN AStorageItems AS si ON ss.AStorageItemID = si.ID
        WHERE ss.ID = @NodeID      
    ELSE
		SELECT @ParentAStorageItemID = AStorageItemID 
        FROM AStorageScheme AS ss 
             LEFT JOIN AStorageItems AS si ON ss.AStorageItemID = si.ID
        WHERE ss.ID = (SELECT ParentID FROM AStorageScheme WHERE ID = @NodeID)
    
    --PRINT @ParentAStorageItemID -- Это что?
        
    --SELECT ISNULL(sim.MaxCount, 0)  -- не работает. Так как если нет записей вернется 0 строк, а не нул.
    SELECT @Res = sim.MaxCount
    FROM
        AStorageItemsMaxs sim
    WHERE sim.AStorageItemID = @AStorageItemID
          AND sim.ParentAStorageItemID = @ParentAStorageItemID
    
    SELECT ISNULL(@Res, 0)
END
GO