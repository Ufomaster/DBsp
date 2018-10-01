SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$    $Create date:   31.07.2012$*/
/*$Modify:     Yuriy Oleynik$    		$Modify date:   12.02.2016$*/
/*$Version:    2.00$   $Decription: Добавление объекта в структуру хранения$*/
CREATE PROCEDURE [manufacture].[sp_StorageStructure_Insert]
    @ActiveTreeID Int,
    @Name varchar(255),        
    @NodeImageIndex Int,
    @IP varchar(255),
    @HiddenForSelect bit
AS
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	DECLARE @Err Int
    DECLARE @NewID Int

	BEGIN TRAN
	BEGIN TRY
        DECLARE @Order Int, @ParentID Int, @Level Int

        CREATE TABLE #t(ID Int)    
            
        SET @ParentID = NULL
        SET @Order = NULL
        SELECT @Level = [NodeLevel] FROM manufacture.StorageStructure ss WHERE ss.ID = @ActiveTreeID    
		
        --Проверка на дубликаты имени
        IF EXISTS(SELECT * FROM manufacture.StorageStructure ss WHERE ss.ParentID = @ActiveTreeID AND ss.[Name] = @Name)
        RAISERROR ('Объект с таким именем уже существует на данном уровне дерева. Добавление одинаковых объектов на одном уровне запрещено.', 16, 1)                        
        
        --Анализ
        IF EXISTS(SELECT * FROM manufacture.StorageStructure ss WHERE ss.ParentID = @ActiveTreeID) -- если есть внутри записи, вставка в конец
        BEGIN
            SELECT @ParentID = ss.ParentID, @Order = ISNULL(MAX(ss.NodeOrder), 0)
            FROM manufacture.StorageStructure ss
            WHERE ss.ParentID = @ActiveTreeID
            GROUP BY ss.ParentID
        END
        ELSE
        BEGIN --если нет записей внутри
            SELECT @ParentID = @ActiveTreeID, @Order = 0
        END
        
        --Вставка
        IF @ParentID IS NULL AND @Order IS NULL
            --если запись кидается вообще в пустой список
            INSERT INTO manufacture.StorageStructure(NodeImageIndex, NodeOrder, NodeLevel, ParentID, [Name], IP, HiddenForSelect)
            OUTPUT INSERTED.ID INTO #t
            VALUES(@NodeImageIndex, 0, NULL, 0, @Name, @IP, @HiddenForSelect)
        ELSE BEGIN
            --Считаем что мы кинули запись внутрь той в которую ткнули мышей
            --В конец        
            SELECT @Order = ISNULL(MAX(NodeOrder), 0)
            FROM manufacture.StorageStructure
            WHERE ISNULL(ParentID, 0) = ISNULL(@ActiveTreeID, 0)
                
            --вставим новую запись           
 			INSERT INTO manufacture.StorageStructure(NodeImageIndex, NodeOrder, NodeLevel, ParentID, [Name], IP, HiddenForSelect)
            OUTPUT INSERTED.ID INTO #t
            SELECT @NodeImageIndex, @Order + 1, ISNULL(@Level + 1, 0), CASE WHEN @ParentID = 0 THEN NULL ELSE @ParentID END, @Name, @IP, @HiddenForSelect
        END    
        
        SELECT @NewID = ID FROM #t
            
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