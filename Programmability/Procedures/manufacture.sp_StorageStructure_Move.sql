SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   07.08.2011$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   10.12.2013$*/
/*$Version:    2.00$   $Description: Перемещение ветви дерева$*/
create PROCEDURE [manufacture].[sp_StorageStructure_Move]
    @ID Int,
    @Direction Int
AS
BEGIN
	SET NOCOUNT ON

    DECLARE @DestinationParentID Int, @MaxOrder Int, @MinOrder Int, @Order Int, @AStorageItemID int, @Err nvarchar(4000)
    IF @Direction = 1 /* VK_LEFT*/
    /*Опасность существует только для верзнего узла перемещяемой ветки, поэтому проверяем только его */
	BEGIN
        /* выберем ParentID той записи, которая стоит выше уровнем    */        
        SELECT @DestinationParentID = ISNULL(ParentID, 0),@Order = NodeOrder
        FROM manufacture.StorageStructure
        WHERE ID = (SELECT ISNULL(ParentID, 0) FROM manufacture.StorageStructure WHERE ID = @ID)
        IF @DestinationParentID IS NULL
            RETURN           
             
        --Проверка на дубликаты имени
        IF EXISTS(SELECT * FROM manufacture.StorageStructure ss 
                  WHERE ss.ParentID = @DestinationParentID 
                        AND ss.[Name] = (SELECT [Name] FROM manufacture.StorageStructure WHERE ID = @ID))
        BEGIN                
            RAISERROR ('Объект с таким именем уже существует на данном уровне дерева. Добавление одинаковых объектов на одном уровне запрещено.', 16, 1)    
            RETURN
        END
                  
        /* Подвигаем все записи после - вниз, там где вставили новую запись*/
        UPDATE manufacture.StorageStructure
        SET
            NodeOrder = NodeOrder + 1
        WHERE ISNULL(ParentID, 0) = @DestinationParentID AND NodeOrder >= @Order
        /*Подвигаем все записи откуда вышли - вверх*/
        UPDATE manufacture.StorageStructure
        SET
            NodeOrder = NodeOrder - 1
        WHERE ISNULL(ParentID, 0) = (SELECT ISNULL(ParentID, 0) FROM manufacture.StorageStructure WHERE ID = @ID) AND 
              NodeOrder > (SELECT NodeOrder FROM manufacture.StorageStructure WHERE ID = @ID)
        /*Устанавливаем себе номер порядка на новом месте*/
        UPDATE manufacture.StorageStructure
        SET
            ParentID = CASE WHEN @DestinationParentID = 0 THEN NULL ELSE @DestinationParentID END,
            NodeOrder = CASE WHEN @Order IS NULL THEN 1 ELSE @Order END
        WHERE ID = @ID
        /*если двигается целая ветка, то нужно уменьшить левел всех чайлдов.*/
        UPDATE manufacture.StorageStructure
        SET [NodeLevel] = [NodeLevel] - 1
        WHERE ID IN (SELECT ID FROM manufacture.fn_StorageStructureNode_Select(@ID))
    END
    ELSE

    IF @Direction = 2 /* VK_RIGHT*/
    BEGIN
        /* выберем ID той записи, которая стоит ниже уровнем    */
        SELECT @DestinationParentID = ID, @Order = NodeOrder
        FROM manufacture.StorageStructure
        WHERE NodeOrder = (SELECT NodeOrder + 1 FROM manufacture.StorageStructure WHERE ID = @ID) AND 
              ISNULL(ParentID, 0) = (SELECT ISNULL(ParentID, 0) FROM manufacture.StorageStructure WHERE ID = @ID)
        /* Если мы в конце, то некуда двигаться вообще*/
        IF @DestinationParentID IS NULL
        	RETURN
            
	    -- ADD CHECK FOR DUPLICATE NAME            
        --Проверка на дубликаты имени
        IF EXISTS(SELECT * FROM manufacture.StorageStructure ss 
                  WHERE ss.ParentID = @DestinationParentID 
                        AND ss.[Name] = (SELECT [Name] FROM manufacture.StorageStructure WHERE ID = @ID))
        BEGIN                
            RAISERROR ('Объект с таким именем уже существует на данном уровне дерева. Добавление одинаковых объектов на одном уровне запрещено.', 16, 1)    
            RETURN
        END
        /* Подвигаем все записи после - вниз, мы вставили новую запись*/
        UPDATE manufacture.StorageStructure
        SET
            NodeOrder = NodeOrder + 1
        WHERE ISNULL(ParentID, 0) = @DestinationParentID
        /*Подвигаем все записи откуда вышли - вверх*/
        UPDATE manufacture.StorageStructure
        SET
            NodeOrder = NodeOrder - 1
        WHERE ISNULL(ParentID, 0) = (SELECT ISNULL(ParentID, 0) FROM manufacture.StorageStructure WHERE ID = @ID) AND 
             NodeOrder > (SELECT NodeOrder FROM manufacture.StorageStructure WHERE ID = @ID)
        /*Устанавливаем себе номер порядка на новом месте*/
        UPDATE manufacture.StorageStructure
        SET 
           ParentID = CASE WHEN @DestinationParentID = 0 THEN NULL ELSE @DestinationParentID END,
           NodeOrder = 1 /*ставим всегда вначало*/
        WHERE ID = @ID
        /*если двигали целую ветку, то проапдейтим левел + 1*/
        UPDATE manufacture.StorageStructure
        SET [NodeLevel] = [NodeLevel] + 1
        WHERE ID IN (SELECT ID FROM manufacture.fn_StorageStructureNode_Select(@ID))
    END
    ELSE

    IF @Direction = 3 /* VK_UP*/
    BEGIN
        /*выбрали текущий парент, это у нас группирующий флаг, а так же текущее значение порядка*/
        SELECT @DestinationParentID = ISNULL(ParentID, 0), @Order = NodeOrder
        FROM manufacture.StorageStructure WHERE ID = @ID
        /*выберем предыдущий порядок*/
        SELECT TOP 1 @Order = NodeOrder
        FROM manufacture.StorageStructure
        WHERE ISNULL(ParentID, 0) = @DestinationParentID AND NodeOrder < @Order
        ORDER BY NodeOrder DESC
        /*сдвинем предыдущую запись вниз, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE manufacture.StorageStructure
            SET NodeOrder = NodeOrder + 1
            WHERE NodeOrder = @Order AND ISNULL(ParentID, 0) = @DestinationParentID
        ELSE
            SET @Order = 1
       /*наконец проставим себе индекс если возможно*/
       UPDATE manufacture.StorageStructure
       SET NodeOrder = @Order
       WHERE ID = @ID
    END
    ELSE

    IF @Direction = 4 /* VK_DOWN*/
    BEGIN
        /*выбрали текущий парент, это у нас группирующий флаг, а так же текущее значение порядка*/
        SELECT @DestinationParentID = ISNULL(ParentID, 0), @Order = NodeOrder
        FROM manufacture.StorageStructure WHERE ID = @ID
        /*выберем следующий порядок*/
        SELECT TOP 1 @Order = NodeOrder
        FROM manufacture.StorageStructure
        WHERE ISNULL(ParentID, 0) = @DestinationParentID AND NodeOrder > @Order
        ORDER BY NodeOrder
        /*сдвинем след. запись вверх, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE manufacture.StorageStructure
            SET NodeOrder = NodeOrder - 1
            WHERE NodeOrder = @Order AND ISNULL(ParentID, 0) = @DestinationParentID
        ELSE
            SET @Order = (SELECT MAX(NodeOrder + 1) FROM manufacture.StorageStructure WHERE ISNULL(ParentID, 0) = @DestinationParentID)
       /*наконец проставим себе индекс если возможно*/
       IF @Order IS NULL
           SET @Order = 1
       UPDATE manufacture.StorageStructure
       SET NodeOrder = @Order
       WHERE ID = @ID
    END
END
GO