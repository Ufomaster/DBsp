SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   13.08.2012$*/
/*$Modify:     Oleynik Yuriy$    $Modify date:   17.08.2012$*/
/*$Version:    1.00$   $Decription: Редактирование объекта в схеме хранения$*/
create PROCEDURE [unknown].[sp_AStorageScheme_Modify]
    @NodeID Int,
    @AStorageItemID Int,
    @NodeImageIndex Int,
    @MaxCount Int,
    @NodeType Int
    /*NodeTypeID: 0 - Parent, 1 - Self*/    
AS
BEGIN
	SET NOCOUNT ON

    UPDATE AStorageScheme
    SET NodeImageIndex = @NodeImageIndex
    WHERE ID = @NodeID
        
    EXEC sp_AStorageScheme_InsertMaxCount @AStorageItemID, @NodeID, @MaxCount, @NodeType
END
GO