SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    	$Create date:   07.08.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$        $Modify date:   20.03.2014$*/
/*$Version:    2.00$   $Description: Удаление узла дерева$*/
CREATE PROCEDURE [manufacture].[sp_StorageStructure_Delete]
    @ID Int /*праймари кей записи AStorageScheme    */
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @Err Int
    DECLARE @ParentID int, @OrderID int
    SET XACT_ABORT ON    

    IF EXISTS(SELECT * FROM manufacture.StorageStructure WHERE ParentID = @ID)
        RAISERROR ('Удаление непустых узлов запрещено (StorageStructure)', 16, 1)
    ELSE
    IF EXISTS(SELECT * FROM manufacture.PTmcGroups as g WHERE g.StorageStructureID = @ID)
        RAISERROR ('Удаление узла дерева, к которым привязаны персонализированные ТМЦ, запрещено', 16, 1)
    ELSE
    BEGIN  
        BEGIN TRAN
        BEGIN TRY        
            SELECT @ParentID = ssParent.ID,
                   @OrderID = ss.NodeOrder 
            FROM manufacture.StorageStructure as ss
                 INNER JOIN manufacture.StorageStructure as ssParent on ss.ParentID = ssParent.ID
            WHERE ss.ID = @ID
            
            DELETE 
            FROM manufacture.StorageStructure 
            WHERE ID = @ID

            UPDATE manufacture.StorageStructure
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
END
GO