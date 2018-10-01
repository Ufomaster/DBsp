SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   31.07.2012$*/
/*$Modify:     Zapadinskiy Anatoliy$    $Modify date:   13.08.2012$*/
/*$Version:    1.00$   $Decription: Добавление объекта в схему хранения$*/
create PROCEDURE [unknown].[sp_AStorageScheme_Insert]
    @ActiveTreeID Int,
    @AStorageItemID Int,        
    @NodeImageIndex Int,
    @MaxCount int,
    @isCopy Int
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int
    DECLARE @t TABLE(ID Int)
    DECLARE @NewID Int

	BEGIN TRAN
	BEGIN TRY
        DECLARE @Order Int, @ParentID Int, @Level Int, @PArentAStorageItemID int

        CREATE TABLE #t(ID Int)    
            
        SET @ParentID = NULL
        SET @Order = NULL
        SELECT @Level = [NodeLevel], @PArentAStorageItemID = AStorageItemID FROM AStorageScheme ss WHERE ss.ID = @ActiveTreeID    

		
        --Анализ
        IF @isCopy = 0 -- если не копирование
        BEGIN
            IF EXISTS(SELECT * FROM AStorageScheme ss WHERE ss.ParentID = @ActiveTreeID) -- если есть внутри записи, вставка в конец
            BEGIN
                SELECT @ParentID = ss.ParentID, @Order = ISNULL(MAX(ss.NodeOrder), 0)
                FROM AStorageScheme ss
                WHERE ss.ParentID = @ActiveTreeID
                GROUP BY ss.ParentID
            END
            ELSE
            BEGIN --если нет записей внутри
                SELECT @ParentID = @ActiveTreeID, @Order = 0
            END
        END
        ELSE
        BEGIN
            SELECT @ParentID = ISNULL(ss.ParentID, 0)
            FROM AStorageScheme ss
            WHERE ss.ID = @ActiveTreeID
        END
        
        --Вставка
        IF @ParentID IS NULL AND @Order IS NULL
            --если запись кидается вообще в пустой список
            INSERT INTO AStorageScheme(NodeImageIndex, NodeOrder, NodeLevel, ParentID, AStorageItemID)
            OUTPUT INSERTED.ID INTO #t
            VALUES(@NodeImageIndex, 0, NULL, 0, @AStorageItemID)  
        ELSE BEGIN
            IF @isCopy = 0
                --Считаем что мы кинули запись внутрь той в которую ткнули мышей
                --В конец        
                SELECT @Order = ISNULL(MAX(NodeOrder), 0)
                FROM AStorageScheme
                WHERE ISNULL(ParentID, 0) = ISNULL(@ActiveTreeID, 0)
            ELSE
            BEGIN
                --Считаем что копируется запись в тот же список что и копируемая
                --В конец
                SELECT @Order = ISNULL(MAX(NodeOrder), 0)
                FROM AStorageScheme
                WHERE ISNULL(ParentID, 0) = @ParentID
                --уменьшим левл на один, так как вставка будет давать + 1
                SELECT @Level = ISNULL(@Level, 1) - 1
            END
                
            --вставим новую запись           
 			INSERT INTO AStorageScheme(NodeImageIndex, NodeOrder, NodeLevel, ParentID, AStorageItemID)
            OUTPUT INSERTED.ID INTO #t
            SELECT @NodeImageIndex, @Order + 1, ISNULL(@Level + 1, 0), CASE WHEN @ParentID = 0 THEN NULL ELSE @ParentID END, @AStorageItemID
        END    
        
        --Если существует парент, то записываем или апдейтим его значение
        IF @PArentAStorageItemID is not null
            EXEC sp_AStorageScheme_InsertMaxCount @AStorageItemID, @ActiveTreeID, @MaxCount, 0
        
        SELECT @NewID = ID FROM #t
        
        --Копирование данных если "Копирование"
        IF @isCopy = 1
        BEGIN
            UPDATE a
            SET          
                a.NodeImageIndex = b.NodeImageIndex
            FROM AStorageScheme AS a
            INNER JOIN AStorageScheme b ON b.ID = @ActiveTreeID
            WHERE a.ID = @NewID       
        END

        DROP TABLE #t
        
		COMMIT TRAN        
	END TRY
	BEGIN CATCH
		SET @Err = @@ERROR;
		IF @@TRANCOUNT > 0 ROLLBACK TRAN;
		EXEC sp_RaiseError @ID = @Err;
		SET @NewID = -1;
	END CATCH;

    SELECT @NewID AS ID        
END
GO