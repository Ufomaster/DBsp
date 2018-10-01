SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    	$Create date:   07.08.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$        $Modify date:   07.08.2012$*/
/*$Version:    1.00$   $Description: Удаление узла дерева$*/
create PROCEDURE [unknown].[sp_AStorageScheme_Delete]
    @ID Int /*праймари кей записи AStorageScheme    */
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int

    IF EXISTS(SELECT * FROM AStorageScheme WHERE ParentID = @ID)
        RAISERROR ('Удаление непустых узлов запрещено (AStorageScheme)', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM AStorageStructure as sstr WHERE sstr.AStorageSchemeID = @ID)
        RAISERROR ('Удаление узла дерева, с которым связаны реальные объекты, запрещено', 16, 1)
               
    DECLARE @AStorageItemID Int, @ParentAStorageItemID Int, @ParentID int, @OrderID int
    SET XACT_ABORT ON
    BEGIN TRAN
    BEGIN TRY        
        SELECT @AStorageItemID = ss.AStorageItemID, 
               @ParentAStorageItemID =ssParent.AStorageItemID,
               @ParentID = ssParent.ID,
               @OrderID = ss.NodeOrder 
 		FROM AStorageScheme as ss
             INNER JOIN AStorageScheme as ssParent on ss.ParentID = ssParent.ID
        WHERE ss.ID = @ID
        
        /*Если в схеме больше нет связи между объектом и его родителем, то удаляем MAXCount     */
        EXEC sp_AStorageScheme_DeleteMaxCount @ID, @AStorageItemID, @ParentAStorageItemID
      
        DELETE 
        FROM AStorageScheme 
        WHERE ID = @ID

        UPDATE AStorageScheme
        SET NodeOrder = NodeOrder - 1
        WHERE ParentID = @ParentID AND NodeOrder > @OrderID
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        SET @Err = @@ERROR
        IF @@TRANCOUNT > 0 ROLLBACK TRAN
        EXEC sp_RaiseError @ID = @Err
    END CATCH
END
GO