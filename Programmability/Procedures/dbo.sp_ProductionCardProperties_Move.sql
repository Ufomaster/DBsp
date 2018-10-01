SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
--$Create:     Oleynik Yuriy$    $Create date:   26.12.2011$
--$Modify:     Oleynik Yuriy$    $Modify date:   26.12.2011$
--$Version:    1.00$   $Description: Перемещение ветви дерева$
CREATE PROCEDURE [dbo].[sp_ProductionCardProperties_Move]
    @ID Int, /*праймари кей записи свойств*/
    @Direction Int
AS
BEGIN
	SET NOCOUNT ON
    
    IF ((@Direction = 1) OR (@Direction = 2)) AND NOT EXISTS(SELECT * FROM ObjectTypesAttributes ota 
                  WHERE ota.AttributeID = 4 AND ota.ObjectTypeID = (SELECT a.ObjectTypeID FROM ProductionCardProperties a WHERE ID = @ID))
    BEGIN
        RAISERROR('Перемещение значений запрещено', 16, 1)
        RETURN
    END

    DECLARE @DestinationParentID Int, @MaxOrder Int, @MinOrder Int, @Order Int,
        @FilterType Int
    IF @Direction = 1 /* VK_LEFT*/
    BEGIN
        /* выберем ParentID той записи, которая стоит выше уровнем    */
        SELECT @DestinationParentID = ISNULL(ParentID, 0), @Order = NodeOrder
        FROM dbo.ProductionCardProperties
        WHERE ID = (SELECT ISNULL(ParentID, 0) FROM dbo.ProductionCardProperties WHERE ID = @ID)
        IF @DestinationParentID IS NULL
            RETURN
        /*выбираем фильтр нашего парента, чтобы не терять записи*/
        --SELECT @FilterType = FilterType FROM dbo.ObjectTypes WHERE ID = @DestinationParentID
        
        /* Подвигаем все записи после - вниз, там где вставили новую запись*/
        UPDATE dbo.ProductionCardProperties
        SET
            NodeOrder = NodeOrder + 1
        WHERE ISNULL(ParentID, 0) = @DestinationParentID AND NodeOrder >= @Order
        /*Подвигаем все записи откуда вышли - вверх*/
        UPDATE dbo.ProductionCardProperties
        SET
            NodeOrder = NodeOrder - 1
        WHERE ISNULL(ParentID, 0) = (SELECT ISNULL(ParentID, 0) FROM dbo.ProductionCardProperties WHERE ID = @ID) AND 
              NodeOrder > (SELECT NodeOrder FROM dbo.ProductionCardProperties WHERE ID = @ID)
        /*Устанавливаем себе номер порядка на новом месте*/
        UPDATE dbo.ProductionCardProperties
        SET
            ParentID = CASE WHEN @DestinationParentID = 0 THEN NULL ELSE @DestinationParentID END,
            NodeOrder = CASE WHEN @Order IS NULL THEN 1 ELSE @Order END,
            NodeLevel = NodeLevel - 1
        WHERE ID = @ID
        /*если двигается целая ветка, то нужно уменьшить левел всех чайлдов.*/
        UPDATE dbo.ProductionCardProperties
        SET NodeLevel = NodeLevel - 1
        WHERE ID IN (SELECT ID FROM fn_ProductionCardPropertiesNode_Select(@ID))
    END
    ELSE

    IF @Direction = 2 /* VK_RIGHT*/
    BEGIN
        /* выберем ID той записи, которая стоит ниже уровнем    */
        SELECT @DestinationParentID = ID, @Order = NodeOrder
        FROM dbo.ProductionCardProperties
        WHERE NodeOrder = (SELECT NodeOrder + 1 FROM dbo.ProductionCardProperties WHERE ID = @ID) AND 
              ISNULL(ParentID, 0) = (SELECT ISNULL(ParentID, 0) FROM dbo.ProductionCardProperties WHERE ID = @ID)
        /* Если мы в конце, то некуда двигаться вообще*/
        IF @DestinationParentID IS NOT NULL
        BEGIN
            /*выбираем фильтр нашего парента, чтобы не терять записи*/
