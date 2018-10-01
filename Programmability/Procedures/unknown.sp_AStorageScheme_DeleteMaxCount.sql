SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   29.08.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   29.08.2012$*/
/*$Version:    1.00$   $Decription: Удаление максимального кол-ва объекта в паренте$*/
create PROCEDURE [unknown].[sp_AStorageScheme_DeleteMaxCount]
	@ID Int,
    @AStorageItemID Int,
    @ParentAStorageItemID Int
AS
BEGIN
	SET NOCOUNT ON
    IF NOT EXISTS(SELECT * 
                 FROM AStorageScheme as ss
                      INNER JOIN AStorageScheme as ssParent on ss.ParentID = ssParent.ID
                 WHERE ss.AStorageItemID = ISNULL(@AStorageItemID,0)
                       AND ssParent.AStorageItemID = ISNULL(@ParentAStorageItemID,0)
                       AND ss.ID <> @ID)
    BEGIN
        DELETE 
        FROM AStorageItemsMaxs 
        WHERE AStorageItemID = ISNULL(@AStorageItemID,0)
              AND ParentAStorageItemID = ISNULL(@ParentAStorageItemID,0) 
    END   
                   
END
GO