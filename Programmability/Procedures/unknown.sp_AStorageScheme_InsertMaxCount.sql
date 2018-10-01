SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   07.08.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   13.08.2012$*/
/*$Version:    1.00$   $Decription: Добавление максимальной вместимости одного объекта в другом$*/
create PROCEDURE [unknown].[sp_AStorageScheme_InsertMaxCount]
    @AStorageItemID Int,        
    @NodeID Int,
    @MaxCount int,
    @NodeType int
    /*NodeTypeID: 0 - Parent, 1 - Self*/
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int

	BEGIN TRAN
	BEGIN TRY      
		DECLARE @ParentAStorageItemID int

        IF @NodeType = 0
            SELECT @ParentAStorageItemID = AStorageItemID 
            FROM AStorageScheme as ss 
                 LEFT JOIN AStorageItems as si on ss.AStorageItemID = si.ID
            WHERE ss.ID = @NodeID      
        ELSE
            SELECT @ParentAStorageItemID = AStorageItemID 
            FROM AStorageScheme as ss 
                 LEFT JOIN AStorageItems as si on ss.AStorageItemID = si.ID
            WHERE ss.ID = (SELECT ParentID FROM AStorageScheme WHERE ID = @NodeID)
            
        /*Если существует связка между двумя объектами, то обновляем, если нет - то делаем вставку*/
        IF EXISTS(SELECT * FROM AStorageItemsMaxs sim WHERE sim.AStorageItemID = @AStorageItemID AND sim.ParentAStorageItemID = @ParentAStorageItemID)
		BEGIN
    		UPDATE AStorageItemsMaxs
            SET MaxCount = @MaxCount
            WHERE AStorageItemID = @AStorageItemID 
                  AND ParentAStorageItemID = @ParentAStorageItemID
                  AND MaxCount <> @MaxCount
        END
        ELSE
        BEGIN
            INSERT INTO AStorageItemsMaxs (AStorageItemID, ParentAStorageItemID, MaxCount)
            OUTPUT INSERTED.ID #t
            SELECT @AStorageItemID, @ParentAStorageItemID, @MaxCount      
        END

		COMMIT TRAN        
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
	END CATCH;    
END
GO