SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*$Create:     Zapadinskiy Anatoliy$	$Create date:   07.08.2011$*/
/*$Modify:     Zapadinskiy Anatoliy$	$Modify date:   29.08.2012$*/
/*$Version:    1.00$   $Description: Перемещение ветви дерева$*/
create PROCEDURE [unknown].[sp_AStorageScheme_Move]
    @ID Int,
    @Direction Int
AS
BEGIN
	SET NOCOUNT ON

    DECLARE @ParentAStorageItemID Int, @DestinationParentID Int, @MaxOrder Int, @MinOrder Int, @Order Int, @AStorageItemID int, @Err nvarchar(4000)
    IF @Direction = 1 /* VK_LEFT*/
    /*Опасность существует только для верзнего узла перемещяемой ветки, поэтому проверяем только его */
	BEGIN
        /* выберем ParentID той записи, которая стоит выше уровнем    */        
        SELECT @DestinationParentID = ISNULL(ParentID, 0), @ParentAStorageItemID = ISNULL(AStorageItemID, 0),@Order = NodeOrder
        FROM AStorageScheme
        WHERE ID = (SELECT ISNULL(ParentID, 0) FROM AStorageScheme WHERE ID = @ID)
        IF @DestinationParentID IS NULL
            RETURN            

        SELECT @AStorageItemID = AStorageItemID FROM AStorageScheme WHERE ID = @ID    
        /*проверяем возможность перемещения*/            
        BEGIN TRY   		
            EXEC sp_AStorageScheme_Check @DestinationParentID, @AStorageItemID, @ID     
        END TRY
        BEGIN CATCH
            SET @Err = ERROR_MESSAGE()    
            RAISERROR(@Err, 16, 1)
            RETURN
        END CATCH;          
        
        /*Если в схеме больше нет связи между объектом и его родителем, то удаляем MAXCount*/
        EXEC sp_AStorageScheme_DeleteMaxCount @ID, @AStorageItemID, @ParentAStorageItemID
                       
        /* Подвигаем все записи после - вниз, там где вставили новую запись*/
        UPDATE AStorageScheme
        SET
            NodeOrder = NodeOrder + 1
        WHERE ISNULL(ParentID, 0) = @DestinationParentID AND NodeOrder >= @Order
        /*Подвигаем все записи откуда вышли - вверх*/
        UPDATE AStorageScheme
        SET
            NodeOrder = NodeOrder - 1
        WHERE ISNULL(ParentID, 0) = (SELECT ISNULL(ParentID, 0) FROM AStorageScheme WHERE ID = @ID) AND 
              NodeOrder > (SELECT NodeOrder FROM AStorageScheme WHERE ID = @ID)
        /*Устанавливаем себе номер порядка на новом месте*/
        UPDATE AStorageScheme
        SET
            ParentID = CASE WHEN @DestinationParentID = 0 THEN NULL ELSE @DestinationParentID END,
            NodeOrder = CASE WHEN @Order IS NULL THEN 1 ELSE @Order END
        WHERE ID = @ID
        /*если двигается целая ветка, то нужно уменьшить левел всех чайлдов.*/
        UPDATE AStorageScheme
        SET [NodeLevel] = [NodeLevel] - 1
        WHERE ID IN (SELECT ID FROM fn_AStorageSchemeNode_Select(@ID))
    END
    ELSE

    IF @Direction = 2 /* VK_RIGHT*/
    BEGIN
        /* выберем ID той записи, которая стоит ниже уровнем    */
        SELECT @DestinationParentID = ID, @Order = NodeOrder
        FROM AStorageScheme
        WHERE NodeOrder = (SELECT NodeOrder + 1 FROM AStorageScheme WHERE ID = @ID) AND 
              ISNULL(ParentID, 0) = (SELECT ISNULL(ParentID, 0) FROM AStorageScheme WHERE ID = @ID)
        /* Если мы в конце, то некуда двигаться вообще*/
        IF @DestinationParentID IS NULL
        	RETURN
        /* Получаем к какому итему принадлежит текущий родитель узла (для MaxCounta используется)*/    
      	SELECT @ParentAStorageItemID = ISNULL(AStorageItemID, 0)
        FROM AStorageScheme
        WHERE ID = (SELECT ISNULL(ParentID, 0) FROM AStorageScheme WHERE ID = @ID)
        /*проверяем возможность перемещения*/    
        SELECT @AStorageItemID = AStorageItemID FROM AStorageScheme WHERE ID = @ID    
        BEGIN TRY   		
            EXEC sp_AStorageScheme_Check @DestinationParentID, @AStorageItemID, @ID     
        END TRY
        BEGIN CATCH
            SET @Err = ERROR_MESSAGE()    
            RAISERROR(@Err, 16, 1)
            RETURN
        END CATCH;
        /*Если в схеме больше нет связи между объектом и его родителем, то удаляем MAXCount*/
        EXEC sp_AStorageScheme_DeleteMaxCount @ID, @AStorageItemID, @ParentAStorageItemID        
        /* Подвигаем все записи после - вниз, мы вставили новую запись*/
        UPDATE AStorageScheme
        SET
            NodeOrder = NodeOrder + 1
        WHERE ISNULL(ParentID, 0) = @DestinationParentID
        /*Подвигаем все записи откуда вышли - вверх*/
        UPDATE AStorageScheme
        SET
            NodeOrder = NodeOrder - 1
        WHERE ISNULL(ParentID, 0) = (SELECT ISNULL(ParentID, 0) FROM AStorageScheme WHERE ID = @ID) AND 
             NodeOrder > (SELECT NodeOrder FROM AStorageScheme WHERE ID = @ID)
        /*Устанавливаем себе номер порядка на новом месте*/
        UPDATE AStorageScheme
        SET 
           ParentID = CASE WHEN @DestinationParentID = 0 THEN NULL ELSE @DestinationParentID END,
           NodeOrder = 1 /*ставим всегда вначало*/
        WHERE ID = @ID
        /*если двигали целую ветку, то проапдейтим левел + 1*/
        UPDATE AStorageScheme
        SET [NodeLevel] = [NodeLevel] + 1
        WHERE ID IN (SELECT ID FROM fn_AStorageSchemeNode_Select(@ID))
    END
    ELSE

    IF @Direction = 3 /* VK_UP*/
    BEGIN
        /*выбрали текущий парент, это у нас группирующий флаг, а так же текущее значение порядка*/
        SELECT @DestinationParentID = ISNULL(ParentID, 0), @Order = NodeOrder
        FROM AStorageScheme WHERE ID = @ID
        /*выберем предыдущий порядок*/
        SELECT TOP 1 @Order = NodeOrder
        FROM AStorageScheme
        WHERE ISNULL(ParentID, 0) = @DestinationParentID AND NodeOrder < @Order
        ORDER BY NodeOrder DESC
        /*сдвинем предыдущую запись вниз, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE AStorageScheme
            SET NodeOrder = NodeOrder + 1
            WHERE NodeOrder = @Order AND ISNULL(ParentID, 0) = @DestinationParentID
        ELSE
            SET @Order = 1
       /*наконец проставим себе индекс если возможно*/
       UPDATE AStorageScheme
       SET NodeOrder = @Order
       WHERE ID = @ID
    END
    ELSE

    IF @Direction = 4 /* VK_DOWN*/
    BEGIN
        /*выбрали текущий парент, это у нас группирующий флаг, а так же текущее значение порядка*/
        SELECT @DestinationParentID = ISNULL(ParentID, 0), @Order = NodeOrder
        FROM AStorageScheme WHERE ID = @ID
        /*выберем следующий порядок*/
        SELECT TOP 1 @Order = NodeOrder
        FROM AStorageScheme
        WHERE ISNULL(ParentID, 0) = @DestinationParentID AND NodeOrder > @Order
        ORDER BY NodeOrder
        /*сдвинем след. запись вверх, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE AStorageScheme
            SET NodeOrder = NodeOrder - 1
            WHERE NodeOrder = @Order AND ISNULL(ParentID, 0) = @DestinationParentID
        ELSE
            SET @Order = (SELECT MAX(NodeOrder + 1) FROM AStorageScheme WHERE ISNULL(ParentID, 0) = @DestinationParentID)
       /*наконец проставим себе индекс если возможно*/
       IF @Order IS NULL
           SET @Order = 1
       UPDATE AStorageScheme
       SET NodeOrder = @Order
       WHERE ID = @ID
    END
END
GO