--            SELECT @FilterType = FilterType FROM dbo.ObjectTypes WHERE ID = @DestinationParentID
            
            /* Подвигаем все записи после - вниз, мы вставили новую запись*/
            UPDATE dbo.ProductionCardProperties
            SET
                NodeOrder = NodeOrder + 1
            WHERE ISNULL(ParentID, 0) = @DestinationParentID
            /*Подвигаем все записи откуда вышли - вверх*/
            UPDATE dbo.ProductionCardProperties
            SET
                NodeOrder = NodeOrder - 1
            WHERE ISNULL(ParentID, 0) = (SELECT ISNULL(ParentID, 0) FROM dbo.ProductionCardProperties WHERE ID = @ID) AND 
                 NodeOrder > (SELECT NodeOrder FROM dbo.ProductionCardProperties WHERE ID = @ID)
            /*Устанавливаем себе номер порядка на новом месте*/
            UPDATE dbo.ProductionCardProperties
            SET 
               ParentID = CASE WHEN @DestinationParentID = 0 THEN NULL ELSE @DestinationParentID END,
               NodeOrder = 1, /*ставим всегда вначало*/
               NodeLevel = NodeLevel + 1
            WHERE ID = @ID
            /*если двигали целую ветку, то проапдейтим левел + 1*/
            UPDATE dbo.ProductionCardProperties
            SET NodeLevel = NodeLevel + 1
            WHERE ID IN (SELECT ID FROM fn_ProductionCardPropertiesNode_Select(@ID))
        END
    END
    ELSE

    IF @Direction = 3 /* VK_UP*/
    BEGIN
        /*выбрали текущий парент, это у нас группирующий флаг, а так же текущее значение порядка*/
        SELECT @DestinationParentID = ISNULL(ParentID, 0), @Order = NodeOrder
        FROM dbo.ProductionCardProperties WHERE ID = @ID
        /*выберем предидущий порядок*/
        SELECT TOP 1 @Order = NodeOrder
        FROM dbo.ProductionCardProperties
        WHERE ISNULL(ParentID, 0) = @DestinationParentID AND NodeOrder < @Order
        ORDER BY NodeOrder DESC
        /*сдвинем предыдущую запись вниз, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE dbo.ProductionCardProperties
            SET NodeOrder = NodeOrder + 1
            WHERE NodeOrder = @Order AND ISNULL(ParentID, 0) = @DestinationParentID
        ELSE
            SET @Order = 1
       /*наконец проставим себе индекс если возможно*/
       UPDATE dbo.ProductionCardProperties
       SET NodeOrder = @Order
       WHERE ID = @ID
    END
    ELSE

    IF @Direction = 4 /* VK_DOWN*/
    BEGIN
        /*выбрали текущий парент, это у нас группирующий флаг, а так же текущее значение порядка*/
        SELECT @DestinationParentID = ISNULL(ParentID, 0), @Order = NodeOrder
        FROM dbo.ProductionCardProperties WHERE ID = @ID
        /*выберем следующий порядок*/
        SELECT TOP 1 @Order = NodeOrder
        FROM dbo.ProductionCardProperties
        WHERE ISNULL(ParentID, 0) = @DestinationParentID AND NodeOrder > @Order
        ORDER BY NodeOrder
        /*сдвинем след. запись вверх, если есть что сдвигать*/
        IF @Order IS NOT NULL
            UPDATE dbo.ProductionCardProperties
            SET NodeOrder = NodeOrder - 1
            WHERE NodeOrder = @Order AND ISNULL(ParentID, 0) = @DestinationParentID
        ELSE
            SET @Order = (SELECT MAX(NodeOrder + 1) FROM dbo.ProductionCardProperties WHERE ISNULL(ParentID, 0) = @DestinationParentID)
       /*наконец проставим себе индекс если возможно*/
       IF @Order IS NULL
           SET @Order = 1
       UPDATE dbo.ProductionCardProperties
       SET NodeOrder = @Order
       WHERE ID = @ID
    END
END
GO